//
//  PostPageCustomView.swift
//  Foundly
//
//  Created by mars uzhanov on 04.03.2025.
//

import UIKit
import PhotosUI

class PostPageCustomView: UIView {
    
    enum ViewType {
        case title
        case description
        case category
        case photo
        case phone
        case address
    }
    
    private var descriptionPlaceholder = "Введите описание предмета (Цвет, бренд, доп. информация)"
    
    var onImagesSelected: (([UIImage]) -> Void)?
    
    private weak var parentViewController: UIViewController?
    
    private var selectedImages: [UIImage] = []
    
    private var selectedCategory: [String] = []
    
    private var selectedAddress: String?
    
    private var selectedLocation: CLLocationCoordinate2D?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var titleNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 14, weight: .medium)
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .foundlySwan
        textField.textColor = .foundlyBlack700
        return textField
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .foundlySwan
        textView.textColor = .foundlyBlack700
        textView.layer.cornerRadius = 8
        return textView
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "+1 (123) 456-7890"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        textField.textContentType = .telephoneNumber
        return textField
    }()
    
    private let addressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "select address"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    init(name: String, placeholder: String, type: ViewType, parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        super.init(frame: .zero)
        descriptionTextView.delegate = self
        switch type {
        case .title:
            titleNameLabel.text = name
            titleTextField.placeholder = placeholder
            descriptionTextView.isHidden = true
            categoryLabel.isHidden = true
            addressTextField.isHidden = true
            actionButton.isHidden = true
            collectionView.isHidden = true
            phoneTextField.isHidden = true
        case .description:
            titleNameLabel.text = name
            descriptionTextView.text = placeholder
            titleTextField.isHidden = true
            categoryLabel.isHidden = true
            actionButton.isHidden = true
            addressTextField.isHidden = true
            collectionView.isHidden = true
            phoneTextField.isHidden = true
        case .category:
            titleNameLabel.text = name
            categoryLabel.text = placeholder
            descriptionTextView.isHidden = true
            titleTextField.isHidden = true
            actionButton.isHidden = false
            collectionView.isHidden = true
            phoneTextField.isHidden = true
            addressTextField.isHidden = true
            actionButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            actionButton.addTarget(self, action: #selector(pickCategory), for: .touchUpInside)
        case .photo:
            titleNameLabel.text = name
            categoryLabel.isHidden = true
            descriptionTextView.isHidden = true
            titleTextField.isHidden = true
            actionButton.isHidden = false
            collectionView.isHidden = false
            addressTextField.isHidden = true
            phoneTextField.isHidden = true
            actionButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
            actionButton.addTarget(self, action: #selector(pickPhotos), for: .touchUpInside)
        case .phone:
            titleNameLabel.text = name
            descriptionTextView.isHidden = true
            titleTextField.isHidden = true
            categoryLabel.isHidden = true
            actionButton.isHidden = true
            collectionView.isHidden = true
            phoneTextField.isHidden = false
            addressTextField.isHidden = true
        case .address:
            titleNameLabel.text = name
            descriptionTextView.isHidden = true
            titleTextField.isHidden = true
            categoryLabel.isHidden = true
            actionButton.isHidden = false
            addressTextField.isHidden = false
            collectionView.isHidden = true
            phoneTextField.isHidden = true
            actionButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            actionButton.addTarget(self, action: #selector(addressPicker), for: .touchUpInside)
        }
        setupUI()
    }
    
    @objc private func addressPicker() {
        let mapVC = MapPickerViewController()
        mapVC.onAddressSelected = { [weak self] address, coordinate in
            print("📍 Address: \(address)")
            print("🌐 Lat: \(coordinate.latitude), Lon: \(coordinate.longitude)")
            
            self?.addressTextField.text = address
            self?.selectedLocation = coordinate
            // You can also store coordinates in your model or use it for further logic
        }
        parentViewController?.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @objc private func pickCategory() {
        let categoryVC = CategoryViewController()
        categoryVC.onSelect = { category, subcategory, subsubcategory in
            self.categoryLabel.text = "\(category.name) > \(subcategory.name) > \(subsubcategory.name)"
            self.selectedCategory.append(category.id)
            self.selectedCategory.append(subcategory.id)
            self.selectedCategory.append(subsubcategory.id)
        }
        parentViewController?.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    
    @objc private func pickPhotos() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 5
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        parentViewController?.present(picker, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.addSubview(titleNameLabel)
        self.addSubview(titleTextField)
        self.addSubview(descriptionTextView)
        self.addSubview(categoryLabel)
        self.addSubview(actionButton)
        self.addSubview(collectionView)
        self.addSubview(phoneTextField)
        self.addSubview(addressTextField)
        
        titleNameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
            make.height.equalTo(20)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleNameLabel.snp.bottom).offset(5)
            make.width.equalToSuperview().multipliedBy(0.90)
            make.centerX.equalToSuperview()
        }
        
        addressTextField.snp.makeConstraints { make in
            make.top.equalTo(titleNameLabel.snp.bottom).offset(5)
            make.width.equalToSuperview().multipliedBy(0.90)
            make.centerX.equalToSuperview()
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(titleNameLabel.snp.bottom).offset(5)
            make.width.equalToSuperview().multipliedBy(0.90)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleNameLabel.snp.bottom).offset(5)
            make.width.equalToSuperview().multipliedBy(0.90)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(titleNameLabel.snp.bottom).offset(5)
            make.width.equalToSuperview().multipliedBy(0.90)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleNameLabel.snp.bottom).offset(5)
            make.width.equalToSuperview().multipliedBy(0.90)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
    }
    
    func clear() {
        descriptionTextView.text = descriptionPlaceholder
        descriptionTextView.textColor = .lightGray
        categoryLabel.text = ""
        phoneTextField.text = ""
        addressTextField.text = ""
        titleTextField.text = ""
        selectedImages.removeAll()
        collectionView.reloadData()
        selectedCategory.removeAll()
        selectedAddress = nil
        selectedLocation = nil
    }
    
    func getCagetoryIDs(index: Int) -> String {
        return selectedCategory[index]
    }
    
    func getPhoneNumber() -> String {
        return phoneTextField.text ?? ""
    }
    
    func getTitleText() -> String {
        return titleTextField.text ?? ""
    }
    
    func getDescriptionText() -> String {
        return descriptionTextView.text ?? ""
    }
    
    func getAddress() -> String {
        return addressTextField.text ?? ""
    }
    
    func getLat() -> CLLocationDegrees {
        return selectedLocation?.latitude ?? 0.0
    }
    
    func getLong() -> CLLocationDegrees {
        return selectedLocation?.longitude ?? 0.0
    }
    
}

extension PostPageCustomView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == descriptionTextView.text {
            textView.text = ""
            textView.textColor = .black  // 🔹 Change text color when user types
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = descriptionTextView.text
            textView.textColor = .lightGray  // 🔹 Restore placeholder
        }
    }
}

extension PostPageCustomView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        selectedImages.removeAll()
        
        let group = DispatchGroup()
        
        for result in results {
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                defer { group.leave() }
                if let image = object as? UIImage {
                    self.selectedImages.append(image)
                }
            }
        }
        
        group.notify(queue: .main) {
            self.collectionView.reloadData()
            self.onImagesSelected?(self.selectedImages)
        }
    }
}

extension PostPageCustomView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView = UIImageView(image: selectedImages[indexPath.item])
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(imageView)
        imageView.frame = cell.contentView.bounds
        return cell
    }
    
    // MARK: - UICollectionView Delegate FlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
