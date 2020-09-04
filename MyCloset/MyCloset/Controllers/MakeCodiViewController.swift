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

class MakeCodiViewController: UIViewController {
    
    // MARK: - Properties
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
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        distributeImages()
        configure()
        setView()
        setConstraints()
    }
    
    
    // MARK: - Initial Setup
    private func distributeImages() {
        let keys = DataManager.shared.selectedImageSet.keys
        for key in keys {
            switch key {
            case "cap":
                print("cap")
                self.capView.image = DataManager.shared.selectedImageSet[key]
                print(self.capView.image)
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
    
    
    // MARK: - Setup UI
    private func setView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        configureMakeCodiButton()
        configureCancelButton()
        configureImageViews()
    }
    
    private func configureMakeCodiButton() {
        view.addSubview(makeCodiButton)
        makeCodiButton.setTitle("Make CodiSet", for: .normal)
        makeCodiButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        makeCodiButton.setTitleColor(.white, for: .normal)
        makeCodiButton.backgroundColor = UIColor(named: "KeyColor")
        makeCodiButton.layer.cornerRadius = 7
        makeCodiButton.shadow()
        makeCodiButton.clipsToBounds = true
        makeCodiButton.addTarget(self, action: #selector(didTapMakeButton), for: .touchUpInside)
    }
    
    private func configureCancelButton() {
        view.addSubview(cancelButton)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        cancelButton.backgroundColor = UIColor(named: "codiColor")
        cancelButton.layer.cornerRadius = 7
        cancelButton.shadow()
        cancelButton.clipsToBounds = true
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    
    private func configureImageViews() {
        imageViews = [capView,outerView,topView,bottomView,shoesView,bagView,accView,socksView]
        imageViews.forEach{containerImageView.addSubview($0)}
        imageViews.forEach{containerImageView.bringSubviewToFront($0)}
        imageViews.forEach{
//            $0.backgroundColor = UIColor(named: "codiBackground")
            $0.backgroundColor = .white
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private func configure() {
        view.addSubview(containerImageView)
        containerImageView.image = UIImage(named: "codiset")
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
    
    
    // MARK: - Action Handler
    @objc private  func didTapMakeButton() {
        let image = containerImageView.asImage()
        guard let data = image.jpegData(compressionQuality: 0.1) else { return }
        APIManager.shared.uploadCodiSet(data: data) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print(error)
                self.presentAlert(title: "Fail", message: "저장에 실패했습니다. 다시 시도해주세요.")
                return
            }
            self.presentAlert(title: "Success", message: "코디가 저장되었습니다.")
        }
    }
    
    @objc private func didTapCancelButton() {
        DataManager.shared.selectedImageSet.removeAll()
        self.dismiss(animated: true)
    }
}
