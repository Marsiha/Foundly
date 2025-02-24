//
//  CustomTextField.swift
//  swift-login-system-tutorial
//
//  Created by YouTube on 2022-10-29.
//

import UIKit

class CustomTextField: UITextField {
    
    enum CustomTextFieldType {
        case username
        case email
        case name
        case lastName
        case password
        case repeatPassword
        case code
    }
    
    private let authFieldType: CustomTextFieldType
    
    init(fieldType: CustomTextFieldType) {
        self.authFieldType = fieldType
        super.init(frame: .zero)
        
        self.backgroundColor = .foundlySwan
        self.layer.cornerRadius = 10
        
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        
        switch fieldType {
        case .username:
            self.placeholder = "Имя"
        case .email:
            self.placeholder = "Адрес эл. почты"
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
            
        case .password:
            self.placeholder = "Пароль"
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true

        case .repeatPassword:
            self.placeholder = "Подтвердить пароль"
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
            
        case .code:
            self.placeholder = "Введите код"
            
        case .name:
            self.placeholder = "Имя"
        case .lastName:
            self.placeholder = "Фамилия"
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
