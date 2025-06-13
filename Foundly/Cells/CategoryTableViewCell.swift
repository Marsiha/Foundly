//
//  CategoryTableViewCell.swift
//  Foundly
//
//  Created by mars uzhanov on 01.05.2025.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    let categoryImageView = UIImageView()
    let titleLabel = UILabel()
    let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func setupUI() {
        categoryImageView.layer.cornerRadius = 25
        categoryImageView.clipsToBounds = true
        categoryImageView.contentMode = .scaleAspectFill
        
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        arrowImageView.tintColor = .black
        
        contentView.addSubview(categoryImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImageView)
        
        categoryImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(categoryImageView.snp.right).offset(16)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(name: String, photo: String) {
        
        let urlString = "https://foundly.kz\(photo)"
        let imageUrl = URL(string: urlString)
        categoryImageView.kf.setImage(with: imageUrl, placeholder: UIImage(systemName: "house"))
    
        titleLabel.text = name
    }
    
}
