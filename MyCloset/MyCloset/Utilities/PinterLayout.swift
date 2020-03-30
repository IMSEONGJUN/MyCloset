//
//  PinterLayout.swift
//  OurCloset
//
//  Created by SEONGJUN on 2020/01/31.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit


protocol PinterLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, numberOfColumn: Int, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class PinterLayout: UICollectionViewFlowLayout {
    
    weak var delegate: PinterLayoutDelegate!
    
    var cache = [UICollectionViewLayoutAttributes]()
    
    private var initialYoffset:CGFloat = 0
    private var numberOfColumns = 0
    
    override init() {
        super.init()
    }
    
    convenience init(numberOfColumns: Int = 2, initialYoffset: CGFloat) {
        self.init()
        self.numberOfColumns = numberOfColumns
        self.initialYoffset = initialYoffset
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {return 0.0}
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard let collection = collectionView else {return}
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        
        let scrollViewCellframe = CGRect(x: 0, y: 0, width: contentWidth, height: collection.bounds.height * 0.6)
        let scrollViewCellAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: 0, section: 0))
        scrollViewCellAttributes.frame = scrollViewCellframe
        self.cache.append(scrollViewCellAttributes)
        
        let titleViewframe = CGRect(x: 0, y: collection.bounds.height * 0.6, width: contentWidth, height: collection.bounds.height * 0.1)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: 1, section: 0))
        attributes.frame = titleViewframe
        self.cache.append(attributes)
        
        var xOffset = [CGFloat]()
        var yOffset = [CGFloat](repeating: collection.bounds.height * 0.7, count: numberOfColumns)
        
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var columnToPlacePhoto = 0
        var photoHeight:CGFloat = 0
        var updatedContentHeight:CGFloat = 0
        
        for item in 2 ..< collection.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            photoHeight = delegate.collectionView(collection, numberOfColumn: numberOfColumns, heightForPhotoAtIndexPath: indexPath)
            
            let frame = CGRect(x: xOffset[columnToPlacePhoto], y: yOffset[columnToPlacePhoto], width: columnWidth, height: photoHeight)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            self.cache.append(attributes)
            
        
            yOffset[columnToPlacePhoto] = yOffset[columnToPlacePhoto] + photoHeight
            
            columnToPlacePhoto = columnToPlacePhoto < (numberOfColumns - 1) ? (columnToPlacePhoto + 1) : 0
            
            updatedContentHeight = yOffset.max() ?? yOffset[columnToPlacePhoto]
            
            contentHeight = updatedContentHeight
        }

    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache
    }
}
