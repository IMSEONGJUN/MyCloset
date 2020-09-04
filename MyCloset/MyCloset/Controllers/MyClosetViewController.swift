//
//  MyClosetViewController.swift
//  MyCloset
//
//  Created by SEONGJUN on 2020/01/31.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import Firebase

protocol MyClosetViewControllerDelegate: class {
    func secondReloadRequest()
}

class MyClosetViewController: UIViewController {
    
    // MARK: - Properties
    let addNewClothesButton = UIButton()
    let makeCodiButton = UIButton()
    
    var delegates = [MyClosetViewControllerDelegate?](repeating: nil, count: 8)
    
    let flowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)

    
    // MARK: - Life Cycle
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
    
    
    // MARK: - Initial Setup
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
    
    
    // MARK: - Action Handler
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
    
}


// MARK: - UICollectionViewDataSource
extension MyClosetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryCellType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellType = CategoryCellType(rawValue: indexPath.item) else { fatalError() }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.cellID, for: indexPath)
        return cellType.typeCasting(contoller: self, cell: cell)
    }
}


// MARK: - CameraCustomViewControllerDelegate
extension MyClosetViewController: CameraCustomViewControllerDelegate {
    func reloadRequest() {
        self.delegates.forEach({$0?.secondReloadRequest()})
    }
}
