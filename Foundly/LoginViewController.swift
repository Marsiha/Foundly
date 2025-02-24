//
//  LoginController.swift
//  swift-login-system-tutorial
//
//  Created by YouTube on 2022-10-26.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    // MARK: - UI Components
    private let subView = UIView()
    private let headerView = AuthHeaderView(title: "Войти", subTitle: "Введите email и пароль для входа")
    
    private let emailField = CustomTextField(fieldType: .email)
    private let passwordField = CustomTextField(fieldType: .password)
    
    private let signInButton = CustomButton(title: "Войти", hasBackground: true, fontSize: .big)
    private let newUserButton = CustomButton(title: "Нет аккаунта? Зарегистрируйтесь", fontSize: .small)
    private let forgotPasswordButton = CustomButton(title: "Забыли пароль? ", fontSize: .small)
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        self.newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
        self.forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .foundlyPolar
        self.subView.backgroundColor = .foundlyPolar
        
        self.view.addSubview(subView)
        self.subView.addSubview(headerView)
        self.subView.addSubview(emailField)
        self.subView.addSubview(passwordField)
        self.subView.addSubview(signInButton)
        self.subView.addSubview(newUserButton)
        self.subView.addSubview(forgotPasswordButton)
        
        subView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(view.bounds.height * 0.20)
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
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(6)
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        newUserButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalToSuperview()
        }
        
        
    }
    
    // MARK: - Selectors
    @objc private func didTapSignIn() {
        
        let loginRequest = LoginUserRequest(
            username: self.emailField.text ?? "",
            password: self.passwordField.text ?? ""
        )
        
        // Username check
        if !Validator.isValidEmail(for: loginRequest.username) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        // Password check
        if !Validator.isPasswordValid(for: loginRequest.password) {
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        
        // Call the login function
        AuthService.shared.signIn(with: loginRequest) { error in
            if let error = error {
                AlertManager.showSignInErrorAlert(on: self, with: error)
                return
            } else {
                DispatchQueue.main.async {
                    let vc = MapViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
      // MARK: - Helper Functions
      private func showAlert(title: String, message: String) {
          let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
      }
    
    @objc private func didTapNewUser() {
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapForgotPassword() {
        let vc = ForgotPasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
