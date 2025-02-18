//
//  RegisterController.swift
//  swift-login-system-tutorial
//
//  Created by YouTube on 2022-10-26.
//

import UIKit

class RegisterViewController: UIViewController {
    
    // MARK: - UI Components
    private let subView = UIView()
    private let headerView = AuthHeaderView(title: "Регистрация", subTitle: "Заполните данные для завершения регистрации")
    
    private let usernameField = CustomTextField(fieldType: .username)
    private let emailField = CustomTextField(fieldType: .email)
    private let passwordField = CustomTextField(fieldType: .password)
    private let repeatPasswordField = CustomTextField(fieldType: .repeatPassword)
    
    private let signUpButton = CustomButton(title: "Зарегистрироваться", hasBackground: true, fontSize: .big)
    private let signInButton = CustomButton(title: "Already have an account? Sign In.", fontSize: .med)
    
    private let termsTextView: UITextView = {
        let attributedString = NSMutableAttributedString(string: "Пароль должен содержать не менее 8 символов, включая цифры, буквы и специальные символы.")
        
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
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.termsTextView.delegate = self
        
        self.signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.subView.backgroundColor = .systemBackground
        
        // Add subviews
        self.view.addSubview(subView)
        self.subView.addSubview(headerView)
        self.subView.addSubview(usernameField)
        self.subView.addSubview(emailField)
        self.subView.addSubview(passwordField)
        self.subView.addSubview(repeatPasswordField)
        self.subView.addSubview(signUpButton)
        self.subView.addSubview(termsTextView)
        self.subView.addSubview(signInButton)
        
        // Set up constraints using SnapKit
        subView.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.width.equalToSuperview().multipliedBy(0.85)
            make.center.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(222)
        }
        
        usernameField.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(usernameField.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        repeatPasswordField.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        termsTextView.snp.makeConstraints { make in
            make.top.equalTo(repeatPasswordField.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        signUpButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(termsTextView.snp.bottom).offset(11)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalToSuperview()
        }
    }
    
    // MARK: - Selectors
    @objc func didTapSignUp() {
//        let registerUserRequest = RegiserUserRequest(
//            username: self.usernameField.text ?? "",
//            email: self.emailField.text ?? "",
//            password: self.passwordField.text ?? ""
//        )
//        
//        // Username check
//        if !Validator.isValidUsername(for: registerUserRequest.username) {
//            AlertManager.showInvalidUsernameAlert(on: self)
//            return
//        }
//        
//        // Email check
//        if !Validator.isValidEmail(for: registerUserRequest.email) {
//            AlertManager.showInvalidEmailAlert(on: self)
//            return
//        }
//        
//        // Password check
//        if !Validator.isPasswordValid(for: registerUserRequest.password) {
//            AlertManager.showInvalidPasswordAlert(on: self)
//            return
//        }
//        
//        AuthService.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
//            guard let self = self else { return }
//            
//            if let error = error {
//                AlertManager.showRegistrationErrorAlert(on: self, with: error)
//                return
//            }
//            
//            if wasRegistered {
//                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
//                    sceneDelegate.checkAuthentication()
//                }
//            } else {
//                AlertManager.showRegistrationErrorAlert(on: self)
//            }
//        }
    }
    
    @objc private func didTapSignIn() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension RegisterViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if URL.scheme == "terms" {
            self.showWebViewerController(with: "https://policies.google.com/terms?hl=en")
        } else if URL.scheme == "privacy" {
            self.showWebViewerController(with: "https://policies.google.com/privacy?hl=en")
        }
        
        return true
    }
    
    private func showWebViewerController(with urlString: String) {
//        let vc = WebViewerController(with: urlString)
//        let nav = UINavigationController(rootViewController: vc)
//        self.present(nav, animated: true, completion: nil)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.delegate = nil
        textView.selectedTextRange = nil
        textView.delegate = self
    }
}
