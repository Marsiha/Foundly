import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    private var item: Item?

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let imageCarousel = UIPageControl() // Placeholder for custom carousel
    private let contactCard = UIView()
    private let contactNameLabel = UILabel()
    private let contactPhoneLabel = UILabel()
    private let contactImageView = UIImageView()

    private let itemCard = UIView()
    private let itemTitleLabel = UILabel()
    private let itemTimeLabel = UILabel()
    private let itemAddressLabel = UILabel()
    private let categoryTitleLabel = UILabel()
    private let categoryStack = UIStackView()
    private let descriptionBox = UITextView()

    private let foundButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F5F1F9")
        setupViews()
        layoutViews()
    }
    
    init(item: Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        title = "Потерянное"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBack))

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Image Carousel Placeholder
        imageCarousel.currentPage = 0
        imageCarousel.numberOfPages = 3
        contentView.addSubview(imageCarousel)

        // Contact Card
        contactCard.backgroundColor = .white
        contactCard.layer.cornerRadius = 12
        contentView.addSubview(contactCard)

        contactImageView.layer.cornerRadius = 20
        contactImageView.clipsToBounds = true
        contactImageView.image = UIImage(named: "user")
        contactCard.addSubview(contactImageView)

        contactNameLabel.font = .boldSystemFont(ofSize: 16)
        contactNameLabel.text = "Айзада"
        contactCard.addSubview(contactNameLabel)

        contactPhoneLabel.font = .systemFont(ofSize: 15)
        contactPhoneLabel.textColor = .darkGray
        contactPhoneLabel.text = "+7 (777) 567 77 56"
        contactCard.addSubview(contactPhoneLabel)

        // Item Card
        itemCard.backgroundColor = .white
        itemCard.layer.cornerRadius = 12
        contentView.addSubview(itemCard)

        itemTitleLabel.font = .boldSystemFont(ofSize: 17)
        itemTitleLabel.text = "Черный рюкзак"
        itemCard.addSubview(itemTitleLabel)

        itemTimeLabel.font = .systemFont(ofSize: 14)
        itemTimeLabel.textColor = .gray
        itemTimeLabel.text = "Вчера, 12:00"
        itemCard.addSubview(itemTimeLabel)

        itemAddressLabel.font = .systemFont(ofSize: 15)
        itemAddressLabel.numberOfLines = 0
        itemAddressLabel.text = "Проспект Абылай хана , 62 / Жибек Жолы , 85"
        itemCard.addSubview(itemAddressLabel)

        categoryTitleLabel.text = "Категория"
        categoryTitleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        itemCard.addSubview(categoryTitleLabel)

        categoryStack.axis = .horizontal
        categoryStack.spacing = 8
        itemCard.addSubview(categoryStack)

        ["Lorem ipsum", "Lorem ipsum", "Lorem ipsum"].forEach { text in
            let label = UILabel()
            label.text = text
            label.font = .systemFont(ofSize: 14)
            label.textAlignment = .center
            label.backgroundColor = UIColor(hex: "#EBD6FF")
            label.textColor = .black
            label.layer.cornerRadius = 8
            label.clipsToBounds = true
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            label.snp.makeConstraints { make in make.height.equalTo(30).priority(999) }
            categoryStack.addArrangedSubview(label)
        }

        descriptionBox.text = "Описание от пользователя..."
        descriptionBox.font = .systemFont(ofSize: 15)
        descriptionBox.backgroundColor = UIColor(hex: "#F2F2F2")
        descriptionBox.layer.cornerRadius = 10
        descriptionBox.isEditable = false
        itemCard.addSubview(descriptionBox)

        // Found Button
        foundButton.setTitle("Нашел", for: .normal)
        foundButton.backgroundColor = UIColor(hex: "#3D007B")
        foundButton.setTitleColor(.white, for: .normal)
        foundButton.layer.cornerRadius = 8
        foundButton.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
        contentView.addSubview(foundButton)
    }

    private func layoutViews() {
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        imageCarousel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(200)
        }

        contactCard.snp.makeConstraints { make in
            make.top.equalTo(imageCarousel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        contactImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(12)
            make.size.equalTo(40)
        }

        contactNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(contactImageView.snp.right).offset(12)
        }

        contactPhoneLabel.snp.makeConstraints { make in
            make.top.equalTo(contactNameLabel.snp.bottom).offset(4)
            make.left.equalTo(contactNameLabel)
            make.bottom.equalToSuperview().offset(-12)
        }

        itemCard.snp.makeConstraints { make in
            make.top.equalTo(contactCard.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        itemTitleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(12)
        }

        itemTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(itemTitleLabel.snp.bottom).offset(4)
            make.left.equalTo(itemTitleLabel)
        }

        itemAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(itemTimeLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(12)
        }

        categoryTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(itemAddressLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
        }

        categoryStack.snp.makeConstraints { make in
            make.top.equalTo(categoryTitleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(12)
        }

        descriptionBox.snp.makeConstraints { make in
            make.top.equalTo(categoryStack.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview().inset(12)
            make.height.equalTo(100)
        }

        foundButton.snp.makeConstraints { make in
            make.top.equalTo(itemCard.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    @objc private func chatButtonTapped() {
        guard let email = item?.email else { return }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        var name = ""
        DatabaseManager.shared.getDataFor(path: safeEmail) { [weak self] result in
            switch result {
            case .success(let data):
                guard let userData = data as? [String: Any],
                      let firstName = userData["first_name"] as? String,
                      let lastName = userData["last_name"] as? String else {
                    return
                }
                name = "\(firstName) \(lastName)"
                print("move to name: \(name)")
                let vc = ChatViewController(with: name, id: nil)
                vc.title = name
                vc.isNewConversation = true
                self?.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                print("failed to read data with error \(error)")
            }
        }
        
        print("pressed email \(email)")
       
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

