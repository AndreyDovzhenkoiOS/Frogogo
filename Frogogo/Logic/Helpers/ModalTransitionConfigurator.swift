//
//  ModalTransitionConfigurator.swift
//  Frogogo
//
//  Created by Andrey Dovzhenko on 10/26/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

final class ModalTransitionConfigurator: NSObject, UIViewControllerAnimatedTransitioning {
    var modalOperation: ModalOperation = .present

    private let visualEffectView = UIVisualEffectView().thenUI {
        $0.effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        $0.alpha = 0
    }

    func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionAnimator(transitionContext).startAnimation()
    }

    private func transitionAnimator(_ transition: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let animator = UIViewPropertyAnimator(
            duration: transitionDuration(using: transition),
            curve: .easeInOut
        )
        guard let source = transition.viewController(forKey: .from),
            let destination = transition.viewController(forKey: .to) else {
            return animator
        }

        switch modalOperation {
        case .present:
            transition.containerView.addSubview(visualEffectView)
            transition.containerView.addSubview(destination.view)

            visualEffectView.frame = source.view.frame
            destination.view.transform = CGAffineTransform(translationX: 0, y: destination.view.frame.height)

            animator.addAnimations {
                self.visualEffectView.alpha = 1
                destination.view.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            animator.addCompletion { _ in
                transition.completeTransition(true)
            }
        case .dismiss:
            animator.addAnimations {
                self.visualEffectView.alpha = 0
                source.view.transform = CGAffineTransform(translationX: 0, y: source.view.frame.height)
            }
            animator.addCompletion { _ in
                source.view.removeFromSuperview()
                self.visualEffectView.removeFromSuperview()
                transition.completeTransition(true)
            }
        }
        return animator
    }
}
