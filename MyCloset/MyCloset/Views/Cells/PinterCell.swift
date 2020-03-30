//
//  PinterCell.swift
//  OurCloset
//
//  Created by SEONGJUN on 2020/01/31.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

class PinterCell: UICollectionViewCell {
    
    static let identifier = "PinterCell"
    
    var image: UIImage! {
        didSet{
            imageView.image = image
        }
    }
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate lazy var verticalStackView: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [imageView, horizontalStackView])
        stack.axis = .vertical
        
        return stack
    }()
    
    fileprivate lazy var horizontalStackView: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [label])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        
        return stack
    }()
    
    fileprivate let label: UILabel = {
       let label = UILabel()
        label.text = ""
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        contentView.addSubview(verticalStackView)
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        horizontalStackView.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
