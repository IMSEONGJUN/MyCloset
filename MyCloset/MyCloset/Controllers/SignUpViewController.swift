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
    
    let titleLabel = UILabel()
    let underTitleLabel = UILabel()
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let userNameTextField = UITextField()
    
    let signUpButton = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        emailTextField.delegate = self
        passwordTextField.delegate = self
        userNameTextField.delegate = self
        setupUI()
    }
    
    
    //MARK: SetupUI
    private func setupUI() {
        
        titleLabel.text = "가입하기"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel.textAlignment = .center
        
        underTitleLabel.text = "지금 가입하시고 \n 모든 혜택을 누리세요"
        underTitleLabel.numberOfLines = 0
        underTitleLabel.font = UIFont.systemFont(ofSize: 22, weight: .light)
        underTitleLabel.textAlignment = .center
        
        emailTextField.placeholder = "이메일"
        emailTextField.backgroundColor = UIColor(named: "TextFieldColor")
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
        
        userNameTextField.placeholder = "닉네임"
        userNameTextField.backgroundColor = UIColor(named: "TextFieldColor")
        userNameTextField.layer.cornerRadius = 7
        let namePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: userNameTextField.frame.height))
        userNameTextField.leftView = namePaddingView
        userNameTextField.leftViewMode = .always
        userNameTextField.isSecureTextEntry = true
        
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        signUpButton.backgroundColor = UIColor(named: "KeyColor")
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 7
        signUpButton.shadow()
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        
        view.addSubviews(
            [titleLabel,
             underTitleLabel,
             emailTextField,
             passwordTextField,
             userNameTextField,
             signUpButton]
        )
        setupConstraints()
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
    
    
    //MARK: Actions
    
    //MARK: 회원가입
    @objc private func didTapSignUpButton() {
        if emailTextField.text?.contains("@") == true && emailTextField.text?.contains(".") == true && passwordTextField.text?.count ?? 0 >= 6 {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, err) in
                if err == nil {
                    let uid = user?.user.uid ?? "" //현재 회원의 uid
                    let values = ["userName": self.userNameTextField.text ?? "noname",
                                  "email": self.emailTextField.text ?? "wrongEmail",
                                  "uid": uid
                                 ]
                    
                    Database.database().reference().child("users").child(uid).setValue(values) { (err, _) in
                        if err == nil {
                            print("회원가입이 완료되었습니다.")
                            self.dismiss(animated: true)
                        } else {
                            print("회원가입 실패")
                            
                        }
                    }
                }
            }
        } else {
            print("wrong Info")
        }
    }
    
    //MARK: 텍스트필드 아닌 곳 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    //MARK: 텍스트필드 눌렀을 때 UI 올리기
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25) {
            self.signUpButton.transform = .init(translationX: 0, y: -self.view.frame.height * 0.34)
        }
    }
    //MARK: 텍스트필드 아닌 곳 눌렀을 때 UI 내리기
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        UIView.animate(withDuration: 0.25) {
            self.signUpButton.transform = .identity
        }
    }
    
    //MARK: 엔터키 눌렀을 때도 키보드 없애기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
