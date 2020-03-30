//
//  PrevCodiViewController.swift
//  MyCloset
//
//  Created by SEONGJUN on 2020/01/31.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import FirebaseStorage

class PrevCodiViewController: UIViewController {
    
    var prevCodiData: [String:UIImage] = [:]
    var collection: UICollectionView!
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Previous CodiSet"
        configureCollection()
        
        
        refreshControl.tintColor = .blue
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        collection.refreshControl = refreshControl
        
    }
    
    @objc func reloadData() {
        setImageFromStorage()
        refreshControl.endRefreshing()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setImageFromStorage()
    }
    
    
    func setImageFromStorage() {
        let storageRef = Storage.storage().reference(forURL: "gs://thirdcloset-735f9.appspot.com")
        let codiRef = storageRef.child("codiSet/")
        var fileCount = 0

        codiRef.listAll { (StorageListResult, Error) in
            if Error == nil {
                fileCount = StorageListResult.items.count
                for i in 1...fileCount {
                    self.setCodiFile(ref: codiRef, num: i)
                }
            }
        }
    }
    
    
    func setCodiFile(ref: StorageReference, num: Int) {
        var imageFromServer = UIImage()
        ref.child("codiSet"+"\(num)"+".jpeg").getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let err = error {
                print(err)
            } else {
                imageFromServer = UIImage(data: data!)!
                CodiSingleton.shared.codiImages.updateValue(imageFromServer, forKey: "codiSet"+"\(num)"+".jpeg")
                self.prevCodiData = CodiSingleton.shared.codiImages
                self.collection.reloadData()
            }
        }
    }
    
    private func configureCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        let itemWidth = view.frame.width - 20
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 150)
        
        collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.dataSource = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellID")
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(_:)))
        collection.addGestureRecognizer(pinchGesture)
        view.addSubview(collection)
    }
    
    @objc func pinchGesture(_ sender: UIPinchGestureRecognizer) {
        collection.transform = collection.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1.0
    }
}

extension PrevCodiViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.prevCodiData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath)
        guard !CodiSingleton.shared.codiImages.isEmpty else { return cell }
        var imageArray: Array<UIImage> = []
        for key in self.prevCodiData.sorted(by: {$0.0 > $1.0}) {
            imageArray.append(key.value)
        }
        let imageView = UIImageView(image: imageArray[indexPath.item])
        imageView.frame = cell.contentView.frame
        cell.contentView.addSubview(imageView)
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        return cell
    }
}
