

import UIKit
import SegementSlide
import ImpressiveNotifications

class BaseViewController: SegementSlideDefaultViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func segementSlideHeaderView() -> UIView? {
        let headerView = UIImageView()
        headerView.isUserInteractionEnabled = true
        headerView.contentMode = .scaleAspectFill
        headerView.image = UIImage(named: "header")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let headerHeight: CGFloat
        if #available(iOS 11.0, *) {
            headerHeight = view.bounds.height / 4 + view.safeAreaInsets.top
        }else {
            headerHeight = view.bounds.height / 4 + topLayoutGuide.length
        }
        headerView.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true
        return headerView
    }
    
    override var titlesInSwitcher: [String]{
        return ["Top", "Abema", "Yahoo", "IT", "Buzz", "CNN"]
    }
    
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        switch index {
        case 0:
            return Page1ViewController()
        case 1:
            return Page2ViewController()
        case 2:
            return Page3ViewController()
        case 3:
            return Page4ViewController()
        case 4:
            return Page5ViewController()
        case 5:
            return Page6ViewController()
        default:
            return Page1ViewController()
        }
    }

    private func setupView() {
        reloadData()
        defaultSelectedIndex = 0
        DispatchQueue.main.async {
            INNotifications.show(type: .success, data: INNotificationData(title: "ようこそ!", description: "毎日18時にニュースがアップデートされます!", image: UIImage(named: "checkImage"), delay: 1.0, completionHandler: {
            }))
        }
    }

}
