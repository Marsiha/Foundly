//
//  RegisterController.swift
//  swift-login-system-tutorial
//
//  Created by YouTube on 2022-10-26.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    var userEmail: String = ""
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let subView = UIView()
    private let headerView = AuthHeaderView(title: "Регистрация", subTitle: "Заполните данные для завершения регистрации")
    
    private let nameField = CustomTextField(fieldType: .name)
    private let lastNameField = CustomTextField(fieldType: .lastName)
    private let passwordField = CustomTextField(fieldType: .password)
    private let repeatPasswordField = CustomTextField(fieldType: .repeatPassword)
    
    private let signUpButton = CustomButton(title: "Продолжить", hasBackground: true, fontSize: .big)
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
        self.view.backgroundColor = .foundlyPolar
        self.subView.backgroundColor = .foundlyPolar
        
        // Add subviews
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        self.contentView.addSubview(subView)
        self.subView.addSubview(headerView)
        self.subView.addSubview(nameField)
        self.subView.addSubview(lastNameField)
        self.subView.addSubview(passwordField)
        self.subView.addSubview(repeatPasswordField)
        self.subView.addSubview(signUpButton)
        self.subView.addSubview(termsTextView)
        self.subView.addSubview(signInButton)
        
        // Set up constraints using SnapKit
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(scrollView.snp.height).multipliedBy(0.9)
        }

        subView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(view.bounds.height * 0.15)
            make.bottom.equalTo(self.view.layoutMarginsGuide.snp.bottom)
            make.width.equalToSuperview().multipliedBy(0.85)
            make.centerX.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
        
        nameField.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        lastNameField.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(lastNameField.snp.bottom).offset(22)
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
            make.top.equalTo(termsTextView.snp.bottom).offset(-11)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalToSuperview()
        }
    }
    
    // MARK: - Selectors
    @objc func didTapSignUp() {
        let registerUserRequest = RegisterUserRequest(
            email: userEmail,
            firstName: self.nameField.text ?? "",
            lastName: self.lastNameField.text ?? "",
            password: self.passwordField.text ?? "",
            password2: self.repeatPasswordField.text ?? ""
        )
        
        // Email check
        if !Validator.isValidEmail(for: registerUserRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        // Password check
//        if !Validator.isPasswordValid(for: registerUserRequest.password) {
//            AlertManager.showInvalidPasswordAlert(on: self)
//            return
//        }
        
        AuthService.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showRegistrationErrorAlert(on: self, with: error)
                return
            }
            if wasRegistered {
                DispatchQueue.main.async {
                    let vc = LoginViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
        Auth.auth().createUser(
            withEmail: registerUserRequest.email,
            password: registerUserRequest.password,
            completion: {
                authResult,
                error in
                guard let result = authResult,
                      error == nil else {
                    print("Error from firebase")
                    return
                }
                
                UserDefaults.standard.setValue(registerUserRequest.email, forKey: "email")
                UserDefaults.standard.setValue("\(registerUserRequest.firstName) \(registerUserRequest.lastName)", forKey: "name")
                
                DatabaseManager.shared.insertUser(
                    with: ChatUser(
                        email: registerUserRequest.email,
                        firstName: registerUserRequest.firstName,
                        lastName: registerUserRequest.lastName
                    )
                ) { success in
                    if success {
                        print("✅ User inserted successfully")
                        // Proceed with next steps, like navigating or logging in
                    } else {
                        print("❌ Failed to insert user")
                        // Handle error, show alert, etc.
                    }
                }
        })
        
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
