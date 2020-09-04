import Foundation
import UIKit
import NeumorphismTab


extension UIView {
    func shadow() {
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowColor = UIColor.darkGray.cgColor
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}
extension UIViewController {
    func switchingView() {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.makeKeyAndVisible()
                let mainVC = MainViewController()
                mainVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
                let mainNavi = UINavigationController(rootViewController: mainVC)
                let myclosetVC = MyClosetViewController()
                myclosetVC.tabBarItem = UITabBarItem(title: "MyCloset", image: UIImage(systemName: "tray.2"), selectedImage: UIImage(systemName: "tray.2.fill"))
                
                let prevCodiVC = PrevCodiViewController()
                prevCodiVC.tabBarItem = UITabBarItem(title: "PrevSet", image: UIImage(systemName: "clock"), selectedImage: UIImage(systemName: "clock.fill"))
                let prevNavi = UINavigationController(rootViewController: prevCodiVC)
                
                let tabbar = UITabBarController()
                tabbar.viewControllers = [mainNavi, myclosetVC, prevNavi]
                window.rootViewController = tabbar
                let sceneDelegate = windowScene.delegate as? SceneDelegate
                sceneDelegate?.window = window
            }
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let window = UIWindow(frame: UIScreen.main.bounds)
            let mainVC = MainViewController()
            mainVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
            let mainNavi = UINavigationController(rootViewController: mainVC)
            let myclosetVC = MyClosetViewController()
            myclosetVC.tabBarItem = UITabBarItem(title: "MyCloset", image: UIImage(systemName: "tray.2"), selectedImage: UIImage(systemName: "tray.2.fill"))
            let prevCodiVC = PrevCodiViewController()
            prevCodiVC.tabBarItem = UITabBarItem(title: "PrevSet", image: UIImage(systemName: "clock"), selectedImage: UIImage(systemName: "clock.fill"))
            let prevNavi = UINavigationController(rootViewController: prevCodiVC)
            
            let tabbar = UITabBarController()
            tabbar.viewControllers = [mainNavi, myclosetVC, prevNavi]
            window.rootViewController = tabbar
            window.makeKeyAndVisible()
            appDelegate.window = window
        }
    }
    
    func presentAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default) { (action) in
                self.dismiss(animated: true)
            }
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
    }
}
extension TitleCell {
    func drawLine() {
        let doYourPath = UIBezierPath(rect: CGRect(x: 30, y: self.frame.height * 0.7, width: 240, height: 7))
        let layer = CAShapeLayer()
        layer.path = doYourPath.cgPath
        layer.strokeColor = UIColor.lightGray.cgColor
        layer.fillColor = UIColor.black.cgColor
        self.layer.addSublayer(layer)
    }
}
