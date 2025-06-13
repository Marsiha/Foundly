import UIKit
import SnapKit

class OnboardingPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private var pageVC: UIPageViewController!
    private let pages: [OnboardingPage] = [
        .init(title: "", description: "Ищи потерянные вещи и помогай другим находить. Твоя находка может спасти чей-то день!", imageName: "onboarding1"),
        .init(title: "", description: "Используй интерактивную карту, чтобы отмечать потерянные или найденные предметы рядом.", imageName: "onboarding2"),
        .init(title: "", description: "Быстрый и безопасный чат помогает быстрее вернуть вещь владельцу.", imageName: "onboarding3"),
        .init(title: "", description: "Используй распознавание по фото и QR-теги, чтобы ускорить поиск и возврат.", imageName: "onboarding4")
    ]
    private var controllers: [UIViewController] = []

    private let pageControl = UIPageControl()
    private let skipButton = UIButton()
    private let nextButton = UIButton()
    private let loginButton = UIButton()
    private let createAccountButton = UIButton()
    private var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        controllers = pages.map { OnboardingContentViewController(page: $0) }
        setupPageVC()
        setupButtons()
        setupPageControl()
    }

    private func setupPageVC() {
        pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageVC.dataSource = self
        pageVC.delegate = self
        pageVC.setViewControllers([controllers[0]], direction: .forward, animated: true)

        addChild(pageVC)
        view.addSubview(pageVC.view)
        pageVC.didMove(toParent: self)

        pageVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    private func setupButtons() {
        [skipButton, nextButton, loginButton, createAccountButton].forEach { view.addSubview($0) }

        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(.gray, for: .normal)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)

        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.systemBlue, for: .normal)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)

        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        createAccountButton.setTitle("Create Account", for: .normal)
        createAccountButton.backgroundColor = .systemGreen
        createAccountButton.setTitleColor(.white, for: .normal)
        createAccountButton.layer.cornerRadius = 8
        createAccountButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)

        skipButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
        }

        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
        }

        loginButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-110)
            $0.height.equalTo(45)
        }

        createAccountButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(loginButton)
            $0.top.equalTo(loginButton.snp.bottom).offset(12)
            $0.height.equalTo(45)
        }

        loginButton.isHidden = true
        createAccountButton.isHidden = true
    }

    private func setupPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .lightGray

        view.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(skipButton.snp.top).offset(-16)
        }
    }

    @objc private func skipTapped() {
        goToPage(index: pages.count - 1)
    }

    @objc private func nextTapped() {
        if currentIndex < pages.count - 1 {
            goToPage(index: currentIndex + 1)
        }
    }

    private func goToPage(index: Int) {
        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        pageVC.setViewControllers([controllers[index]], direction: direction, animated: true)
        currentIndex = index
        pageControl.currentPage = index
        updateButtonVisibility()
    }

    private func updateButtonVisibility() {
        let isLastPage = currentIndex == pages.count - 1
        loginButton.isHidden = !isLastPage
        createAccountButton.isHidden = !isLastPage
        nextButton.isHidden = isLastPage
        skipButton.isHidden = isLastPage
        pageControl.isHidden = isLastPage
    }

    @objc private func loginTapped() {
        let loginVC = LoginViewController()
        let navVC = UINavigationController(rootViewController: loginVC)
        navVC.isNavigationBarHidden = true
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }

    @objc private func signupTapped() {
        print("login")
        let registerVC = RegisterViewController()
        let navVC = UINavigationController(rootViewController: registerVC)
        navVC.isNavigationBarHidden = true
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }

    // MARK: - Page View Delegate
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController), index > 0 else { return nil }
        return controllers[index - 1]
    }

    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController), index < controllers.count - 1 else { return nil }
        return controllers[index + 1]
    }

    func pageViewController(_: UIPageViewController, didFinishAnimating _: Bool, previousViewControllers _: [UIViewController], transitionCompleted completed: Bool) {
        if let visibleVC = pageVC.viewControllers?.first,
           let index = controllers.firstIndex(of: visibleVC) {
            currentIndex = index
            pageControl.currentPage = index
            updateButtonVisibility()
        }
    }
}
