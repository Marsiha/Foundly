import UIKit

class HistoryItemTableViewCell: UITableViewCell {
    
    private lazy var subView: UIView = {
        let view = UIView()
        view.backgroundColor = .foundlyPolar
        view.layer.cornerRadius = 16
        return view
    }()
    private let titleLabel = UILabel()
    private let locationLabel = UILabel()
    private let typeLabel = UILabel()
    private let detailsButton = UIButton()
    
    func configure(title: String, location: String, status: String, type: String, time: String, description: String) {
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        locationLabel.text = description
        locationLabel.textColor = .gray
        locationLabel.font = UIFont.systemFont(ofSize: 14)
        
        typeLabel.text = type
        typeLabel.textColor = .white
        typeLabel.layer.cornerRadius = 8
        typeLabel.layer.masksToBounds = true
        typeLabel.textAlignment = .center
        typeLabel.backgroundColor = .foundlySecondary
        typeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        detailsButton.setTitle("подробнее", for: .normal)
        detailsButton.backgroundColor = .purple
        detailsButton.setTitleColor(.white, for: .normal)
        detailsButton.layer.cornerRadius = 5
        
        contentView.addSubview(subView)
        subView.addSubview(titleLabel)
        subView.addSubview(locationLabel)
        subView.addSubview(typeLabel)
        subView.addSubview(detailsButton)
        
        subView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom)
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(30)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
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
            make.leading.equalTo(titleLabel)
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}
