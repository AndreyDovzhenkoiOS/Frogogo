//
//  ReusableView.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/25/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}

extension UITableViewHeaderFooterView: ReusableView {}

extension UICollectionReusableView: ReusableView {}

extension UITableView {
    func register(_ types: ReusableView.Type...) {
        types.forEach {
            register($0.self, forCellReuseIdentifier: $0.defaultReuseIdentifier)
        }
    }

    func register<T>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }

        return cell
    }

    func registerHeaderFooter<T>(_ class: T.Type) where T: ReusableView {
        register(`class`, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>(_: T.Type) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T else {
            fatalError("Could not dequeue header/footer with identifier: \(T.defaultReuseIdentifier)")
        }

        return view
    }
}
