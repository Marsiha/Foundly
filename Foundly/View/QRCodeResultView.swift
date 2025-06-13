import UIKit
import Kingfisher

class QRCodeResultView: UIView {

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "QR Code Data"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(infoLabel)
        containerView.addSubview(closeButton)

        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(300)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(containerView).inset(16)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(containerView).inset(16)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(containerView).inset(16)
            make.height.equalTo(44)
            make.bottom.equalTo(containerView).offset(-16)
        }
    }


    // MARK: - Set Data
    func setData(_ data: QR) {
        titleLabel.text = data.phoneNumber
        infoLabel.text = data.firstName + " " + data.lastName
        if let profilePicture = data.profilePicture {
            let profileUrlString = "https://foundly.kz\(profilePicture)"
            let profileImageUrl = URL(string: profileUrlString)
            profileImageView.kf.setImage(with: profileImageUrl, placeholder: UIImage(systemName: "house"))
        }
    }

    // MARK: - Close Button Action
    @objc private func closeTapped() {
        removeFromSuperview()
    }
}
