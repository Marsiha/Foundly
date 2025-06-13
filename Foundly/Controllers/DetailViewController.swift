import UIKit
import SnapKit
import Kingfisher

class DetailViewController: UIViewController {
    
    private var item: MapItem?
    
    private var conversations: [Conversation] = []
    
    var phoneNumber: String?
    
    private var selectedImageURLs: [String] = []
    
    private var name: String?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private let contactCard = UIView()
    private let contactNameLabel = UILabel()
    private let contactPhoneLabel = UIButton(type: .system)
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
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        setupViews()
        layoutViews()
        checkOtherUserName()
        getAllConversation()
        configureView()
    }
    
    init(item: MapItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        
        guard let item = item else {
            return
        }
        
        // Title
        itemTitleLabel.text = item.title ?? "Без названия"
        
        // Time (you may format ISO date)
        itemTimeLabel.text = formatDate(item.date)
        
        // Address
        itemAddressLabel.text = item.address
        
        // Description
        descriptionBox.text = item.description
        
        contactPhoneLabel.setTitle(item.phoneNumber, for: .normal)
        contactPhoneLabel.addTarget(self, action: #selector(didTapPhoneButton), for: .touchUpInside)
        phoneNumber = item.phoneNumber
        
        // Contact Info
        contactNameLabel.text = item.email.components(separatedBy: "@").first?.capitalized ?? "Пользователь"
        
        // Category Tags – Replace these with actual values
        categoryStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        [item.category, item.subcategory, item.subsubcategory].forEach { id in
            let label = UILabel()
            label.text = id // Ideally map UUID to readable name
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
        
        loadImagesIntoCarousel(item.photos)
    }
    
    func loadImagesIntoCarousel(_ photos: [Photo]) {
        for photo in photos {
            
            let fullURLString = "https://foundly.kz" + photo.image
            selectedImageURLs.append(fullURLString)
            
        }
        print(selectedImageURLs)
    }
    
    func formatDate(_ isoDate: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "d MMMM, HH:mm"
            return outputFormatter.string(from: date)
        }
        return "Дата неизвестна"
    }
    
    func formatPhone(_ number: String) -> String {
        let formatted = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "+7 ($1) $2-$3", options: .regularExpression)
        return formatted
    }
    
    private func setupViews() {
        title = "Потерянное"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBack))
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Image Carousel Placeholder
        contentView.addSubview(imageCollectionView)
        
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
        
        contactPhoneLabel.setTitleColor(.systemBlue, for: .normal)
        
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
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        guard let item = item else {
            return
        }
        if item.email == email {
            foundButton.isHidden = true
        } else {
            foundButton.isHidden = false
        }
        print("item.email : \(item.email)")
        print("email: \(email)")
        foundButton.setTitle("Начать чат", for: .normal)
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
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        contactCard.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(16)
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
    
    private func checkOtherUserName() {
        guard let email = item?.email else { return }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        DatabaseManager.shared.getDataFor(path: safeEmail) { [weak self] result in
            switch result {
            case .success(let data):
                guard let userData = data as? [String: Any],
                      let firstName = userData["first_name"] as? String,
                      let lastName = userData["last_name"] as? String else {
                    return
                }
                self?.name = "\(firstName) \(lastName)"
                print("other user name: \(self?.name ?? " ")")
            case .failure(let error):
                print("failed to read data with error \(error)")
            }
        }
    }
    
    private func getAllConversation() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        DatabaseManager.shared.getAllConversations(for: safeEmail) { [weak self] result in
            switch result {
            case .success(let conversations):
                guard !conversations.isEmpty else {
                    print("hello conversations???")
                    return
                }
                self?.conversations = conversations
                print(conversations)
                
            case .failure(let error):
                print("failed to get convos: \(error)")
            }
        }
    }
    
    @objc private func didTapPhoneButton() {
        if let phoneNumber = phoneNumber, let url = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func chatButtonTapped() {
        guard let email = item?.email else { return }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        let currentConversations = self.conversations
        if let targetConversation = currentConversations.first(where: {
            $0.otherUserEmail == safeEmail
        }) {
            let vc = ChatViewController(with: targetConversation.otherUserEmail, id: targetConversation.id)
            vc.title = targetConversation.name
            vc.isNewConversation = false
            vc.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            DatabaseManager.shared.conversationExists(with: safeEmail) { [weak self] result in
                switch result {
                case .success(let conversationId):
                    let vc = ChatViewController(with: safeEmail, id: conversationId)
                    vc.title = self?.name
                    vc.isNewConversation = false
                    vc.navigationItem.largeTitleDisplayMode = .never
                    self?.navigationController?.pushViewController(vc, animated: true)
                case .failure(_):
                    let vc = ChatViewController(with: safeEmail, id: nil)
                    vc.title = self?.name
                    vc.isNewConversation = true
                    vc.navigationItem.largeTitleDisplayMode = .never
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
        print("pressed email \(email)")
        
    }
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let url = URL(string: selectedImageURLs[indexPath.item])
        let imageView = UIImageView()
        imageView.kf.setImage(with: url)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(imageView)
        imageView.frame = cell.contentView.bounds
        return cell
    }
    
    // MARK: - UICollectionView Delegate FlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
}
