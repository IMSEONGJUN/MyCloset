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

enum CategoryButtonType: Int {
    case categorySelectBtn1 = 1
    case categorySelectBtn2
    case categorySelectBtn3
    case categorySelectBtn4
    case categorySelectBtn5
    case categorySelectBtn6
    case categorySelectBtn7
    case categorySelectBtn8
    
    var name: String {
        switch self.rawValue {
        case 1:
            return "top"
        case 2:
            return "bottom"
        case 3:
            return "outer"
        case 4:
            return "shoes"
        case 5:
            return "cap"
        case 6:
            return "socks"
        case 7:
            return "bag"
        case 8:
            return "acc"
        default:
            break
        }
        return ""
    }
    
    var fileCount: Int {
        switch self.rawValue {
        case 1:
            return DataManager.shared.top.count
        case 2:
            return DataManager.shared.bottom.count
        case 3:
            return DataManager.shared.outer.count
        case 4:
            return DataManager.shared.shoes.count
        case 5:
            return DataManager.shared.cap.count
        case 6:
            return DataManager.shared.socks.count
        case 7:
            return DataManager.shared.bag.count
        case 8:
            return DataManager.shared.acc.count
        default:
            break
        }
        return -0
    }
    
}

enum CategoryCellType: Int, CaseIterable {
    case top
    case bottom
    case outer
    case shoes
    case cap
    case socks
    case bag
    case acc
    
    var cellID: String {
        switch self {
        case .top:
            return TopCell.identifier
        case .bottom:
            return BottomCell.identifier
        case .outer:
            return OuterCell.identifier
        case .shoes:
            return ShoesCell.identifier
        case .cap:
            return CapCell.identifier
        case .socks:
            return SocksCell.identifier
        case .bag:
            return BagCell.identifier
        case .acc:
            return AccCollectionViewCell.identifier
        }
    }
    
    func typeCasting(contoller: MyClosetViewController, cell: UICollectionViewCell) -> UICollectionViewCell {
        switch self {
        case .top:
            let casted = cell as! TopCell
            casted.configure(image: nil, title: "셀")
            contoller.delegates[self.rawValue] = casted
            return casted
        case .bottom:
            let casted = cell as! BottomCell
            casted.configure(image: nil, title: "셀")
            contoller.delegates[self.rawValue] = casted
            return casted
        case .outer:
            let casted = cell as! OuterCell
            casted.configure(image: nil, title: "셀")
            contoller.delegates[self.rawValue] = casted
            return casted
        case .shoes:
            let casted = cell as! ShoesCell
            casted.configure(image: nil, title: "셀")
            contoller.delegates[self.rawValue] = casted
            return casted
        case .cap:
            let casted = cell as! CapCell
            casted.configure(image: nil, title: "셀")
            contoller.delegates[self.rawValue] = casted
            return casted
        case .socks:
            let casted = cell as! SocksCell
            casted.configure(image: nil, title: "셀")
            contoller.delegates[self.rawValue] = casted
            return casted
        case .bag:
            let casted = cell as! BagCell
            casted.configure(image: nil, title: "셀")
            contoller.delegates[self.rawValue] = casted
            return casted
        case .acc:
            let casted = cell as! AccCollectionViewCell
            casted.configure(image: nil, title: "셀")
            contoller.delegates[self.rawValue] = casted
            return casted
        }
    }
}
