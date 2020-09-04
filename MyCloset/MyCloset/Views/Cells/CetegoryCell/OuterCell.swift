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

class OuterCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    static let identifier = "OuterCell"
    private let titleLabel = UILabel()
    var selectedIndexPath: [IndexPath] = []
    var isChecked = false
    let flowLayout = UICollectionViewFlowLayout()
    var imageFromServer = UIImage()
    
    var outerCompleteDownloadFile = 0
    var outerFileCount = 0
    
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
        setupFlowLayout()
        collectionView.alwaysBounceHorizontal = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MyClosetInnerCollectionViewCell.self, forCellWithReuseIdentifier: MyClosetInnerCollectionViewCell.identifier)
        collectionView.allowsMultipleSelection = true
        contentView.addSubview(collectionView)
        
    }
    
    private func setupFlowLayout() {
        flowLayout.itemSize = CGSize(width: contentView.frame.height * 0.6 , height: contentView.frame.height * 0.6)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: -30)
        
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
        let outerRef = storageRef.child("outer/")
        
        outerRef.listAll { (storageListResult, error) in
            if let error = error {
                print(error)
                return
            }
            
            let fileCount = storageListResult.items.count
            self.outerFileCount = fileCount
            print("outer file count", fileCount)
        
            (0..<fileCount).forEach({
                let num = $0
                outerRef.child("outer"+"\(num)"+".png").getData(maxSize: 9024 * 9024) { (data, error) in
                    if let err = error {
                        print(err)
                    }
                    
                    self.imageFromServer = UIImage(data: data!)!
                    DataManager.shared.outer.updateValue(self.imageFromServer, forKey: "outer"+"\(num)")
                    
                    self.outerCompleteDownloadFile += 1
                    
                    if self.outerFileCount == self.outerCompleteDownloadFile {
                        self.collectionView.reloadData()
                    }
                }
            })
        }
    }
    
}



extension OuterCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.shared.outer.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyClosetInnerCollectionViewCell.identifier, for: indexPath) as! MyClosetInnerCollectionViewCell
        
        cell.configure(image: DataManager.shared.outer["outer"+"\(indexPath.item)"])
        cell.backgroundColor = .white
        print("outer reload")
        return cell
    }
}

extension OuterCell: MyClosetViewControllerDelegate {
    func secondReloadRequest() {
        print("Outer reloaded")
        self.collectionView.reloadData()
    }
}

extension OuterCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MyClosetInnerCollectionViewCell
        let seletedOuterImage: UIImage = cell.imageView.image!
        DataManager.shared.selectedImageSet.updateValue(seletedOuterImage, forKey: "outer")
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        DataManager.shared.selectedImageSet.removeValue(forKey: "outer")
    }
}
