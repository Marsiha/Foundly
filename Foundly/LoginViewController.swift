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
    private let headerView = AuthHeaderView(title: "Sign In", subTitle: "Sign in to your account")
    
    private let emailField = CustomTextField(fieldType: .email)
    private let passwordField = CustomTextField(fieldType: .password)
    
    private let signInButton = CustomButton(title: "Sign In", hasBackground: true, fontSize: .big)
    private let newUserButton = CustomButton(title: "New User? Create Account.", fontSize: .med)
    private let forgotPasswordButton = CustomButton(title: "Forgot Password?", fontSize: .small)
    
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
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.subView.backgroundColor = .systemBackground
        
        self.view.addSubview(subView)
        self.subView.addSubview(headerView)
        self.subView.addSubview(emailField)
        self.subView.addSubview(passwordField)
        self.subView.addSubview(signInButton)
        self.subView.addSubview(newUserButton)
        self.subView.addSubview(forgotPasswordButton)
        
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
    }
    
    @objc private func didTapNewUser() {
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapForgotPassword() {
    }
}
