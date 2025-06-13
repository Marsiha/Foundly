//
//  RegisterEmailViewController.swift
//  Foundly
//
//  Created by mars uzhanov on 20.02.2025.
//

import UIKit

class RegisterEmailViewController: UIViewController {
    
    private let subView = UIView()
    private let headerView = AuthHeaderView(title: "Регистрация", subTitle: " Укажите email для продолжения")
    
    private let emailField = CustomTextField(fieldType: .email)
    private let continueButton = CustomButton(title: "Продолжить", hasBackground: true, fontSize: .med)
    private let signInButton = CustomButton(title: "Уже есть аккаунт? Войти", fontSize: .med)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
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
        self.subView.addSubview(emailField)
        self.subView.addSubview(continueButton)
        self.subView.addSubview(signInButton)
        
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
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        signInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
    @objc func didTapContinue() {
        
        let userEmail = emailField.text ?? ""
        
        if !Validator.isValidEmail(for: userEmail) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        
        AuthService.shared.registerEmail(with: userEmail, isRegister: true) { verified, error in
            if verified {
                DispatchQueue.main.async {
                    let vc = VerifyEmailViewController()
                    vc.registerUserRequest = userEmail
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                print(error)
            }
        }
    }
    
    @objc private func didTapSignIn() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
