import UIKit
import Kingfisher

class QRViewController: UIViewController {
    
    private let user: User

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()

    private let downloadButton: CustomButton = {
        let button = CustomButton(title: "Download", hasBackground: true, fontSize: .med)
        button.addTarget(self, action: #selector(downloadTapped), for: .touchUpInside)
        return button
    }()

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupUI()
    }
    
    private func configure() {
        nameLabel.text = user.firstName + " " + user.lastName
        if let profilePicture = user.profilePicture, let qrPicture = user.qrCode {
            let profileUrlString = "https://foundly.kz\(profilePicture)"
            let qrUrlString = "https://foundly.kz\(qrPicture)"
            let profileImageUrl = URL(string: profileUrlString)
            let qrImageUrl = URL(string: qrUrlString)
            profileImageView.kf.setImage(with: profileImageUrl, placeholder: UIImage(systemName: "house"))
            qrCodeImageView.kf.setImage(with: qrImageUrl, placeholder: UIImage(systemName: "person"))
        }
        
    }

    private func setupBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.purple.cgColor,
            UIColor.systemPurple.cgColor,
            UIColor.white.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupUI() {
        navigationItem.title = "Мой QR"
        view.backgroundColor = .white

        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backTapped))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
        
        let scannerButton = UIBarButtonItem(
            image: UIImage(systemName: "qrcode.viewfinder"),
            style: .plain,
            target: self,
            action: #selector(scannerTapped)
        )
        scannerButton.tintColor = .white
        navigationItem.rightBarButtonItem = scannerButton

        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(qrCodeImageView)
        view.addSubview(downloadButton)

        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        qrCodeImageView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(300)
        }

        downloadButton.snp.makeConstraints { make in
            make.top.equalTo(qrCodeImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(40)
        }
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func scannerTapped() {
        let vc = QRCodeScannerViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func downloadTapped() {
        guard let qrImage = qrCodeImageView.image else { return }

        UIImageWriteToSavedPhotosAlbum(qrImage, self, #selector(imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("❌ Error saving image: \(error.localizedDescription)")
        } else {
            let alert = UIAlertController(title: "Успешно", message: "QR-код сохранён в галерею", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default))
            present(alert, animated: true)
        }
    }
}
