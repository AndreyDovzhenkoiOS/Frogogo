//
//  CALayer.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/26/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

extension CALayer {
    func setupShadow(radius: CGFloat, opacity: Float, height: CGFloat) {
        shouldRasterize = true
        masksToBounds = false
        shadowRadius = radius
        shadowOpacity = opacity
        rasterizationScale = UIScreen.main.scale
        shadowColor = UIColor.black.cgColor
        shadowOffset = CGSize(width: 0, height: height)
    }
}
