import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Verificar se usuário está logado
        if UserDefaults.standard.string(forKey: "userToken") != nil {
            let tabBarVC = createTabBarController()
            window?.rootViewController = tabBarVC
        } else {
            let loginVC = LoginViewController()
            let navVC = UINavigationController(rootViewController: loginVC)
            window?.rootViewController = navVC
        }
        
        window?.makeKeyAndVisible()
        return true
    }
    
    private func createTabBarController() -> UITabBarController {
        let tabBar = UITabBarController()
        
        let dashboardVC = DashboardViewController()
        let dashboardNav = UINavigationController(rootViewController: dashboardVC)
        dashboardNav.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "chart.bar"), tag: 0)
        
        let keysVC = KeysViewController()
        let keysNav = UINavigationController(rootViewController: keysVC)
        keysNav.tabBarItem = UITabBarItem(title: "Keys", image: UIImage(systemName: "key"), tag: 1)
        
        let devicesVC = DevicesViewController()
        let devicesNav = UINavigationController(rootViewController: devicesVC)
        devicesNav.tabBarItem = UITabBarItem(title: "Devices", image: UIImage(systemName: "iphone"), tag: 2)
        
        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(title: "Perfil", image: UIImage(systemName: "person"), tag: 3)
        
        tabBar.viewControllers = [dashboardNav, keysNav, devicesNav, profileNav]
        return tabBar
    }
}
