//
//  SignUpViewController.swift
//  MyCloset
//
//  Created by SEONGJUN on 2020/01/31.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    let titleLabel = UILabel()
    let underTitleLabel = UILabel()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let userNameTextField = UITextField()
    let signUpButton = UIButton(type: .system)
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTitleLabel()
        configureUnderTitleLabel()
        configureEmailTextField()
        configurePasswordTextField()
        configureUsernameTextField()
        configureSignUpButton()
        setupConstraints()
    }
    
    
    // MARK: - Initial Setup for UI
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.text = "가입하기"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel.textAlignment = .center
    }
    
    private func configureUnderTitleLabel() {
        view.addSubview(underTitleLabel)
        underTitleLabel.text = "지금 가입하시고 \n 모든 혜택을 누리세요"
        underTitleLabel.numberOfLines = 0
        underTitleLabel.font = UIFont.systemFont(ofSize: 22, weight: .light)
        underTitleLabel.textAlignment = .center
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
    
    private func configureUsernameTextField() {
        view.addSubview(userNameTextField)
        userNameTextField.placeholder = "닉네임"
        userNameTextField.backgroundColor = UIColor(named: "TextFieldColor")
        userNameTextField.layer.cornerRadius = 7
        let namePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: userNameTextField.frame.height))
        userNameTextField.leftView = namePaddingView
        userNameTextField.leftViewMode = .always
        userNameTextField.delegate = self
    }
    
    private func configureSignUpButton() {
        view.addSubview(signUpButton)
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        signUpButton.backgroundColor = UIColor(named: "KeyColor")
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 7
        signUpButton.shadow()
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(70)
            $0.centerX.equalToSuperview()
        }
        underTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(underTitleLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(48)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(48)
        }
        userNameTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(48)
        }
        signUpButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-30)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(48)
        }
    }
    
    
    // MARK: - Action Handler
    @objc private func didTapSignUpButton() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        print("sign up")
        APIManager.shared.signUp(email: email, password: password) { (err) in
            guard err == nil else {
                print("failed to SignUp: ", err?.localizedDescription ?? "")
                return
            }
            self.dismiss(animated: true)
        }
    }
    
    // MARK: - For KeyboardHide Helper
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25) {
            self.signUpButton.transform = .init(translationX: 0, y: -self.view.frame.height * 0.34)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        UIView.animate(withDuration: 0.25) {
            self.signUpButton.transform = .identity
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
