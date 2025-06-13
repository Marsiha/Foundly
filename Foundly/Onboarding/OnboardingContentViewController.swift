import UIKit

class OnboardingContentViewController: UIViewController {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private lazy var logoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "onboardingLogo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    var page: OnboardingPage?
    
    init(page: OnboardingPage) {
        super.init(nibName: nil, bundle: nil)
        setupUI(with: page)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(with page: OnboardingPage) {
        imageView.image = UIImage(named: page.imageName)
        imageView.contentMode = .scaleAspectFit
        titleLabel.text = page.title
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        subtitleLabel.text = page.description
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        
        [logoView, imageView, titleLabel, subtitleLabel].forEach { view.addSubview($0) }
        
        logoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(40)
            make.width.equalTo(120)
            make.height.equalTo(63)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(logoView.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
