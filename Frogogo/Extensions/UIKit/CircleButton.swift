//
//  CircleButton.swift
//  Frogogo
//
//  Created by Andrey on 10/26/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class CircleButton: UIButton {
    init(color: UIColor) {
        super.init(frame: CGRect.zero)
        backgroundColor = color
    }

    func setImage(image: UIImage) {
        imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
        setImage(image, for: .normal)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
}
