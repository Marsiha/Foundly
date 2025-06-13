//
//  SettingTableViewCell.swift
//  Foundly
//
//  Created by mars uzhanov on 08.03.2025.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    static let identifier = "SettingTableViewCell"
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.frame.size.height - 22
        iconImageView.frame = CGRect(x: 10, y: 12, width: size, height: size)
        
        label.frame = CGRect(
            x: iconImageView.frame.size.width + 15,
            y: 0,
            width: contentView.frame.width - iconImageView.frame.size.width - 15,
            height: contentView.frame.height
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
    }
    
    public func configure(with model: SettingOptions) {
        label.text = model.title
        iconImageView.image = model.icon
    }
}
