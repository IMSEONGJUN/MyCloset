//
//  TutorialViewController.swift
//  MyCloset
//
//  Created by SEONGJUN on 2020/01/31.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import SnapKit

class TutorialViewController: UIViewController {
    
    
    // MARK: - Properties
    let scrollView = UIScrollView()
    let pageController = UIPageControl()
    let skipButton = UIButton()
    let nextButton = UIButton()
    let signUpButton = UIButton()
    
    var subViews = [UIView]()
    let tutorialOne = UIView()
    let tutor1 = UIImageView()
    let tutorialTwo = UIView()
    let tutor2 = UIImageView()
    let tutorialThree = UIView()
    let tutor3 = UIImageView()
    let tutorialFour = UIView()
    let tutor4 = UIImageView()
    
    let loginPageView = UIView()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupConstraints()
        add(childVC: LoginViewController(), to: loginPageView)
    }
    
    
    // MARK: - Initial Setup for UI
    private func setupUI() {
        subViews = [scrollView, pageController, skipButton, nextButton, signUpButton]
        subViews.forEach{view.addSubview($0)}
        
        pageController.numberOfPages = 5
        pageController.pageIndicatorTintColor = .lightGray
        pageController.currentPageIndicatorTintColor = UIColor(named: "KeyColor")
        pageController.currentPage = 0
        
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        skipButton.setTitle("Skip", for: .normal)
        skipButton.backgroundColor = .clear
        skipButton.setTitleColor(UIColor(named: "KeyColor"), for: .normal)
        skipButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        skipButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = .clear
        nextButton.setTitleColor(UIColor(named: "KeyColor"), for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        nextButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.backgroundColor = .clear
        signUpButton.setTitleColor(.systemGray, for: .normal)
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        signUpButton.isHidden = true
        signUpButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        
        [tutorialOne, tutorialTwo, tutorialThree, tutorialFour, loginPageView].forEach{$0.backgroundColor = UIColor(named: "cameraBG")}
        
        tutorialOne.addSubview(tutor1)
        tutorialTwo.addSubview(tutor2)
        tutorialThree.addSubview(tutor3)
        tutorialFour.addSubview(tutor4)
        
        tutor1.image = UIImage(named: "tutor1")
        tutor2.image = UIImage(named: "tutor2")
        tutor3.image = UIImage(named: "tutor3")
        tutor4.image = UIImage(named: "tutor4")
        
        [tutorialOne, tutorialTwo, tutorialThree, tutorialFour, loginPageView ].forEach{scrollView.addSubview($0)}
    }
    
    private func setupConstraints(){
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        tutorialOne.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.leading.equalTo(scrollView.snp.leading)
            $0.height.equalTo(scrollView.snp.height)
            $0.width.equalTo(scrollView.snp.width)
        }
        tutorialTwo.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.leading.equalTo(tutorialOne.snp.trailing)
            $0.width.equalTo(scrollView.snp.width)
        }
        tutorialThree.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.leading.equalTo(tutorialTwo.snp.trailing)
            $0.width.equalTo(scrollView.snp.width)
        }
        tutorialFour.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.leading.equalTo(tutorialThree.snp.trailing)
            $0.width.equalTo(scrollView.snp.width)
        }
        loginPageView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.leading.equalTo(tutorialFour.snp.trailing)
            $0.width.equalTo(scrollView.snp.width)
            $0.trailing.equalTo(scrollView.snp.trailing)
        }
        
        tutor1.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-50)
        }
        tutor2.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-50)
        }
        tutor3.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-50)
        }
        tutor4.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-50)
        }
        
        pageController.snp.makeConstraints {
            $0.centerX.equalTo(scrollView.snp.centerX)
            $0.bottom.equalTo(scrollView).offset(-10)
        }
        skipButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(pageController.snp.width).multipliedBy(1.5)
            $0.height.equalTo(50)
        }
        signUpButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(pageController.snp.width).multipliedBy(1.5)
            $0.height.equalTo(50)
        }
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(pageController.snp.width).multipliedBy(1.5)
            $0.height.equalTo(50)
        }
    }
    
    
    // MARK: - Action Handler
    @objc func didTapButton(_ sender: UIButton) {
        switch sender {
        case skipButton:
            scrollView.contentOffset.x = scrollView.frame.width * 4
            pageController.currentPage = 4
        case signUpButton:
            let svc = SignUpViewController()
            present(svc, animated: true)
        default:
            guard scrollView.contentOffset.x != scrollView.frame.width * 4 else {return}
            scrollView.contentOffset.x += scrollView.frame.width
            pageController.currentPage += 1
        }
        
        if pageController.currentPage == 4 {
            self.skipButton.isHidden = true
            self.nextButton.isHidden = true
            self.signUpButton.isHidden = false
        }
    }
    
    
    // MARK: - Helper
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}


// MARK: - UIScrollViewDelegate
extension TutorialViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.width
        pageController.currentPage = Int(pageNumber)
        
        if pageController.currentPage == 4 {
            self.skipButton.isHidden = true
            self.nextButton.isHidden = true
            self.signUpButton.isHidden = false
        } else {
            self.signUpButton.isHidden = true
            self.skipButton.isHidden = false
            self.nextButton.isHidden = false
        }
    }
}
