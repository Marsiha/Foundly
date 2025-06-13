import UIKit

class CustomTabBar: UITabBar {
    
    private let customHeight: CGFloat = 100
    
    private let centerButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "plus.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 52))
        button.setImage(image, for: .normal)
        button.tintColor = .foundlyPrimaryDark
        button.backgroundColor = .clear
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCenterButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCenterButton()
    }
    
    private func setupCenterButton() {
        addSubview(centerButton)
        centerButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonSize: CGFloat = 60
        
        let tabBarHeight = bounds.height
        
        centerButton.frame = CGRect(
            x: (bounds.width - buttonSize) / 2,
            y: tabBarHeight - buttonSize - 30,
            width: buttonSize,
            height: buttonSize
        )
        
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = customHeight
        return sizeThatFits
    }
    
    @objc private func centerButtonTapped() {
        if let tabBarController = self.window?.rootViewController as? UITabBarController {
            let postVC = PostViewController()
            postVC.modalPresentationStyle = .fullScreen
            tabBarController.present(postVC, animated: true, completion: nil)
        }
    }
    
}
