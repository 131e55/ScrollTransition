//
//  ScrollAnimationController.swift
//  ScrollTransition
//
//  Created by Keisuke Kawamura on 2016/09/08.
//  Copyright © 2016年 Keisuke Kawamura. All rights reserved.
//

import UIKit

public enum ScrollDirection {

    case rightToLeft
    case leftToRight
    case upToDown
    case downToUp

    public var isHorizontal: Bool {

        return self == .rightToLeft || self == .leftToRight
    }

    public var isVertical: Bool {

        return self == .upToDown || self == .downToUp
    }
}

public class ScrollAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    public var duration: Double = 1 / 3

    public var direction: ScrollDirection = .rightToLeft

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {

        return self.duration
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        guard
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
            else {

                return
        }

        switch direction {

        case .rightToLeft:

            self.rightToLeftTransition(transitionContext, toView: toVC.view, fromView: fromVC.view)

        case .leftToRight:

            self.leftToRightTransition(transitionContext, toView: toVC.view, fromView: fromVC.view)

        case .upToDown:

            self.upToDownTransition(transitionContext, toView: toVC.view, fromView: fromVC.view)

        case .downToUp:

            self.downToUpTransition(transitionContext, toView: toVC.view, fromView: fromVC.view)

        }

    }

    private func rightToLeftTransition(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {

        guard let containerView = transitionContext.containerView() else {

            return
        }

        containerView.insertSubview(toView, aboveSubview: fromView)

        toView.frame.origin = CGPoint(x: toView.frame.width, y: 0)

        UIView.animateWithDuration(
            transitionDuration(transitionContext),
            delay: 0,
            options: .CurveEaseInOut,
            animations: { () -> Void in

                toView.frame.origin = CGPointZero
                fromView.frame.origin = CGPoint(x: -fromView.frame.width, y: 0)
            },
            completion: { (finished) -> Void in

                let cancelled = transitionContext.transitionWasCancelled()
                transitionContext.completeTransition(!cancelled)
            }
        )
    }

    private func leftToRightTransition(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {

        guard let containerView = transitionContext.containerView() else {

            return
        }

        containerView.insertSubview(toView, belowSubview: fromView)

        toView.frame.origin = CGPoint(x: -toView.frame.width, y: 0)

        UIView.animateWithDuration(
            transitionDuration(transitionContext),
            delay: 0,
            options: .CurveEaseInOut,
            animations: { () -> Void in

                fromView.frame.origin = CGPoint(x: fromView.frame.width, y: 0)
                toView.frame.origin = CGPointZero
            },
            completion: { (finished) -> Void in

                let cancelled = transitionContext.transitionWasCancelled()
                transitionContext.completeTransition(!cancelled)
            }
        )
    }

    private func upToDownTransition(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {

        guard let containerView = transitionContext.containerView() else {

            return
        }

        containerView.insertSubview(toView, aboveSubview: fromView)

        toView.frame.origin = CGPoint(x: 0, y: -toView.frame.height)

        UIView.animateWithDuration(
            transitionDuration(transitionContext),
            delay: 0,
            options: .CurveEaseInOut,
            animations: { () -> Void in

                toView.frame.origin = CGPointZero
                fromView.frame.origin = CGPoint(x: 0, y: fromView.frame.height)
            },
            completion: { (finished) -> Void in

                let cancelled = transitionContext.transitionWasCancelled()
                transitionContext.completeTransition(!cancelled)
            }
        )
    }

    private func downToUpTransition(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {

        guard let containerView = transitionContext.containerView() else {

            return
        }

        containerView.insertSubview(toView, aboveSubview: fromView)

        toView.frame.origin = CGPoint(x: 0, y: toView.frame.height)

        UIView.animateWithDuration(
            transitionDuration(transitionContext),
            delay: 0,
            options: .CurveEaseInOut,
            animations: { () -> Void in

                toView.frame.origin = CGPointZero
                fromView.frame.origin = CGPoint(x: 0, y: -fromView.frame.height)
            },
            completion: { (finished) -> Void in

                let cancelled = transitionContext.transitionWasCancelled()
                transitionContext.completeTransition(!cancelled)
            }
        )
    }
}
