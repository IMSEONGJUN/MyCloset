//
//  MainScrollViewCell.swift
//  OurCloset
//
//  Created by SEONGJUN on 2020/01/31.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import SnapKit

class MainScrollViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "MainScrollViewCell"
    
    let data = ["04","main21", "01", "02",  "03", "05"]
    
    let imageView1 = UIImageView()
    let imageView2 = UIImageView()
    let imageView3 = UIImageView()
    let imageView4 = UIImageView()
    let imageView5 = UIImageView()
    let imageView6 = UIImageView()
    var imageViews = [UIImageView]()
    
    let blurView = UIView()
    let scrollView = UIScrollView()
    var scrollViewCurrentXOffset:CGFloat = 0
    
    let pageControlView = UIView()
    var pageControlViewWidthConst:NSLayoutConstraint!
    
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Initial Setup for UI
    private func configure() {
        configureImageViews()
        configurePageControlView()
        configureBlurView()
        configureScrollView()
    }
    
    func configureImageViews() {
        imageViews = [imageView1,imageView2,imageView3,imageView4,imageView5,imageView6]
        for (idx,imgView) in imageViews.enumerated() {
            imgView.image = UIImage(named: data[idx])
        }
        [imageView1,imageView2,imageView3,imageView4,imageView5,imageView6]
        .forEach{
            scrollView.addSubview($0)
            $0.contentMode = .scaleAspectFill
        }
    }
    
    func configurePageControlView() {
        pageControlView.backgroundColor = .white
        pageControlView.layer.cornerRadius = 3
        pageControlView.alpha = 0.6
    }
    
    func configureBlurView() {
        blurView.backgroundColor = .white
        blurView.alpha = 0
    }
    
    func configureScrollView() {
        contentView.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.addSubview(pageControlView)
        scrollView.bringSubviewToFront(pageControlView)
        
        scrollView.addSubview(blurView)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
        
        pageControlView.translatesAutoresizingMaskIntoConstraints = false
        pageControlView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 80).isActive = true
        pageControlView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        pageControlView.heightAnchor.constraint(equalToConstant: 3).isActive = true
        pageControlViewWidthConst = pageControlView.widthAnchor.constraint(equalTo: scrollView.widthAnchor,
                                                                           multiplier: 0.1)
        pageControlViewWidthConst.isActive = true
        
        imageView1.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.leading.equalTo(scrollView.snp.leading)
            $0.height.equalTo(scrollView.snp.height)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        imageView2.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.leading.equalTo(imageView1.snp.trailing)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        imageView3.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.leading.equalTo(imageView2.snp.trailing)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        imageView4.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.leading.equalTo(imageView3.snp.trailing)
            $0.width.equalTo(scrollView.snp.width)
            
        }
        
        imageView5.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.leading.equalTo(imageView4.snp.trailing)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        imageView6.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.leading.equalTo(imageView5.snp.trailing)
            $0.width.equalTo(scrollView.snp.width)
            $0.trailing.equalTo(scrollView.snp.trailing)
        }
        
        blurView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}


// MARK: - UIScrollViewDelegate
extension MainScrollViewCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > scrollViewCurrentXOffset {
            UIView.animate(withDuration: 0.1) {
                self.pageControlViewWidthConst.constant += self.scrollView.frame.width * 0.1
                self.layer.layoutIfNeeded()
            }
            scrollViewCurrentXOffset = scrollView.contentOffset.x
        } else if scrollView.contentOffset.x < scrollViewCurrentXOffset{
            UIView.animate(withDuration: 0.1) {
                self.pageControlViewWidthConst.constant -= self.scrollView.frame.width * 0.1
                self.layer.layoutIfNeeded()
            }
            scrollViewCurrentXOffset = scrollView.contentOffset.x
        }
    }
}


// MARK: - MainViewControllerDelegate
extension MainScrollViewCell: MainViewControllerDelegate {
    func controlAlphaValue(XoffSet: CGFloat) {
        self.scrollView.bringSubviewToFront(blurView)
        self.blurView.alpha = XoffSet
    }
    
    
}
