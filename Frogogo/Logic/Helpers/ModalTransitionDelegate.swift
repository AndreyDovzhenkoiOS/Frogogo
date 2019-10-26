//
//  Presentable.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/26/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

enum ModalOperation {
    case present
    case dismiss
}

final class ModalTransitionDelegate: NSObject {
    private let transitionConfigurator = ModalTransitionConfigurator()

    private func configurator(for operation: ModalOperation) -> ModalTransitionConfigurator {
        transitionConfigurator.modalOperation = operation
        return transitionConfigurator
    }
}

extension ModalTransitionDelegate: UIViewControllerTransitioningDelegate {
    func animationController(forPresented _: UIViewController,
                             presenting _: UIViewController,
                             source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return configurator(for: .present)
    }

    func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return configurator(for: .dismiss)
    }
}
