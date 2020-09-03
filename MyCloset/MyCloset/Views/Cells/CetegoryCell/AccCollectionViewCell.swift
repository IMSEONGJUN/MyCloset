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
    
    static let identifier = "AccCell"
    
    private let titleLabel = UILabel()
    var selectedIndexPath: [IndexPath] = []
    var isChecked = false
    let flowLayout = UICollectionViewFlowLayout()
    var imageFromServer = UIImage()
    let imageView = UIImageView()
    
    var accCompleteDownloadFile = 0
    var accFileCount = 0
    
    lazy var collectionView = UICollectionView(
        frame: self.contentView.frame, collectionViewLayout: flowLayout
    )
    
    // MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fetchImageFromStorage()
    }
    
    deinit {
        print("deinit")
    }
    
    
    // MARK: - Setup
    private func setupViews() {
        self.clipsToBounds = true
        //imageView
        setupFlowLayout()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        contentView.addSubview(collectionView)
        imageView.image = UIImage(named: "cellimage")
        collectionView.backgroundView = imageView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MyClosetInnerCollectionViewCell.self, forCellWithReuseIdentifier: MyClosetInnerCollectionViewCell.identifier)
        collectionView.allowsMultipleSelection = true
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
    
    // MARK: Configure Cell
    func configure(image: UIImage?, title: String) {
        titleLabel.text = title
    }
    
    //MARK: Firebase Storage
    
    func fetchImageFromStorage() {
        let storageRef = Storage.storage().reference(forURL: "gs://thirdcloset-735f9.appspot.com").child("items/")
        let accRef = storageRef.child("acc/")
        
        var fileCount = 1
        
        func setAccCell(num: Int) {
            accRef.child("acc"+"\(num)"+".png").getData(maxSize: 1 * 520 * 520) { (data, error) in
                if let err = error {
                    print(err)
                } else {
                    self.imageFromServer = UIImage(data: data!)!
                    DataManager.shared.acc.updateValue(self.imageFromServer, forKey: "acc"+"\(num)")
                    //                    self.acc.append(self.acc0)
                    
                    //MARK: ViewDidLoad에서 여기로 바꿨음.
                    self.accCompleteDownloadFile += 1
                    
                    if num == 0 {
                        self.setupViews()
                        self.setupConstraints()
                    } else if self.accFileCount == self.accCompleteDownloadFile {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
        accRef.listAll { (StorageListResult, Error) in
            
            if Error == nil {
                fileCount = StorageListResult.items.count
                print("acc file count", fileCount)
                self.accFileCount = fileCount
                for i in 0...(fileCount-1) {
                    setAccCell(num: i)
                }
            }
        }
    }
    
}



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

extension AccCollectionViewCell: MyClosetViewControllerDelegate {
    func secondReloadRequest() {
        self.collectionView.reloadData()
    }
}

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
