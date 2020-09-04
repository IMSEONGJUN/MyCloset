//
//  DetailViewController.swift
//  MyCloset
//
//  Created by SEONGJUN on 2020/01/31.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Properties
    let imageView = UIImageView()
    var titleStr = ""
    
    var imageViewHeightConst:NSLayoutConstraint!
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(_:)))
        view.addGestureRecognizer(pinchGesture)
        configureImageView()
        configureConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    
    // MARK: - Initial Setup for UI
    private func configureImageView() {
        title = self.titleStr
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300),
        ])
        imageViewHeightConst = imageView.heightAnchor.constraint(equalToConstant: 0)
        imageViewHeightConst.isActive = true
    }
    
    
    // MARK: - View Setter
    func set(image: UIImage) {
        let imageHeight = image.size.height
        let imageWidth = image.size.width
        let imageSizeRatio = (view.frame.width * 0.7) / imageWidth
        let constant = CGFloat(imageHeight * imageSizeRatio)
        imageViewHeightConst.constant = constant
        self.view.layoutIfNeeded()
        imageView.image = image
    }
    
    
    // MARK: - Action Handler
    @objc func pinchGesture(_ sender:UIPinchGestureRecognizer) {
        imageView.transform = imageView.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1.0
    }
}
