import UIKit
import Kingfisher
import FirebaseAuth

struct Sections {
    let options: [SettingOptionsType]
}

enum SettingOptionsType {
    case staticCell(model: SettingOptions)
    case switchCell(model: SettingSwitchOptions)
}

struct SettingSwitchOptions {
    let title: String
    let icon: UIImage?
    let handler: (() -> Void)
    let isOn: Bool
}

struct SettingOptions {
    let title: String
    let icon: UIImage?
    let handler: (() -> Void)
}

class SettingViewController: UIViewController {
    
    private var user: User?
    
    var models = [Sections]()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let photo = UIImageView()
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        photo.layer.cornerRadius = 50
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    
    private let editImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        button.tintColor = .purple
        button.addTarget(self, action: #selector(didTapEditImage), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        table.dataSource = self
        table.backgroundColor = .none
        table.delegate = self
        table.isScrollEnabled = false
        table.separatorInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9760319591, green: 0.9561954141, blue: 0.982362926, alpha: 1)
        navigationItem.title = "FOUNDLY"
        configure()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserData()
    }
    
    func configure() {
        models.append(Sections(options: [
            .staticCell(model: SettingOptions(title: "My QR", icon: UIImage(systemName: "viewfinder")) {
                guard let user = self.user else { return }
                let vc = QRViewController(user: user)
                self.navigationController?.pushViewController(vc, animated: true)
            }),
            .switchCell(model: SettingSwitchOptions(title: "Dark mode", icon: UIImage(systemName: "circle.lefthalf.filled.righthalf.striped.horizontal"), handler: {
                
            }, isOn: false))
        ]))
        
        models.append(Sections(options: [
            .staticCell(model: SettingOptions(title: "Change password", icon: UIImage(systemName: "lock")) {
                let vc = ChangePasswordViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }),
            .staticCell(model: SettingOptions(title: "Help", icon: UIImage(systemName: "ellipsis.message")) {
                let email = "daianabatyrkhan_04@icloud.com"
                let subject = "Help to use "
                let body = "Hello, I have a question about the ..."
                
                if let url = URL(string: "mailto:\(email)?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    } else {
                        AlertManager.showUnknownFetchingUserError(on: self)
                    }
                }
            }),
            .staticCell(model: SettingOptions(title: "Term service", icon: UIImage(systemName: "shield")) {
                let vc = TermServiceViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
        ]))
        
        models.append(Sections(options: [
            .staticCell(model: SettingOptions(title: "Logout", icon: UIImage(systemName: "door.left.hand.open")) {
                AuthService.shared.signOut { success in
                    DispatchQueue.main.async {
                        if success {
                            print("User signed out successfully")
                            let loginVC = LoginViewController()
                            let navController = UINavigationController(rootViewController: loginVC)
                            navController.modalPresentationStyle = .fullScreen
                            self.present(navController, animated: true, completion: nil)
                        } else {
                            print("Failed to sign out")
                        }
                    }
                }
                
                do {
                    try Auth.auth().signOut()
                } catch {
                    print("Error from logout")
                }
            })
        ]))
        
    }
    
    private func setupUI() {
        
        // Labels setup
        let labels = [usernameLabel, emailLabel]
        labels.forEach { label in
            label.font = UIFont.systemFont(ofSize: 16)
            label.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Stack View for Layout
        let stackView = UIStackView(arrangedSubviews: [profileImageView, usernameLabel, emailLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        view.addSubview(tableView)
        view.addSubview(editImageButton)
        
        // Constraints
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
        
        editImageButton.snp.makeConstraints { make in
            make.trailing.equalTo(profileImageView.snp.trailing).offset(5)
            make.bottom.equalTo(profileImageView.snp.bottom).offset(5)
            make.width.height.equalTo(24)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.width.equalToSuperview().multipliedBy(0.95)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        
    }
    
    private func fetchUserData() {
        AuthService.shared.fetchUserData { user, error in
            if let user = user {
                DispatchQueue.main.async {
                    self.updateUI(with: user)
                    self.user = user
                }
            } else if let error = error {
                print("Failed to fetch user data: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateUI(with user: User) {
        usernameLabel.text = user.username
        emailLabel.text = user.email
        if let profilePicture = user.profilePicture {
            let urlString = "https://foundly.kz\(profilePicture)"
            let imageUrl = URL(string: urlString)
            profileImageView.kf.setImage(with: imageUrl, placeholder: UIImage(systemName: "house"))
        }
    }
    
    @objc private func didTapEditImage() {
        guard let user = self.user else { return }
        let vc = EditProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        switch model.self {
        case .staticCell(let model):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingTableViewCell.identifier,
                for: indexPath
            ) as! SettingTableViewCell
            cell.configure(with: model)
            return cell
        case .switchCell(let model):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SwitchTableViewCell.identifier,
                for: indexPath
            ) as! SwitchTableViewCell
            cell.configure(with: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = models[indexPath.section].options[indexPath.row]
        switch type.self {
        case .staticCell(let model):
            model.handler()
        case .switchCell(let model):
            model.handler()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
}
