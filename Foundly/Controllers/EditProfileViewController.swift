import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate {
    
    private let user: User
    private var initialProfileData: ProfileEdit!
    
    // MARK: - UI Elements
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.backgroundColor = .lightGray
        imageView.image = UIImage(systemName: "person.circle.fill") // Placeholder image
        return imageView
    }()
    
    private let editImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        button.tintColor = .purple
        return button
    }()
    
    private let nicknameTextField = createTextField(placeholder: "Никнейм")
    private let nameTextField = createTextField(placeholder: "Имя")
    private let surnameTextField = createTextField(placeholder: "Фамилия")
    private let phoneTextField = createTextField(placeholder: "+7 (___) ___ __ __")
    private let emailTextField = createTextField(placeholder: "E-mail")
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить изменения", for: .normal)
        button.backgroundColor = .purple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить аккаунт", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        configure()
        initialProfileData = ProfileEdit(
            username: nicknameTextField.text ?? "",
            firstName: nameTextField.text ?? "",
            lastName: surnameTextField.text ?? "",
            phoneNumber: phoneTextField.text ?? ""
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        configure()
        setTextFieldDelegates()
    }
    
    private func configure() {
        nicknameTextField.text = user.username
        nameTextField.text = user.firstName
        surnameTextField.text = user.lastName
        phoneTextField.text = user.phoneNumber
        emailTextField.text = user.email
    }
    
    private func setTextFieldDelegates() {
        nicknameTextField.delegate = self
        nameTextField.delegate = self
        surnameTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkForChanges()
    }
    
    private func checkForChanges() {
        DispatchQueue.main.async {
            let hasChanged = (
                self.nicknameTextField.text != self.initialProfileData.username ||
                self.nameTextField.text != self.initialProfileData.firstName ||
                self.surnameTextField.text != self.initialProfileData.lastName ||
                self.phoneTextField.text != self.initialProfileData.phoneNumber
            )
            
            let isNotEmpty = !self.nicknameTextField.text!.isEmpty &&
            !self.nameTextField.text!.isEmpty &&
            !self.surnameTextField.text!.isEmpty &&
            !self.phoneTextField.text!.isEmpty
            
            self.enableSaveButton(hasChanged && isNotEmpty)
        }
    }
    
    private func enableSaveButton(_ isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
        saveButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.systemGray6
        title = "Редактировать профиль"
        
        // Add subviews
        view.addSubview(profileImageView)
        view.addSubview(editImageButton)
        view.addSubview(nicknameTextField)
        view.addSubview(nameTextField)
        view.addSubview(surnameTextField)
        view.addSubview(phoneTextField)
        view.addSubview(emailTextField)
        view.addSubview(saveButton)
        view.addSubview(deleteButton)
        
        // Set up back button
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(didTapBack)
        )
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        editImageButton.translatesAutoresizingMaskIntoConstraints = false
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        surnameTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            editImageButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 5),
            editImageButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5),
            editImageButton.widthAnchor.constraint(equalToConstant: 24),
            editImageButton.heightAnchor.constraint(equalToConstant: 24),
            
            nicknameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30),
            nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            nameTextField.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 12),
            nameTextField.leadingAnchor.constraint(equalTo: nicknameTextField.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: nicknameTextField.trailingAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            surnameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12),
            surnameTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            surnameTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            surnameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            phoneTextField.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: 12),
            phoneTextField.leadingAnchor.constraint(equalTo: surnameTextField.leadingAnchor),
            phoneTextField.trailingAnchor.constraint(equalTo: surnameTextField.trailingAnchor),
            phoneTextField.heightAnchor.constraint(equalToConstant: 44),
            
            emailTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 12),
            emailTextField.leadingAnchor.constraint(equalTo: phoneTextField.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: phoneTextField.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            saveButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            deleteButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 16),
            deleteButton.leadingAnchor.constraint(equalTo: saveButton.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Actions
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapSave() {
        let editProfile = ProfileEdit(
            username: nicknameTextField.text ?? "",
            firstName: nameTextField.text ?? "",
            lastName: surnameTextField.text ?? "",
            phoneNumber: phoneTextField.text ?? ""
        )
        
        ProfileService.shared.editProfile(with: editProfile) { success, error in
            if success {
                print("Profile updated successfully")
                // Save new state as initial state
                self.initialProfileData = editProfile
                self.checkForChanges()
            } else {
                print("Error updating profile: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    @objc private func didTapDelete() {
        // Handle delete action
        print("Delete account")
    }
    
    private func setupActions() {
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        editImageButton.addTarget(self, action: #selector(didTapEditImage), for: .touchUpInside)
    }
    
    @objc private func didTapEditImage() {
        // Handle edit profile image
        print("Edit profile image tapped")
    }
    
    // MARK: - Helper Method
    private static func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        return textField
    }
}
