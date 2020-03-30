//
//  MyClosetInnerCollectionViewCell.swift
//  MyCloset
//
//  Created by SEONGJUN on 2020/01/31.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

class MyClosetInnerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "InnerCell"
    let imageView = UIImageView()
    
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
    private let checkMark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        clipsToBounds = true
        layer.cornerRadius = 7
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowColor = UIColor.darkGray.cgColor
        
        imageView.contentMode = .scaleAspectFit
        backgroundView = imageView
        let selectedView = UIView()
        selectedBackgroundView = selectedView
        blurView.alpha = 0.5
        checkMark.tintColor = .systemBackground
        [blurView, checkMark].forEach {
            selectedView.addSubview($0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        blurView.frame = bounds
        checkMark.frame = CGRect(x: bounds.width - 46, y: bounds.height - 46, width: 40, height: 40)
        selectedBackgroundView?.frame = bounds
    }
    
    // MARK: Configure Cell
    func configure(image: UIImage?) {
        imageView.image = image
    }
}
