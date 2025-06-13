//
//  RegisterEmailViewController.swift
//  Foundly
//
//  Created by mars uzhanov on 20.02.2025.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    private let subView = UIView()
    private let headerView = AuthHeaderView(title: "Забыли пароль?", subTitle: "")
    
    private let emailField = CustomTextField(fieldType: .email)
    private let termsTextView: UITextView = {
        let attributedString = NSMutableAttributedString(string: "Мы отправим код подтверждения на этот адрес эл. почты , если он соответствует существующей уч. записи Foundly")
        
        let tv = UITextView()
        tv.linkTextAttributes = [.foregroundColor: UIColor.systemBlue]
        tv.backgroundColor = .clear
        tv.attributedText = attributedString
        tv.textColor = .label
        tv.isSelectable = true
        tv.isEditable = false
        tv.delaysContentTouches = false
        tv.isScrollEnabled = false
        return tv
    }()
    private let sendCodeButton = CustomButton(title: "Отправить код", hasBackground: true, fontSize: .med)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.sendCodeButton.addTarget(self, action: #selector(didTapSendCode), for: .touchUpInside)
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
        self.subView.addSubview(termsTextView)
        self.subView.addSubview(sendCodeButton)
        
        subView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(view.bounds.height * 0.30)
            make.bottom.equalTo(self.view.layoutMarginsGuide.snp.bottom)
            make.width.equalToSuperview().multipliedBy(0.85)
            make.centerX.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        termsTextView.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        sendCodeButton.snp.makeConstraints { make in
            make.top.equalTo(termsTextView.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
    }
    
    @objc func didTapSendCode() {
        
        let email = self.emailField.text!
        
        if !Validator.isValidEmail(for: email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        AuthService.shared.forgotPassword(with: email) { verified, error in
            if let error = error {
                AlertManager.showInvalidEmailAlert(on: self)
                print("🐮 \(error)")
                return
            }
            
            if verified {
                DispatchQueue.main.async {
                    let vc = ResetCodeViewController()
                    vc.email = email
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    AlertManager.showRegistrationErrorAlert(on: self)
                }
            }
        }
    }
}
