//
//  AccCollectionViewCell.swift
//  MyCloset
//
//  Created by SEONGJUN on 2020/01/31.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class AccCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "AccCell"
    var selectedIndexPath: [IndexPath] = []
    let flowLayout = UICollectionViewFlowLayout()
    let imageView = UIImageView()
    lazy var collectionView = UICollectionView(frame: self.contentView.frame, collectionViewLayout: flowLayout)
    var token: NSObjectProtocol?
    
    // MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.setupConstraints()
        fetchImageFromStorage()
        configureNotification()
    }
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    // MARK: - AddObserver to Noti
    func configureNotification() {
        token = NotificationCenter.default.addObserver(forName: Notifications.newImagePushed, object: nil, queue: .main, using: { [weak self] noti in
            print("acc noti")
            self?.fetchImageFromStorage()
        })
    }
    
    
    // MARK: - Initial Setup for UI
    private func setupViews() {
        self.clipsToBounds = true
        setupFlowLayout()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        contentView.addSubview(collectionView)
        imageView.image = UIImage(named: "cellimage")
        collectionView.backgroundView = imageView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MyClosetInnerCollectionViewCell.self,
                                forCellWithReuseIdentifier: MyClosetInnerCollectionViewCell.identifier)
        collectionView.allowsMultipleSelection = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: -30)
    }
    
    private func setupFlowLayout() {
        flowLayout.itemSize = CGSize(width: contentView.frame.height * 0.6 , height: contentView.frame.height * 0.6)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        flowLayout.scrollDirection = .horizontal
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    // MARK: - Cell Setter
    func fetchImageFromStorage() {
        APIManager.shared.fetchImageFromFirebase(category: "acc") { (result) in
            switch result {
            case .success(let images):
                for (idx,image) in images.enumerated() {
                    DataManager.shared.acc.updateValue(image, forKey: "acc"+"\(idx)")
                }
                self.collectionView.reloadData()
            case .failure(let error):
                print("failed to fetch acc images: ", error)
            }
        }
    }
    
}


// MARK: - UICollectionViewDataSource
extension AccCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.shared.acc.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyClosetInnerCollectionViewCell.identifier,
                                                      for: indexPath) as! MyClosetInnerCollectionViewCell
        cell.configure(image: DataManager.shared.acc["acc"+"\(indexPath.item)"])
        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension AccCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MyClosetInnerCollectionViewCell
        guard let seletedAccImage = cell.imageView.image else { return }
        DataManager.shared.selectedImageSet.updateValue(seletedAccImage, forKey: "acc")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        DataManager.shared.selectedImageSet.removeValue(forKey: "acc")
    }
}
