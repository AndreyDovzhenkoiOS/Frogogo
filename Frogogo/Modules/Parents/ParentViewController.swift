//
//  ParentViewController.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/25/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {
    enum NavigationBarStyle {
        case `default`, compact, hidden
    }

    var navigationBarStyle: NavigationBarStyle {
        return .`default`
    }

    var navigationBarHidesShadow: Bool {
         return false
     }

    var animatedNavigationBar: Bool {
        return true
    }

    var navigationBarTransparent: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }

    func configureNavigationBar() {
        let isHidden = navigationController?.navigationBar.isHidden ?? true

        if navigationBarHidesShadow {
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        }

        if navigationBarStyle == .hidden {
            if !isHidden {
                navigationController?.setNavigationBarHidden(true, animated: animatedNavigationBar)
            }
        } else if isHidden {
            navigationController?.setNavigationBarHidden(false, animated: animatedNavigationBar)
        }

        switch navigationBarStyle {
        case .default:
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.barTintColor = Asset.green.color
            navigationController?.navigationBar.shadowImage = UIImage()
        case .compact:
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.navigationBar.barTintColor = Asset.green.color
        case .hidden:
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationItem.largeTitleDisplayMode = .never
        }
    }
}
