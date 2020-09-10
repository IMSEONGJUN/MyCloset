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
    
    // MARK: - Properties
    var prevCodiData: [String:UIImage] = [:]
    var collection: UICollectionView!
    let refreshControl = UIRefreshControl()
    
    
    // MARK: - Life cycle
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchImageFromStorage()
    }
    
    
    // MARK: - Initial Setup for UI
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
    
    
    // MARK: - API Service
    func fetchImageFromStorage() {
        APIManager.shared.fetchPrevCodiImages { (error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            self.prevCodiData = DataManager.shared.codiImages
            self.collection.reloadData()
        }
    }

    
    // MARK: - Action Handler
    @objc func reloadData() {
        fetchImageFromStorage()
        refreshControl.endRefreshing()
    }
    
    @objc func pinchGesture(_ sender: UIPinchGestureRecognizer) {
        collection.transform = collection.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1.0
    }
}


// MARK: - UICollectionViewDataSource
extension PrevCodiViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.prevCodiData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath)
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UICollectionViewCell, indexPath: IndexPath) {
        guard !DataManager.shared.codiImages.isEmpty else { return }
        var imageArray: [UIImage] = []
        for dict in self.prevCodiData.sorted(by: {$0.0 > $1.0}) {
            imageArray.append(dict.value)
        }
        let imageView = UIImageView(image: imageArray[indexPath.item])
        imageView.frame = cell.contentView.frame
        cell.contentView.addSubview(imageView)
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
    }
}
