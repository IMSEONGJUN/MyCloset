//
//  LoginViewController.swift
//  MyCloset
//
//  Created by SEONGJUN on 2020/01/31.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {
    
    
    
    let titleLabel = UILabel()
    let underTitle = UILabel()
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    
    let loginButton = UIButton(type: .system)
    let googleLoginButton = GIDSignInButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error)
        }
    }
    
    private func setupUI() {
        titleLabel.text = "My Closet"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.textAlignment = .center
        
        underTitle.text = "쉽고 간편한 \n 옷장 관리 어플리케이션"
        underTitle.numberOfLines = 0
        underTitle.textAlignment = .center
        underTitle.font = UIFont.systemFont(ofSize: 25, weight: .light)
        
        emailTextField.placeholder = "이메일"
        emailTextField.backgroundColor = UIColor(named: "TextFieldColor")
        //        emailTextField.layer.borderColor = UIColor.gray.cgColor
        //        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = 7
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: emailTextField.frame.height))
        emailTextField.leftView = emailPaddingView
        emailTextField.leftViewMode = .always
        emailTextField.keyboardType = .emailAddress
        
        passwordTextField.placeholder = "비밀번호"
        passwordTextField.backgroundColor = UIColor(named: "TextFieldColor")
        //        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        //        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 7
        let pwPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: passwordTextField.frame.height))
        passwordTextField.leftView = pwPaddingView
        passwordTextField.leftViewMode = .always
        passwordTextField.isSecureTextEntry = true
        
        loginButton.setTitle("로그인", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        loginButton.backgroundColor = UIColor(named: "KeyColor")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 7
        loginButton.shadow()
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        
        
        googleLoginButton.layer.cornerRadius = 7
        
        view.addSubview(titleLabel)
        view.addSubview(underTitle)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(googleLoginButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(130)
            $0.centerX.equalToSuperview()
        }
        
        underTitle.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-250)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(48)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(emailTextField.snp.width)
            $0.height.equalTo(emailTextField.snp.height)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(emailTextField.snp.width)
            $0.height.equalTo(emailTextField.snp.height)
        }
        
        googleLoginButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(emailTextField).offset(8)
            $0.height.equalTo(emailTextField)
        }
        
    }
    
    
    
    //MARK: Actions
    
    //MARK: 로그인기능
    @objc private func didTapLoginButton() {
        if emailTextField.text?.contains("@") == true && emailTextField.text?.contains(".") == true && passwordTextField.text?.count ?? 0 >= 6 { //정규 표현식 필요
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if user != nil {//로그인 성공
                    print("success")
                    self.switchingView()
                } else { // 로그인 실패
                    print("로그인 실패")
                }
            }
        } else { //입력값 오류
            print("입력값 오류")
        }
    }
    
    //MARK: 텍스트필드 아닌 곳 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    //MARK: 텍스트필드 눌렀을 때 UI 올리기
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25) {
            self.titleLabel.transform = .init(translationX: 0, y: -(self.view.frame.height * 0.1))
            self.underTitle.transform = .init(translationX: 0, y: -(self.view.frame.height * 0.1))
            self.emailTextField.transform = .init(translationX: 0, y: -(self.view.frame.height * 0.32))
            self.passwordTextField.transform = .init(translationX: 0, y: -(self.view.frame.height * 0.32))
            self.loginButton.transform = .init(translationX: 0, y: -(self.view.frame.height * 0.32))
            self.googleLoginButton.transform = .init(translationX: 0, y: -(self.view.frame.height * 0.32))
            
        }
    }
    
    //MARK: 텍스트필드 아닌 곳 눌렀을 때 UI 내리기
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        UIView.animate(withDuration: 0.25) {
            self.titleLabel.transform = .identity
            self.underTitle.transform = .identity
            self.emailTextField.transform = .identity
            self.passwordTextField.transform = .identity
            self.loginButton.transform = .identity
            self.googleLoginButton.transform = .identity
        }
    }
    
    //MARK: 엔터키 눌렀을 때도 키보드 없애기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapLoginButton()
        view.endEditing(true)
        return true
    }
}
