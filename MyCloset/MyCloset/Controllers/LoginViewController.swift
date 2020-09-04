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
    
    // MARK: - Properties
    let titleLabel = UILabel()
    let underTitle = UILabel()
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    
    let loginButton = UIButton(type: .system)
    let googleLoginButton = GIDSignInButton()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureGoogleLogin()
        configureTitleLabel()
        configureUnderTitle()
        configureEmailTextField()
        configurePasswordTextField()
        configureLoginButton()
        configureGoogleLoginButton()
        setupConstraints()
    }
    
    
    // MARK: - Initial Setup for UI
    private func configureGoogleLogin() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.text = "My Closet"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.textAlignment = .center
    }
    
    private func configureUnderTitle() {
        view.addSubview(underTitle)
        underTitle.text = "쉽고 간편한 \n 옷장 관리 어플리케이션"
        underTitle.numberOfLines = 0
        underTitle.textAlignment = .center
        underTitle.font = UIFont.systemFont(ofSize: 25, weight: .light)
        
    }
    
    private func configureEmailTextField() {
        view.addSubview(emailTextField)
        emailTextField.placeholder = "이메일"
        emailTextField.backgroundColor = UIColor(named: "TextFieldColor")
        emailTextField.layer.cornerRadius = 7
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: emailTextField.frame.height))
        emailTextField.leftView = emailPaddingView
        emailTextField.leftViewMode = .always
        emailTextField.keyboardType = .emailAddress
        emailTextField.delegate = self
    }
    
    private func configurePasswordTextField() {
        view.addSubview(passwordTextField)
        passwordTextField.placeholder = "비밀번호"
        passwordTextField.backgroundColor = UIColor(named: "TextFieldColor")
        passwordTextField.layer.cornerRadius = 7
        let pwPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: passwordTextField.frame.height))
        passwordTextField.leftView = pwPaddingView
        passwordTextField.leftViewMode = .always
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
    }
    
    private func configureLoginButton() {
        view.addSubview(loginButton)
        loginButton.setTitle("로그인", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        loginButton.backgroundColor = UIColor(named: "KeyColor")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 7
        loginButton.shadow()
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        
    }
    
    private func configureGoogleLoginButton() {
        view.addSubview(googleLoginButton)
        googleLoginButton.layer.cornerRadius = 7
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

    
    // MARK: - Action Handler
    @objc private func didTapLoginButton() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        APIManager.shared.login(email: email, password: password) { (error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            self.switchingView()
        }
    }
    
    
    // MARK: - Helper
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error)
        }
    }
}


// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapLoginButton()
        view.endEditing(true)
        return true
    }
}
