//
//  Then.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/25/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

protocol Then {}

extension NSObject: Then {}

extension Then {
    func then(completion: (Self) -> Void) -> Self {
        completion(self)
        return self
    }
}

extension Then where Self: UIView {
    func thenUI(completion: (Self) -> Void) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        completion(self)
        return self
    }
}
