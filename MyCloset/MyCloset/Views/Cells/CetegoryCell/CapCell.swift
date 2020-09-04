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
    
    
    static let identifier = "CapCell"
    private let titleLabel = UILabel()
    var selectedIndexPath: [IndexPath] = []
    var isChecked = false
    
    let imageView = UIImageView()
    let flowLayout = UICollectionViewFlowLayout()
    
    var imageFromServer = UIImage()
    
    var capCompleteDownloadFile = 0
    var capFileCount = 0
    
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
        self.contentView.shadow()
        setupFlowLayout()
        imageView.image = UIImage(named: "cellimage")
        collectionView.backgroundView = imageView
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
        let capRef = storageRef.child("cap/")
        var fileCount = 0
        
        func setCapCell(num: Int) {
            capRef.child("cap"+"\(num)"+".png").getData(maxSize: 9024 * 9024) { (data, error) in
                if let err = error {
                    print(err)
                    return
                }
                self.imageFromServer = UIImage(data: data!)!
                DataManager.shared.cap.updateValue(self.imageFromServer, forKey: "cap"+"\(num)")
               
                self.capCompleteDownloadFile += 1
                
                if self.capFileCount == self.capCompleteDownloadFile {
                    self.collectionView.reloadData()
                }
            }
        }
        
        capRef.listAll { (StorageListResult, Error) in
            
            if Error == nil {
                fileCount = StorageListResult.items.count
                print("cap file count", fileCount)
                self.capFileCount = fileCount
                for i in 0..<fileCount {
                    setCapCell(num: i)
                }
            }
        }
    }
    
}



extension CapCell: UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemCount: Int!
        
        itemCount = DataManager.shared.cap.count
        
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell!
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: MyClosetInnerCollectionViewCell.identifier, for: indexPath) as! MyClosetInnerCollectionViewCell
        
        customCell.configure(image: DataManager.shared.cap["cap"+"\(indexPath.item)"])
        print("cap reload")
        
        cell = customCell
        cell.backgroundColor = .white
        
        return cell
    }
}

extension CapCell: MyClosetViewControllerDelegate {
    func secondReloadRequest() {
        print("Cap reloaded")
        self.collectionView.reloadData()
    }
}

extension CapCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MyClosetInnerCollectionViewCell
        let seletedCapImage: UIImage = cell.imageView.image!
        DataManager.shared.selectedImageSet.updateValue(seletedCapImage, forKey: "cap")
        print("after setting cap item")
        print(DataManager.shared.selectedImageSet["cap"])
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        DataManager.shared.selectedImageSet.removeValue(forKey: "cap")
    }
}
