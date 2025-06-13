//
//  ChangePasswordViewController.swift
//  Foundly
//
//  Created by mars uzhanov on 28.03.2025.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    
    private let subView = UIView()
    private let headerView = AuthHeaderView(title: "Придумайте новый пароль", subTitle: "Пароль должен содержать не менее  8символов, включая цифры, буквы и специальные символы.")
    
    private let oldPasswordField = CustomTextField(fieldType: .password)
    private let passwordField = CustomTextField(fieldType: .password)
    private let repeatPasswordField = CustomTextField(fieldType: .repeatPassword)
    private let forgotPasswordButton = CustomButton(title: "Забыли пароль? ", fontSize: .small)
    private let signUpButton = CustomButton(title: "Сохранить", hasBackground: true, fontSize: .med)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Изменить пароль"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.setupUI()
        self.signUpButton.addTarget(self, action: #selector(didTapSavePassword), for: .touchUpInside)
        self.forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .foundlyPrimaryDark
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    private func setupUI() {
        self.view.backgroundColor = .foundlyPolar
        self.subView.backgroundColor = .foundlyPolar
        
        // Add subviews
        self.view.addSubview(subView)
        self.subView.addSubview(headerView)
        self.subView.addSubview(oldPasswordField)
        self.subView.addSubview(passwordField)
        self.subView.addSubview(forgotPasswordButton)
        self.subView.addSubview(repeatPasswordField)
        self.subView.addSubview(signUpButton)
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backTapped))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
        
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
        
        oldPasswordField.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
            make.width.equalToSuperview()
        }
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(oldPasswordField.snp.bottom).offset(10)
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
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(repeatPasswordField.snp.bottom).offset(6)
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(forgotPasswordButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalToSuperview()
        }
        
    }
    
    @objc private func didTapSavePassword() {
        let changePassword = ChangePassword(
            currentPassword: oldPasswordField.text ?? "",
            newPassword: passwordField.text ?? "",
            newPasswordConfirmation: repeatPasswordField.text ?? ""
        )
        
        ProfileService.shared.changePassword(with: changePassword) { success, error in
            if success {
                print("password changed")
            } else {
                print(error)
            }
        }
    }
    
    @objc private func didTapForgotPassword() {
        
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
