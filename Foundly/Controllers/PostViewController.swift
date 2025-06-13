import UIKit
import JGProgressHUD

class PostViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    let itemType = ["lost_item", "found_item"]
    var imageArray: [UIImage] = []
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private let contentView = UIView()
    
    private lazy var segmentControl: UISegmentedControl = {
        let items = ["Потерянное", "Найденное"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        segmentedControl.tintColor = .foundlyPrimaryDark
        segmentedControl.layer.cornerRadius = 16
        segmentedControl.selectedSegmentTintColor = .foundlyPrimaryDark
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.foundlyPolar], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.foundlyBlack300], for: .normal)
        return segmentedControl
    }()
    
    private lazy var titleView: PostPageCustomView = {
        let view = PostPageCustomView(name: "Название предмета *", placeholder: "Например,  наушники Marshall", type: .title, parentViewController: self)
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var descriptionView: PostPageCustomView = {
        let view = PostPageCustomView(name: "Описание", placeholder: "Введите описание предмета (Цвет, бренд, доп. информация)", type: .description, parentViewController: self)
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var categoryView: PostPageCustomView = {
        let view = PostPageCustomView(name: "Категория *", placeholder: "category items", type: .category, parentViewController: self)
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var photoView: PostPageCustomView = {
        let view = PostPageCustomView(name: "Фото", placeholder: "", type: .photo, parentViewController: self)
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.onImagesSelected = { [weak self] images in
            self?.imageArray = images
        }
        return view
    }()
    
    private lazy var addressView: PostPageCustomView = {
        let view = PostPageCustomView(name: "Адрес *", placeholder: "", type: .address, parentViewController: self)
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var phoneNumberView: PostPageCustomView = {
        let view = PostPageCustomView(name: "Phone number", placeholder: "", type: .phone, parentViewController: self)
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var postButton = CustomButton(title: "Опубликовать", hasBackground: true, fontSize: .med)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "FOUNDLY"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        setupUI()
        postButton.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
        spinner.textLabel.text = "Loading"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .foundlyPrimaryDark
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.9760319591, green: 0.9561954141, blue: 0.982362926, alpha: 1)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [segmentControl, titleView, descriptionView, categoryView, photoView, addressView, phoneNumberView, postButton]
        views.forEach { contentView.addSubview($0) }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
        }
        
        segmentControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        titleView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(90)
        }
        
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(130)
        }
        
        categoryView.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(130)
        }
        
        photoView.snp.makeConstraints { make in
            make.top.equalTo(categoryView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
        }
        
        addressView.snp.makeConstraints { make in
            make.top.equalTo(photoView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(90)
        }
        
        phoneNumberView.snp.makeConstraints { make in
            make.top.equalTo(addressView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(90)
        }
        
        postButton.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    @objc private func handlePost() {
        
        spinner.show(in: view)
        
        let newItem = Item(
            title: titleView.getTitleText(),
            itemType: itemType[segmentControl.selectedSegmentIndex],
            description: descriptionView.getDescriptionText(),
            latitude: addressView.getLat(),
            longitude: addressView.getLong(),
            address: addressView.getAddress(),
            status: "active",
            email: UserDefaults.standard.string(forKey: "email")!,
            date: formatDate(),
            phoneNumber: phoneNumberView.getPhoneNumber(),
            category: UUID(
                uuidString: categoryView.getCagetoryIDs(index: 0)
            )!,
            subcategory: UUID(
                uuidString: categoryView.getCagetoryIDs(index: 1)
            )!,
            subsubcategory: UUID(
                uuidString: categoryView.getCagetoryIDs(index: 2)
            )!
        )
        
        PostService.shared.postItemData(item: newItem, imageArray: imageArray) { [weak self] success in
            if success {
                self?.clearAll()
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.1, animations: {
                        self?.spinner.textLabel.text = "Success"
                        self?.spinner.detailTextLabel.text = nil
                        self?.spinner.indicatorView = JGProgressHUDSuccessIndicatorView()
                    })
                    
                    self?.spinner.dismiss(afterDelay: 1.0)
                }
            } else {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.1, animations: {
                        self?.spinner.textLabel.text = "Failed"
                        self?.spinner.detailTextLabel.text = nil
                        self?.spinner.indicatorView = JGProgressHUDErrorIndicatorView()
                    })
                    
                    self?.spinner.dismiss(afterDelay: 1.0)
                }
            }
        }
       
    }
    
    func formatDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX" // Handles timezone offset
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")

        let isoDateString = formatter.string(from: date)
        return isoDateString
    }
    
    private func clearAll() {
        DispatchQueue.main.async {
            self.categoryView.clear()
            self.addressView.clear()
            self.titleView.clear()
            self.descriptionView.clear()
            self.phoneNumberView.clear()
            self.photoView.clear()
            self.segmentControl.selectedSegmentIndex = 0
            self.imageArray.removeAll()
            self.scrollView.setContentOffset(.zero, animated: true)
        }
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print("Option 1 selected")
        } else {
            print("Option 2 selected")
        }
    }
}

