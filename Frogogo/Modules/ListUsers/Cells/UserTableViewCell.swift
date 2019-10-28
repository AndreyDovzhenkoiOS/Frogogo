//
//  UserTableViewCell.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/25/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit
import Kingfisher

final class UserTableViewCell: UITableViewCell {

    private let circleView = UIView().thenUI {
        $0.backgroundColor = .clear
        $0.layer.borderColor = Asset.lightGreen.color.cgColor
        $0.layer.borderWidth = 3
        $0.layer.cornerRadius = 25
    }

    private let iconImageView = UIImageView().thenUI {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
    }

    private let nameLabel = UILabel().thenUI {
        $0.textColor = Asset.darkGreen.color
        $0.font = UIFont.system(.bold, size: 15)
    }

    private let emailLabel = UILabel().thenUI {
        $0.textColor = Asset.darkGreen.color
        $0.font = UIFont.system(.regular, size: 12)
    }

    private let dateLabel = UILabel().thenUI {
        $0.textColor = Asset.darkGreen.color
        $0.font = UIFont.system(.bold, size: 10)
    }

    private let lineView = UIView().thenUI {
        $0.alpha = 0.5
        $0.backgroundColor = Asset.lightPinkOpacity.color
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        configureLineView()
        configureCircleView()
        configureIconImageView()
        configureNameLabel()
        configureEmailLabel()
        configureDateLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(with user: User?) {
        guard let user = user else { return }
        nameLabel.text = Localized.ListUsers.name(user.fullName)
        emailLabel.text = Localized.ListUsers.email(user.email)
        dateLabel.text = Localized.ListUsers.date(user.createdAt)

        if let url = user.avatar, !url.isEmpty {
            iconImageView.kf.setImage(with: URL(string: url))
        } else {
            iconImageView.image = Asset.emptyIcon4.image
        }
    }

    private func configureCircleView() {
        addSubview(circleView)
        circleView.left(16).top(8).height(52).aspectRatio()
    }

    private func configureIconImageView() {
        circleView.addSubview(iconImageView)
        iconImageView.pin()
    }

    private func configureLineView() {
        addSubview(lineView)
        lineView.height(1).left(18).right().bottom()
    }

    private func configureNameLabel() {
        addSubview(nameLabel)
        nameLabel.right(16).top(10).height(20)
        nameLabel.leadingAnchor ~ iconImageView.trailingAnchor + 25
    }

    private func configureEmailLabel() {
        addSubview(emailLabel)
        emailLabel.height(15)
        emailLabel.topAnchor ~ nameLabel.bottomAnchor + 7
        emailLabel.leadingAnchor ~ nameLabel.leadingAnchor
        emailLabel.trailingAnchor ~ nameLabel.trailingAnchor
    }

    private func configureDateLabel() {
        addSubview(dateLabel)
        dateLabel.height(15).bottom(8)
        dateLabel.leadingAnchor ~ emailLabel.leadingAnchor
        dateLabel.trailingAnchor ~ emailLabel.trailingAnchor
    }
}
