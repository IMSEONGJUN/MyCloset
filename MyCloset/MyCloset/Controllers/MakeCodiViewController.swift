//
//  MakeCodiViewController.swift
//  MyCloset
//
//  Created by SEONGJUN on 2020/01/31.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class CodiSingleton {
    static let shared = CodiSingleton()
    var codiImages: [String:UIImage] = [:]
    private init(){}
}

class MakeCodiViewController: UIViewController {
    
    let containerImageView = UIImageView()
    
    let capView = UIImageView()
    let outerView = UIImageView()
    let topView = UIImageView()
    let bottomView = UIImageView()
    let shoesView = UIImageView()
    let bagView = UIImageView()
    let accView = UIImageView()
    let socksView = UIImageView()
    
    var imageViews = [UIImageView]()
    
    let makeCodiButton = UIButton()
    let cancelButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        distributeImages()
        setView()
        configure()
        setConstraints()
    }
    
    private func distributeImages() {
        let keys = DataManager.shared.selectedImageSet.keys
        for key in keys {
            switch key {
            case "cap":
                self.capView.image = DataManager.shared.selectedImageSet[key]
            case "outer":
                self.outerView.image = DataManager.shared.selectedImageSet[key]
            case "top":
                self.topView.image = DataManager.shared.selectedImageSet[key]
            case "bottom":
                self.bottomView.image = DataManager.shared.selectedImageSet[key]
            case "shoes":
                self.shoesView.image = DataManager.shared.selectedImageSet[key]
            case "bag":
                self.bagView.image = DataManager.shared.selectedImageSet[key]
            case "acc":
                self.accView.image = DataManager.shared.selectedImageSet[key]
            case "socks":
                self.socksView.image = DataManager.shared.selectedImageSet[key]
            default:
                break
            }
        }
    }
    
    private func setView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        makeCodiButton.setTitle("Make CodiSet", for: .normal)
        makeCodiButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        makeCodiButton.setTitleColor(.white, for: .normal)
        makeCodiButton.backgroundColor = UIColor(named: "KeyColor")
        makeCodiButton.layer.cornerRadius = 7
        makeCodiButton.shadow()
        makeCodiButton.clipsToBounds = true
        makeCodiButton.addTarget(self, action: #selector(didTapMakeButton), for: .touchUpInside)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        cancelButton.backgroundColor = UIColor(named: "codiColor")
        cancelButton.layer.cornerRadius = 7
        cancelButton.shadow()
        cancelButton.clipsToBounds = true
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        
        view.addSubview(cancelButton)
        view.addSubview(makeCodiButton)
        
        imageViews = [capView,outerView,topView,bottomView,shoesView,bagView,accView,socksView]
        imageViews.forEach{containerImageView.addSubview($0)}
        imageViews.forEach{containerImageView.bringSubviewToFront($0)}
        imageViews.forEach{
            $0.backgroundColor = UIColor(named: "codiBackground")
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFit}
        }
    
    private func configure() {
        view.addSubview(containerImageView)
        containerImageView.image = UIImage(named: "codiset")
    }
    
    @objc func didTapMakeButton() {
//        var fileNum = 0
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        let image = containerImageView.asImage()
        let data = image.jpegData(compressionQuality: 0.1)
        
        let storageRef = Storage.storage().reference(forURL: "gs://thirdcloset-735f9.appspot.com")
        let codiRef = storageRef.child("codiSet/")
        
        codiRef.listAll { (StorageListResult, Error) in
            if Error == nil {
                let fileNum = StorageListResult.items.count
                codiRef.child("codiSet"+"\(fileNum + 1)"+".jpeg").putData(data!, metadata: meta) { (_, error) in
                    if error == nil {
                        print("코디셋 업로드 성공")
                        let alert = UIAlertController(title: "Success", message: "코디가 저장되었습니다.", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "확인", style: .default) { (action) in
                            self.dismiss(animated: true)
                        }
                        alert.addAction(ok)
                        self.present(alert, animated: true)
                    } else {
                        let alert = UIAlertController(title: "Fail", message: "저장에 실패했습니다. 다시 시도해주세요.", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    @objc func didTapCancelButton() {
        DataManager.shared.selectedImageSet.removeAll()
        self.dismiss(animated: true)
    }
    
    private func setConstraints() {
        containerImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.7)
        }
        cancelButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.width.equalToSuperview().multipliedBy(0.95)
            $0.centerX.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.07)
        }
        
        makeCodiButton.snp.makeConstraints {
            $0.bottom.equalTo(cancelButton.snp.top).offset(-10)
            $0.width.equalToSuperview().multipliedBy(0.95)
            $0.centerX.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.07)
        }
        
        outerView.topAnchor.constraint(equalTo: containerImageView.topAnchor, constant: 50).isActive = true
        outerView.leadingAnchor.constraint(equalTo: containerImageView.leadingAnchor, constant: 50).isActive = true
        outerView.widthAnchor.constraint(equalTo: containerImageView.widthAnchor, multiplier: 0.26).isActive = true
        outerView.heightAnchor.constraint(equalTo: containerImageView.heightAnchor, multiplier: 0.3).isActive = true
        
        capView.topAnchor.constraint(equalTo: containerImageView.topAnchor, constant: 65).isActive = true
        capView.centerXAnchor.constraint(equalTo: containerImageView.centerXAnchor).isActive = true
        capView.widthAnchor.constraint(equalTo: containerImageView.widthAnchor, multiplier: 0.18).isActive = true
        capView.heightAnchor.constraint(equalTo: containerImageView.heightAnchor, multiplier: 0.15).isActive = true
        
        topView.topAnchor.constraint(equalTo: containerImageView.topAnchor, constant: 80).isActive = true
        topView.trailingAnchor.constraint(equalTo: containerImageView.trailingAnchor, constant: -45).isActive = true
        topView.widthAnchor.constraint(equalTo: containerImageView.widthAnchor, multiplier: 0.23).isActive = true
        topView.heightAnchor.constraint(equalTo: containerImageView.heightAnchor, multiplier: 0.3).isActive = true
        
        bottomView.bottomAnchor.constraint(equalTo: containerImageView.bottomAnchor, constant: -80).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: containerImageView.trailingAnchor, constant: -45).isActive = true
        bottomView.widthAnchor.constraint(equalTo: containerImageView.widthAnchor, multiplier: 0.23).isActive = true
        bottomView.heightAnchor.constraint(equalTo: containerImageView.heightAnchor, multiplier: 0.3).isActive = true
        
        bagView.leadingAnchor.constraint(equalTo: containerImageView.leadingAnchor, constant: 50).isActive = true
        bagView.centerYAnchor.constraint(equalTo: containerImageView.centerYAnchor, constant: 50).isActive = true
        bagView.widthAnchor.constraint(equalTo: containerImageView.widthAnchor, multiplier: 0.18).isActive = true
        bagView.heightAnchor.constraint(equalTo: containerImageView.heightAnchor, multiplier: 0.15).isActive = true
        
        socksView.bottomAnchor.constraint(equalTo: containerImageView.bottomAnchor, constant: -70).isActive = true
        socksView.leadingAnchor.constraint(equalTo: containerImageView.leadingAnchor, constant: 50).isActive = true
        socksView.widthAnchor.constraint(equalTo: containerImageView.widthAnchor, multiplier: 0.18).isActive = true
        socksView.heightAnchor.constraint(equalTo: containerImageView.heightAnchor, multiplier: 0.15).isActive = true
        
        shoesView.bottomAnchor.constraint(equalTo: containerImageView.bottomAnchor, constant: -70).isActive = true
        shoesView.centerXAnchor.constraint(equalTo: containerImageView.centerXAnchor).isActive = true
        shoesView.widthAnchor.constraint(equalTo: containerImageView.widthAnchor, multiplier: 0.18).isActive = true
        shoesView.heightAnchor.constraint(equalTo: containerImageView.heightAnchor, multiplier: 0.2).isActive = true
        
        accView.centerXAnchor.constraint(equalTo: containerImageView.centerXAnchor).isActive = true
        accView.centerYAnchor.constraint(equalTo: containerImageView.centerYAnchor, constant: -35).isActive = true
        accView.widthAnchor.constraint(equalTo: containerImageView.widthAnchor, multiplier: 0.18).isActive = true
        accView.heightAnchor.constraint(equalTo: containerImageView.heightAnchor, multiplier: 0.15).isActive = true
    }
}
