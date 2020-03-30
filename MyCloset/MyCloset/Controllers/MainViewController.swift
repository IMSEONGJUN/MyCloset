//
//  MainViewController.swift
//  MyCloset
//
//  Created by SEONGJUN on 2020/01/31.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import SnapKit
import SafariServices


protocol MainViewControllerDelegate: class {
    func controlAlphaValue(XoffSet: CGFloat)
}


class MainViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    weak var delegate: MainViewControllerDelegate?
    
    var data: Array<String> = []
    
    let weatherButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        configureCollectionView()
        configureWeatherButton()
        
        for num in 0...66 {
            data.append("main"+"\(num)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configureWeatherButton(){
        weatherButton.setImage(UIImage(systemName: "sun.max.fill",withConfiguration:UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)), for: .normal)
        weatherButton.tintColor = .white
        weatherButton.imageRect(forContentRect: CGRect(x: 0, y: 0, width: 40, height: 40))
        weatherButton.imageView?.contentMode = .scaleToFill
        weatherButton.addTarget(self, action: #selector(didTapWeatherButton), for: .touchUpInside)
        collectionView.addSubview(weatherButton)
        collectionView.bringSubviewToFront(weatherButton)
        weatherButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            weatherButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            weatherButton.widthAnchor.constraint(equalToConstant: 40),
            weatherButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureCollectionView() {
        let layout = PinterLayout(numberOfColumns: 2, initialYoffset: view.frame.height)
        layout.delegate = self
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: -45, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = .white
        collectionView.register(MainScrollViewCell.self, forCellWithReuseIdentifier: MainScrollViewCell.identifier)
        collectionView.register(TitleCell.self, forCellWithReuseIdentifier: TitleCell.identifier)
        collectionView.register(PinterCell.self, forCellWithReuseIdentifier: PinterCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    @objc private func didTapWeatherButton() {
        guard let url = URL(string: "https://m.weather.naver.com/") else {return}
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}


extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return data.count + 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainScrollViewCell.identifier, for: indexPath) as! MainScrollViewCell
            self.delegate = cell
            return cell
        } else if indexPath.item == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCell.identifier, for: indexPath) as! TitleCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PinterCell.identifier, for: indexPath) as! PinterCell
            let image = UIImage(named: self.data[indexPath.item - 2])
            cell.image = image
            return cell
        }
    }
}


extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("ddddd")
       guard indexPath.item != 0 && indexPath.item != 1 else {return}
        let dv = DetailViewController()
        dv.set(image: UIImage(named: self.data[indexPath.item - 2])!)
        navigationController?.pushViewController(dv, animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 200 {
            self.weatherButton.tintColor = UIColor(named: "KeyColor")
        } else {
            self.weatherButton.tintColor = .white
        }
        guard scrollView.contentOffset.y <= 500 else {return}
        let scrollRatio:CGFloat = scrollView.contentOffset.y * 0.002
        self.delegate?.controlAlphaValue(XoffSet: scrollRatio)
    }
}


extension MainViewController: PinterLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfColumn: Int, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = UIImage(named: self.data[indexPath.item - 2])!
        let imageHeight = image.size.height
        let imageWidth = image.size.width
        let columnRatio: CGFloat = 1/CGFloat(numberOfColumn)
        let imageSizeRatio = (collectionView.frame.width * columnRatio) / imageWidth
        return imageHeight * imageSizeRatio
    }
}
