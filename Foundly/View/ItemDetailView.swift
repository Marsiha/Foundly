import UIKit

class ItemDetailView: UIView {
    
    public var item: MapItem?
    
    private weak var parentViewController: UIViewController?
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let addressLabel = UILabel()
    private let dateLabel = UILabel()
    private let phoneButton = UIButton(type: .system)
    
    private let detailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("подробнее", for: .normal)
        button.backgroundColor = .foundlyPrimaryDark
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var phoneNumber: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        titleLabel.font = .boldSystemFont(ofSize: 18)
        descriptionLabel.font = .systemFont(ofSize: 14)
        addressLabel.font = .systemFont(ofSize: 14)
        dateLabel.font = .systemFont(ofSize: 12)
        phoneButton.setTitleColor(.systemBlue, for: .normal)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, addressLabel, dateLabel, phoneButton])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        
        addSubview(stack)
        addSubview(detailsButton)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        detailsButton.snp.makeConstraints { make in
            make.top.equalTo(stack.snp.bottom).inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
    }
    
    private func setupActions() {
        phoneButton.addTarget(self, action: #selector(didTapPhoneButton), for: .touchUpInside)
    }
    
    @objc private func didTapPhoneButton() {
        if let phoneNumber = phoneNumber, let url = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func detailButtonTapped() {
        guard let item else { return }
        let vc = DetailViewController(item: item)
        parentViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func configure(with item: MapItem, parentViewContreller: UIViewController?) {
        self.parentViewController = parentViewContreller
        self.item = item
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        addressLabel.text = "📍 \(item.address)"
        dateLabel.text = "🗓 \(item.date)"
        phoneButton.setTitle("📞 \(item.phoneNumber)", for: .normal)
        phoneNumber = item.phoneNumber
    }
}
