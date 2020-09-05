//
//  CapCell.swift
//  MyCloset
//
//  Created by SEONGJUN on 2020/01/31.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class CapCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "CapCell"
    private let titleLabel = UILabel()
    var selectedIndexPath: [IndexPath] = []
    let imageView = UIImageView()
    let flowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: self.contentView.frame, collectionViewLayout: flowLayout)
    
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.setupConstraints()
        fetchImageFromStorage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit")
    }
    
    
    // MARK: - Initial Setup for UI
    private func setupViews() {
        self.clipsToBounds = true
        self.contentView.shadow()
        setupFlowLayout()
        imageView.image = UIImage(named: "cellimage")
        collectionView.backgroundView = imageView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MyClosetInnerCollectionViewCell.self,
                                forCellWithReuseIdentifier: MyClosetInnerCollectionViewCell.identifier)
        collectionView.allowsMultipleSelection = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: -30)
        collectionView.alwaysBounceHorizontal = true
        contentView.addSubview(collectionView)
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
    func configure(title: String) {
        titleLabel.text = title
    }
    
    func fetchImageFromStorage() {
        APIManager.shared.fetchImageFromFirebase(category: "cap") { (result) in
            switch result {
            case .success(let images):
                for (idx,image) in images.enumerated() {
                    DataManager.shared.cap.updateValue(image, forKey: "cap"+"\(idx)")
                }
                self.collectionView.reloadData()
            case .failure(let error):
                print("failed to fetch cap images: ", error)
            }
        }
    }
    
}


// MARK: - UICollectionViewDataSource
extension CapCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.shared.cap.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyClosetInnerCollectionViewCell.identifier, for: indexPath) as! MyClosetInnerCollectionViewCell
        
        cell.configure(image: DataManager.shared.cap["cap"+"\(indexPath.item)"])
        cell.backgroundColor = .white
        print("cap reload")
        return cell
    }
}


// MARK: - MyClosetViewControllerDelegate
extension CapCell: MyClosetViewControllerDelegate {
    func secondReloadRequest() {
        print("Cap reloaded")
        self.collectionView.reloadData()
    }
}


// MARK: - UICollectionViewDelegate
extension CapCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MyClosetInnerCollectionViewCell
        let seletedCapImage: UIImage = cell.imageView.image!
        DataManager.shared.selectedImageSet.updateValue(seletedCapImage, forKey: "cap")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        DataManager.shared.selectedImageSet.removeValue(forKey: "cap")
    }
}
