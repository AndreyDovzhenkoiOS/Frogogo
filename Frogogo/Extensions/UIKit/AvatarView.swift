//
//  AvatarView.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/28/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit
import Kingfisher

final class AvatarView: UIView {

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCircleView()
        configureIconImageView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setImage(with urlString: String?) {
        if let url = urlString, !url.isEmpty {
            iconImageView.kf.setImage(with: URL(string: url))
        } else {
            iconImageView.image = emptyImage
        }
    }

    private var emptyImage: UIImage? {
        return [
            Asset.emptyIcon1.image,
            Asset.emptyIcon2.image,
            Asset.emptyIcon3.image,
            Asset.emptyIcon4.image,
            Asset.emptyIcon5.image,
            Asset.emptyIcon6.image
            ].randomElement()
    }

    private func configureCircleView() {
        addSubview(circleView)
        circleView.left(16).top(8).height(52).aspectRatio()
    }

    private func configureIconImageView() {
        circleView.addSubview(iconImageView)
        iconImageView.pin()
    }
}
