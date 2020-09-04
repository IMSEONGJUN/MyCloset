
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

class BottomCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    static let identifier = "BottomCell"
    private let titleLabel = UILabel()
    var selectedIndexPath: [IndexPath] = []
    var isChecked = false
    let flowLayout = UICollectionViewFlowLayout()
    var imageFromServer = UIImage()
    
    var bottomCompleteDownloadFile = 0
    var bottomFileCount = 0
    
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
        
        let bottomRef = storageRef.child("bottom/")
        
        var fileCount = 0
//        var fileName = ""
//        var category: [UIImage] = []
        
        func setBottomCell(num: Int) {
            bottomRef.child("bottom"+"\(num)"+".png").getData(maxSize: 9024 * 9024) { (data, error) in
                if let err = error {
                    print(err)
                } else {
                    self.imageFromServer = UIImage(data: data!)!
                    DataManager.shared.bottom.updateValue(self.imageFromServer, forKey: "bottom"+"\(num)")
                    //                    self.acc.append(self.acc0)
                    
                    //MARK: ViewDidLoad에서 여기로 바꿨음.
                    self.bottomCompleteDownloadFile += 1
                    
                    
                    if self.bottomFileCount == self.bottomCompleteDownloadFile {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
        bottomRef.listAll { (StorageListResult, Error) in
            
            if Error == nil {
                fileCount = StorageListResult.items.count
                print("bottom file count", fileCount)
                self.bottomFileCount = fileCount
                for i in 0..<fileCount {
                    setBottomCell(num: i)
                }
            }
        }
    }
    
}



extension BottomCell: UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemCount: Int!
        
        itemCount = DataManager.shared.bottom.count
        
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell!
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: MyClosetInnerCollectionViewCell.identifier, for: indexPath) as! MyClosetInnerCollectionViewCell
        
        customCell.configure(image: DataManager.shared.bottom["bottom"+"\(indexPath.item)"])
        print("bottom reload")
        
        cell = customCell
        cell.backgroundColor = .white
        
        return cell
    }
}

extension BottomCell: MyClosetViewControllerDelegate {
    func secondReloadRequest() {
        print("Bottom reloaded")
        self.collectionView.reloadData()
    }
}

extension BottomCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MyClosetInnerCollectionViewCell
        let seletedBottomImage: UIImage = cell.imageView.image!
        DataManager.shared.selectedImageSet.updateValue(seletedBottomImage, forKey: "bottom")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        DataManager.shared.selectedImageSet.removeValue(forKey: "bottom")
    }
}
