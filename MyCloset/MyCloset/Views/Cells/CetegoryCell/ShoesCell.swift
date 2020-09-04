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

class ShoesCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    static let identifier = "ShoesCell"
    private let titleLabel = UILabel()
    var selectedIndexPath: [IndexPath] = []
    var isChecked = false
    let flowLayout = UICollectionViewFlowLayout()
    var imageFromServer = UIImage()
    
    var shoesCompleteDownloadFile = 0
    var shoesFileCount = 0
    
    lazy var collectionView = UICollectionView(
        frame: self.contentView.frame, collectionViewLayout: flowLayout
    )
    
    // MARK: Init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.setupConstraints()
        fetchImageFromStorage()
    }
    
    deinit {
        print("deinit")
    }
    
    // MARK: Setup
    
    private func setupViews() {
        self.clipsToBounds = true
        //imageView
        
        imageView.image = UIImage(named: "cellimage")
        collectionView.backgroundView = imageView
        self.contentView.shadow()
        setupFlowLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MyClosetInnerCollectionViewCell.self, forCellWithReuseIdentifier: MyClosetInnerCollectionViewCell.identifier)
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
            $0.top.bottom.trailing.leading.equalToSuperview()
        }
    }
    
    // MARK: Configure Cell
    func configure(image: UIImage?, title: String) {
        titleLabel.text = title
    }
    
    //MARK: Firebase Storage
    
    func fetchImageFromStorage() {
        let storageRef = Storage.storage().reference(forURL: "gs://myclosetnew-2f1ef.appspot.com").child("items/")
        let shoesRef = storageRef.child("shoes/")
        
        shoesRef.listAll { (storageListResult, error) in
            if let error = error {
                print(error)
                return
            }
            
            let fileCount = storageListResult.items.count
            self.shoesFileCount = fileCount
            print("shoes file count", fileCount)
        
            (0..<fileCount).forEach({
                let num = $0
                shoesRef.child("shoes"+"\(num)"+".png").getData(maxSize: 9024 * 9024) { (data, error) in
                    if let err = error {
                        print(err)
                    }
                    
                    self.imageFromServer = UIImage(data: data!)!
                    DataManager.shared.shoes.updateValue(self.imageFromServer, forKey: "shoes"+"\(num)")
                    
                    self.shoesCompleteDownloadFile += 1
                    
                    if self.shoesFileCount == self.shoesCompleteDownloadFile {
                        self.collectionView.reloadData()
                    }
                }
            })
        }
    }
    
}



extension ShoesCell: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.shared.shoes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyClosetInnerCollectionViewCell.identifier, for: indexPath) as! MyClosetInnerCollectionViewCell
        
        cell.configure(image: DataManager.shared.shoes["shoes"+"\(indexPath.item)"])
        cell.backgroundColor = .white
        print("shoes reload")
        return cell
    }
}

extension ShoesCell: MyClosetViewControllerDelegate {
    func secondReloadRequest() {
        print("Shoes reloaded")
        self.collectionView.reloadData()
    }
}

extension ShoesCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MyClosetInnerCollectionViewCell
        let seletedShoesImage: UIImage = cell.imageView.image!
        DataManager.shared.selectedImageSet.updateValue(seletedShoesImage, forKey: "shoes")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        DataManager.shared.selectedImageSet.removeValue(forKey: "shoes")
    }
}
