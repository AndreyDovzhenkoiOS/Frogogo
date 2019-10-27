//
//  NotificationCenter.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/27/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

extension NotificationCenter {

    static func post(_ name: Notification.Name, _ object: Any?) {
        NotificationCenter.default.post(name: name, object: object)
    }

    static func addObserver(_ observer: Any,
                            _ selector: Selector,
                            _ name: Notification.Name) {

        NotificationCenter.default.addObserver(observer, selector: selector,
                                               name: name,
                                               object: nil)
    }
}

enum NotificationName {
    static let keyboardWillShowNotification = UIResponder.keyboardWillShowNotification
    static let keyboardWillHideNotification = UIResponder.keyboardWillHideNotification
}
