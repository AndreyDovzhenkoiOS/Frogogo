//
//  ListUsersViewController.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/25/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class ListUsersViewController: UIViewController {

    private let gradientLayer = CAGradientLayer().then {
        let colors = [Asset.orange.color.cgColor, Asset.purple.color.cgColor]
        $0.setupGradient(start: .topRight, end: .bottomLeft, colors: colors)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureGradient()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.frame
    }

    private func configureGradient() {
        view.layer.addSublayer(gradientLayer)
    }
}
