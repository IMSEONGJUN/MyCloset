//
//  TitleCell.swift
//  OurCloset
//
//  Created by SEONGJUN on 2020/01/31.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import SnapKit

class TitleCell: UICollectionViewCell {
    
    let label = UILabel()
    
    static let identifier = "TitleCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        drawLine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
//        backgroundColor = UIColor(named: "KeyColor")
        backgroundColor = .white
        label.text = "Recommended Style"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .black
        label.textAlignment = .left
        addSubview(label)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
        }
    }
}
