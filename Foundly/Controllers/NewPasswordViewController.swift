//
//  RegisterEmailViewController.swift
//  Foundly
//
//  Created by mars uzhanov on 20.02.2025.
//

import UIKit

class NewPasswordViewController: UIViewController {
    
    var email: String = ""
    
    private let subView = UIView()
    private let headerView = AuthHeaderView(title: "Придумайте новый пароль", subTitle: "Пароль должен содержать не менее  8символов, включая цифры, буквы и специальные символы.")
    
    private let passwordField = CustomTextField(fieldType: .password)
    private let repeatPasswordField = CustomTextField(fieldType: .repeatPassword)
    private let signUpButton = CustomButton(title: "Зарегистрироваться", hasBackground: true, fontSize: .med)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUI() {
        self.view.backgroundColor = .foundlyPolar
        self.subView.backgroundColor = .foundlyPolar
        
        // Add subviews
        self.view.addSubview(subView)
        self.subView.addSubview(headerView)
        self.subView.addSubview(passwordField)
        self.subView.addSubview(repeatPasswordField)
        self.subView.addSubview(signUpButton)
        
        subView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(view.bounds.height * 0.25)
            make.bottom.equalTo(self.view.layoutMarginsGuide.snp.bottom)
            make.width.equalToSuperview().multipliedBy(0.85)
            make.centerX.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        repeatPasswordField.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(repeatPasswordField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalToSuperview()
        }
        
    }
    
    @objc private func didTapSignUp() {
        
        let passwordRequest = NewPasswordRequest(
            email: email,
            password: passwordField.text ?? ""
        )
        
        // Code check
        if !Validator.isPasswordValid(for: passwordRequest.password) {
            AlertManager.showInvalidCodeAlert(on: self)
            return
        }
        
        AuthService.shared.resetPassword(with: passwordRequest) { verified, error in
            if let error = error {
                AlertManager.showInvalidCodeAlert(on: self)
                return
            }
            
            if verified {
                DispatchQueue.main.async {
                    let vc = LoginViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                AlertManager.showInvalidCodeAlert(on: self)
            }
        }
        
    }
}
