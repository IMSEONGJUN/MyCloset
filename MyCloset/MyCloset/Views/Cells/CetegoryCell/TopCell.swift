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

class TopCell: UICollectionViewCell {
    
    
    static let identifier = "TopCell"
    private let titleLabel = UILabel()
    var selectedIndexPath: [IndexPath] = []
    var isChecked = false
    let flowLayout = UICollectionViewFlowLayout()
    var imageFromServer = UIImage()
    let imageView = UIImageView()
    
    var topCompleteDownloadFile = 0
    var topFileCount = 0
    
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
        setImageFromStorage()
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
    
    func setImageFromStorage() {
        let storageRef = Storage.storage().reference(forURL: "gs://myclosetnew-2f1ef.appspot.com").child("items/")
        
        let topRef = storageRef.child("top/")
        
        var fileCount = 0
        
        func setTopCell(num: Int) {
            topRef.child("top"+"\(num)"+".png").getData(maxSize: 9024 * 9024) { (data, error) in
                if let err = error {
                    print(err)
                } else {
                    self.imageFromServer = UIImage(data: data!)!
                    DataManager.shared.top.updateValue(self.imageFromServer, forKey: "top"+"\(num)")
                    //                    self.acc.append(self.acc0)
                    
                    //MARK: ViewDidLoad에서 여기로 바꿨음.
                    self.topCompleteDownloadFile += 1
                    
                    
                    if self.topFileCount == self.topCompleteDownloadFile {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
        topRef.listAll { (StorageListResult, Error) in
            
            if Error == nil {
                fileCount = StorageListResult.items.count
                print("top file count", fileCount)
                self.topFileCount = fileCount
                for i in 0..<fileCount {
                    setTopCell(num: i)
                }
            }
        }
    }
    
}



extension TopCell: UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemCount: Int!
        
        itemCount = DataManager.shared.top.count
        
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell!
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: MyClosetInnerCollectionViewCell.identifier, for: indexPath) as! MyClosetInnerCollectionViewCell
        
        customCell.configure(image: DataManager.shared.top["top"+"\(indexPath.item)"])
        print("top reload")
        
        cell = customCell
        cell.backgroundColor = .white
        
        return cell
    }
}

extension TopCell: MyClosetViewControllerDelegate {
    func secondReloadRequest() {
        print("Top reloaded")
        self.collectionView.reloadData()
    }
}

extension TopCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MyClosetInnerCollectionViewCell
        let seletedTopImage: UIImage = cell.imageView.image!
        DataManager.shared.selectedImageSet.updateValue(seletedTopImage, forKey: "top")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        DataManager.shared.selectedImageSet.removeValue(forKey: "top")
    }
}
