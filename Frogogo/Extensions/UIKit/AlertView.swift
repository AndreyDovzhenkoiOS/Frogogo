//
//  AlertView.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/27/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

enum AlertState: Int {
    case close
    case show
}

final class AlertView: UIView {

    var animationHandler: Callback<AlertState>?

    private let imageView = UIImageView().thenUI {
        $0.image = Asset.alertBackground.image
    }

    private let titleLabel = UILabel().thenUI {
        $0.textColor = Asset.darkGreen.color
        $0.font = UIFont.system(.bold, size: 26)
    }

    private let desriptionLabel = UILabel().thenUI {
        $0.textColor = Asset.green.color
        $0.numberOfLines = 0
        $0.font = UIFont.system(.regular, size: 16)
    }

    private let actionButton = UIButton().thenUI {
        $0.backgroundColor = Asset.lightGreen.color
        $0.layer.cornerRadius = 20
        $0.layer.setupShadow(radius: 5, opacity: 0.2, height: 3)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
        configureTitleLabel()
        configureDesriptionLabel()
        configureActionButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureImageView() {
        addSubview(imageView)
        imageView.pin()
    }

    func configure(title: String, description: String, titleAction: String) {
        titleLabel.text = title
        desriptionLabel.text = description
        actionButton.setTitle(titleAction, for: .normal)
    }

    func setAnimationAlert(state: AlertState) {
         switch state {
         case .show:
             animateIn()
         case .close:
             animateOut()
         }
     }

    private func configureTitleLabel() {
        addSubview(titleLabel)
        titleLabel.text = "Ошибка"
        titleLabel.left(32).top(25).right(16).height(26)
    }

    private func configureDesriptionLabel() {
        addSubview(desriptionLabel)
        desriptionLabel.text = "Для продолжения пожалуйста заполните все поля для того что бы добавить нового пользователя"
        desriptionLabel.height(80)
        desriptionLabel.topAnchor ~ titleLabel.bottomAnchor + 5
        desriptionLabel.leadingAnchor ~ titleLabel.leadingAnchor
        desriptionLabel.trailingAnchor ~ titleLabel.trailingAnchor - 16
    }

    private func configureActionButton() {
        addSubview(actionButton)
        actionButton.bottom(10).right(30).width(100)
        actionButton.topAnchor ~ desriptionLabel.bottomAnchor
        actionButton.setTitle("Хорошо", for: .normal)

        actionButton.addAction(for: .touchUpInside) { [weak self] _ in
            self?.setAnimationAlert(state: .close)
        }
    }

   private func animateIn() {
        transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        alpha = 0

        UIView.animate(withDuration: 0.4) {
            self.alpha = 1
            self.transform = CGAffineTransform.identity
            self.animationHandler?(.show)
        }
    }

    private func animateOut() {
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.animationHandler?(.close)
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
