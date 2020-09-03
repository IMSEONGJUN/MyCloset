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

class APIManager {
    static let shared = APIManager()
    
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
    
    func uploadImageRemovedBackground(image: UIImage, category: CategoryButtonType, completion: @escaping (Error?) -> Void) {
        let meta = StorageMetadata()
        meta.contentType = "image/png"
        let filename = category.name
        let filenum = category.fileCount
        DataManager.shared.top.updateValue(image, forKey: "\(filename)\(filenum)")
        
        guard let data = image.pngData() else { return }
        let storageRef = Storage.storage().reference().child("items").child("\(filename)/").child("\(filename)" + "\(filenum).png")
        
        storageRef.putData(data, metadata: meta) { (_, error) in
            if error == nil {
                completion(nil)
            }
        }
    }
    
    func uploadCodiSet(data: Data, completion: @escaping (Error?) -> Void) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        let storageRef = Storage.storage().reference(forURL: "gs://thirdcloset-735f9.appspot.com")
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
}
