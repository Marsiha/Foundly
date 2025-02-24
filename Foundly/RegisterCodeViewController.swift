//
//  RegisterEmailViewController.swift
//  Foundly
//
//  Created by mars uzhanov on 20.02.2025.
//

import UIKit

class RegisterCodeViewController: UIViewController {
    
    var registerUserRequest: String = ""
    
    private let subView = UIView()
    private let headerView = AuthHeaderView(title: "Введите 6-значный код", subTitle: "Мы отправили код подтверждения на ваш email. Введите его ниже.")
    
    private let codeField = CustomTextField(fieldType: .code)
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
        self.subView.addSubview(codeField)
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
        
        codeField.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(codeField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalToSuperview()
        }
        
    }
    
    @objc private func didTapSignUp() {
        
        let verifyRequest = VerifyRegisterCodeRequest(
            email: self.registerUserRequest,
            code: self.codeField.text ?? ""
        )
        
        // Code check
        if !Validator.isValidCode(for: verifyRequest.code) {
            AlertManager.showInvalidCodeAlert(on: self)
            return
        }
        
        AuthService.shared.verifyEmail(with: verifyRequest) { verified, error in
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
