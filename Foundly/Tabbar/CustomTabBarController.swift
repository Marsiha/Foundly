import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setValue(CustomTabBar(), forKey: "tabBar")
        setupViewControllers()
    }

    private func setupViewControllers() {
        self.tabBar.backgroundColor = .foundlyPolar
        
        let historyVC = HistoryViewController()
        historyVC.tabBarItem = UITabBarItem(title: "История", image: UIImage(systemName: "clock.arrow.circlepath"), tag: 0)

        let mapVC = MapViewController()
        mapVC.tabBarItem = UITabBarItem(title: "Карта", image: UIImage(systemName: "map"), tag: 1)
        
        let postVC = PostViewController()
        postVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "plus.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 1)), tag: 2)
        
        let chatVC = ConversationsViewController()
        chatVC.tabBarItem = UITabBarItem(title: "Чат", image: UIImage(systemName: "message"), tag: 3)

        let profileVC = SettingViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.crop.circle"), tag: 4)

        viewControllers = [UINavigationController(rootViewController: mapVC),
                           UINavigationController(rootViewController: historyVC),
                           UINavigationController(rootViewController: postVC),
                           UINavigationController(rootViewController: chatVC),
                           UINavigationController(rootViewController: profileVC)]
    }
}
