//
//  APIManager.swift
//  MyCloset
//
//  Created by SEONGJUN on 2020/09/03.
//  Copyright © 2020 pandaman. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwiftyLRUCache

class APIManager {
    static let shared = APIManager()
    
    let baseURL = "gs://myclosetnew-2f1ef.appspot.com"
    
    let itemImageCache = SwiftyLRUCache<String, UIImage>(capacity: 50)
    let codiImagesCache = SwiftyLRUCache<String, UIImage>(capacity: 20)
    
    private init() { }
    
    func uploadImageNotRemovedBackground(image: UIImage, completion: @escaping (Result<String,Error>) -> Void) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        guard let data = image.jpegData(compressionQuality: 0.1) else { return }
        let storageRef = Storage.storage().reference().child("images/image1")
        
        storageRef.putData(data, metadata: meta) { (_, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
                
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                let imageURL = url?.absoluteString ?? ""
                completion(.success(imageURL))
            }
        }
    }
    
    func uploadImageRemovedBackground(image: UIImage, category: CategoryButtonType,
                                      completion: @escaping (Error?) -> Void) {
        let meta = StorageMetadata()
        meta.contentType = "image/png"
        let filename = category.name
        let filenum = category.fileCount
        
        guard let data = image.pngData() else { return }
        let storageRef = Storage.storage().reference().child("items")
                                .child("\(filename)/").child("\(filename)" + "\(filenum).png")
        
        storageRef.putData(data, metadata: meta) { (_, error) in
            if error == nil {
                completion(nil)
            }
        }
    }
    
    func uploadCodiSet(data: Data, completion: @escaping (Error?) -> Void) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        let storageRef = Storage.storage().reference(forURL: baseURL)
        let codiRef = storageRef.child("codiSet/")
        
        codiRef.listAll { (StorageListResult, Error) in
            if Error == nil {
                let fileNum = StorageListResult.items.count
                codiRef.child("codiSet"+"\(fileNum + 1)"+".jpeg").putData(data, metadata: meta) { (_, error) in
                    if let error = error {
                        completion(error)
                        return
                    }
                    completion(nil)
                }
            }
        }
    }
    
    func fetchPrevCodiImages(completion: @escaping (Error?) -> Void) {
        let storageRef = Storage.storage().reference(forURL: baseURL)
        let codiRef = storageRef.child("codiSet/")
        var fileCount = 0

        codiRef.listAll { (storageListResult, error) in
            guard error == nil else { return }
            
            fileCount = storageListResult.items.count
            guard fileCount > 0 else { return }
            
            let group = DispatchGroup()
            for i in 1...fileCount {
                group.enter()
                self.setCodiFile(ref: codiRef, num: i) { error in
                    if let error = error {
                        print("failed to fetch a single codi image: codi Number: \(i)", error)
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                completion(nil)
            }
        }
    }
    
    func setCodiFile(ref: StorageReference, num: Int, completion: @escaping (Error?) -> Void) {
        let key = "codiSet"+"\(num)"+".jpeg"
        if let cachedImage = codiImagesCache.getValue(forKey: key) {
            DataManager.shared.codiImages.updateValue(cachedImage, forKey: key)
            return
        }
        
        ref.child("codiSet"+"\(num)"+".jpeg").getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let err = error {
                print(err)
                completion(err)
                return
            }
            guard let imageFromServer = UIImage(data: data!) else { return }
            DataManager.shared.codiImages.updateValue(imageFromServer, forKey: key)
            self.codiImagesCache.setValue(value: imageFromServer, forKey: key)
            completion(nil)
        }
    }
    
    func fetchImageFromFirebase(category: String, completion: @escaping (Result<[UIImage], Error>) -> Void ) {
        var images = [String : UIImage]()
        let storageRef = Storage.storage().reference(forURL: baseURL).child("items/")
        let ref = storageRef.child("\(category)/")
         
        ref.listAll { (storageListResult, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let currentFileCount = storageListResult.items.count
            print("\(category) file count", currentFileCount)
            
            let group = DispatchGroup()
            DispatchQueue.concurrentPerform(iterations: currentFileCount) { (num) in
                print("Dispatch Concurrent Perform iteration count: \(category) : ",num)
                print("Thread Check: ", Thread.isMainThread)
                let key = "\(category)"+"\(num)"+".png"
                if let cachedImage = self.itemImageCache.getValue(forKey: key) {
                    images.updateValue(cachedImage, forKey: key)
                    return
                }
                
                group.enter()
                ref.child("\(category)"+"\(num)"+".png").getData(maxSize: 9024 * 9024) { (data, error) in
                    if let err = error {
                        completion(.failure(err))
                        return
                    }
                    
                    guard let data = data, let imageFromServer = UIImage(data: data) else { return }
                    print("Image file: ", imageFromServer)
                    images.updateValue(imageFromServer, forKey: key)
                    self.itemImageCache.setValue(value: imageFromServer, forKey: key)
                    print("Dispatch Concurrent Perform iteration END: \(category) : ",num)
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                print("fetched images count: ", images.count)
                let sortedImages = images.sorted(by: {$0.0 < $1.0}).map{$0.value}
                completion(.success(sortedImages))
            }
        } 
    }

    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        guard isValidEmailAddress(email: email) && password.count >= 6 else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if let err = err {
                completion(err)
                return
            }
            let uid = user?.user.uid ?? ""
            let values = ["userName": email,
                          "email": password,
                          "uid": uid
                         ]
                
            Database.database().reference().child("users").child(uid).setValue(values) { (err, _) in
                if let err = err {
                    completion(err)
                    print("회원가입 실패")
                    return
                }
                print("회원가입이 완료되었습니다.")
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        guard isValidEmailAddress(email: email) && password.count >= 6 else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    func isValidEmailAddress(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
