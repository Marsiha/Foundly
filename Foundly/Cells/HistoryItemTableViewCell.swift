import UIKit

class HistoryItemTableViewCell: UITableViewCell {
    
    var item: MapItem?
    
    var parentConroller: UIViewController?
    
    private lazy var subView: UIView = {
        let view = UIView()
        view.backgroundColor = .foundlyPolar
        view.layer.cornerRadius = 16
        return view
    }()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let locationLabel = UILabel()
    private let typeLabel = UILabel()
    private let detailsButton = UIButton()
    
    func configure(item: MapItem, parentContreller: UIViewController?) {
        self.item = item
        self.parentConroller = parentContreller
        titleLabel.text = item.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        dateLabel.text = formatDate(item.date)
        dateLabel.textColor = .gray
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        
        locationLabel.text = item.address
        locationLabel.textColor = .black
        locationLabel.numberOfLines = 2
        locationLabel.font = UIFont.systemFont(ofSize: 16)
        if item.status == "active" {
            typeLabel.text = "активный"
        } else {
            typeLabel.text = "неактивный"
        }
        typeLabel.textColor = .white
        typeLabel.layer.cornerRadius = 8
        typeLabel.layer.masksToBounds = true
        typeLabel.textAlignment = .center
        typeLabel.backgroundColor = .foundlySecondary
        typeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        detailsButton.setTitle("подробнее", for: .normal)
        detailsButton.backgroundColor = .purple
        detailsButton.setTitleColor(.white, for: .normal)
        detailsButton.addTarget(self, action: #selector(detailsButtonTapped), for: .touchUpInside)
        detailsButton.layer.cornerRadius = 5
        
        contentView.addSubview(subView)
        subView.addSubview(titleLabel)
        subView.addSubview(dateLabel)
        subView.addSubview(locationLabel)
        subView.addSubview(typeLabel)
        subView.addSubview(detailsButton)
        
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.height.equalTo(30)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(15)
            make.height.equalTo(20)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(titleLabel)
            make.height.equalTo(50)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        
        detailsButton.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.bottom.equalToSuperview().offset(-10)
        }
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
    
    @objc func detailsButtonTapped() {
        guard let item else { return }
        print("history \(item)")
        let vc = DetailViewController(item: item)
        self.parentConroller?.navigationController?.pushViewController(vc, animated: true)
    }
}
