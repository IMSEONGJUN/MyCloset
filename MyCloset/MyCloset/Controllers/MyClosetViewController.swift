//
//  MyClosetViewController.swift
//  MyCloset
//
//  Created by SEONGJUN on 2020/01/31.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import Firebase

protocol MyClosetViewControllerDelegate:class {
    func secondReloadRequest()
}

class MyClosetViewController: UIViewController {
    
    let addNewClothesButton = UIButton()
    let makeCodiButton = UIButton()
    
    var delegates = [MyClosetViewControllerDelegate?](repeating: nil, count: 8)
    
    let flowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setupUI()
        view.backgroundColor = UIColor(named: "cameraBG")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataManager.shared.selectedImageSet.removeAll()
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    private func setupUI() {
        
        addNewClothesButton.setTitle("옷 추가하기", for: .normal)
        addNewClothesButton.backgroundColor = UIColor(named: "textColor")
        addNewClothesButton.layer.cornerRadius = 7
        addNewClothesButton.shadow()
        addNewClothesButton.addTarget(self, action: #selector(didTapAddNewButton), for: .touchUpInside)
        
        makeCodiButton.setTitle("코디 만들기", for: .normal)
        makeCodiButton.backgroundColor = UIColor(named: "codiColor")
        makeCodiButton.layer.cornerRadius = 7
        makeCodiButton.shadow()
        makeCodiButton.addTarget(self, action: #selector(didTapMakeCodiButton), for: .touchUpInside)
        
        view.addSubview(addNewClothesButton)
        view.addSubview(makeCodiButton)
        view.bringSubviewToFront(addNewClothesButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        addNewClothesButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalToSuperview().multipliedBy(0.95)
            $0.height.equalTo(42)
        }
        
        makeCodiButton.snp.makeConstraints {
            $0.bottom.equalTo(addNewClothesButton.snp.top).offset(-5)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalToSuperview().multipliedBy(0.95)
            $0.height.equalTo(42)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.width.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(makeCodiButton.snp.top).offset(-10)
        }
    }
    
    @objc private func didTapAddNewButton() {
        let cameraVC = CameraCustomViewController()
        cameraVC.delegate = self
        cameraVC.modalPresentationStyle = .fullScreen
        present(cameraVC, animated: true)
    }
    
    @objc private func didTapMakeCodiButton() {
        let makeCodiVC = MakeCodiViewController()
        makeCodiVC.modalPresentationStyle = .fullScreen
        present(makeCodiVC, animated: true)
    }
    
    private func setupCollectionView() {
        setupFlowLayout()
        
        collectionView.backgroundColor = UIColor(named: "cameraBG")
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.register(AccCollectionViewCell.self, forCellWithReuseIdentifier: AccCollectionViewCell.identifier)
        collectionView.register(CapCell.self, forCellWithReuseIdentifier: CapCell.identifier)
        collectionView.register(OuterCell.self, forCellWithReuseIdentifier: OuterCell.identifier)
        collectionView.register(TopCell.self, forCellWithReuseIdentifier: TopCell.identifier)
        collectionView.register(BottomCell.self, forCellWithReuseIdentifier: BottomCell.identifier)
        collectionView.register(ShoesCell.self, forCellWithReuseIdentifier: ShoesCell.identifier)
        collectionView.register(BagCell.self, forCellWithReuseIdentifier: BagCell.identifier)
        collectionView.register(SocksCell.self, forCellWithReuseIdentifier: SocksCell.identifier)
        
        
        view.addSubview(collectionView)
        
    }
    
    private func setupFlowLayout() {
        flowLayout.itemSize = CGSize(width: view.frame.width , height: 150)
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        flowLayout.scrollDirection = .vertical
    }
    
}

extension MyClosetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        case 0:
            let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: CapCell.identifier, for: indexPath) as! CapCell
            customCell.configure(image: nil, title: "셀")
            self.delegates[0] = customCell
            return customCell
        case 1:
            let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: OuterCell.identifier, for: indexPath) as! OuterCell
            customCell.configure(image: nil, title: "셀")
            self.delegates[1] = customCell
            return customCell
        case 2:
            let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCell.identifier, for: indexPath) as! TopCell
            customCell.configure(image: nil, title: "셀")
            self.delegates[2] = customCell
            return customCell
        case 3:
            let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCell.identifier, for: indexPath) as! BottomCell
            customCell.configure(image: nil, title: "셀")
            self.delegates[3] = customCell
            return customCell
        case 4:
            let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoesCell.identifier, for: indexPath) as! ShoesCell
            customCell.configure(image: nil, title: "셀")
            self.delegates[4] = customCell
            return customCell
        case 5:
            let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: AccCollectionViewCell.identifier, for: indexPath) as! AccCollectionViewCell
            customCell.configure(image: nil, title: "셀")
            self.delegates[5] = customCell
            return customCell
        case 6:
            let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: BagCell.identifier, for: indexPath) as! BagCell
            customCell.configure(image: nil, title: "셀")
            self.delegates[6] = customCell
            return customCell
        case 7:
            let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: SocksCell.identifier, for: indexPath) as! SocksCell
            customCell.configure(image: nil, title: "셀")
            self.delegates[7] = customCell
            return customCell
        default:
            return UICollectionViewCell()
        }
    }
}

extension MyClosetViewController: CameraCustomViewControllerDelegate {
    func reloadRequest() {
        self.delegates.forEach({$0?.secondReloadRequest()})
    }
}
