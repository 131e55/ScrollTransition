//
//  ScrollInteractionController.swift
//  ScrollTransition
//
//  Created by Keisuke Kawamura on 2016/09/08.
//  Copyright © 2016年 Keisuke Kawamura. All rights reserved.
//

import UIKit

public enum ScrollInteractionControllerType {

    case dismiss
    case pop
    case tab
}

public class ScrollInteractionController: UIPercentDrivenInteractiveTransition {

    public var velocityAsFlick: CGFloat = 300

    public var dismissDirection: ScrollDirection = .leftToRight

    private(set) public var inProgress = false

    private var beganDirection: ScrollDirection = .rightToLeft

    private var progress: CGFloat = 0

    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    private var type: ScrollInteractionControllerType = .dismiss

    public func setTarget(viewController: UIViewController, type: ScrollInteractionControllerType) {

        self.viewController = viewController
        self.type = type

        let gesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePanGesture(_:))
        )
        self.viewController.view.addGestureRecognizer(gesture)
    }

    func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {

        let superview = gestureRecognizer.view!.superview!
        let translation = gestureRecognizer.translationInView(superview)
        let velocity = gestureRecognizer.velocityInView(superview)

        switch gestureRecognizer.state {

        case .Began:

            if fabs(velocity.x) > fabs(velocity.y) {

                if velocity.x < 0 {

                    self.beganDirection = .rightToLeft
                }
                else {

                    self.beganDirection = .leftToRight
                }
            }
            else {

                if velocity.y < 0 {

                    self.beganDirection = .downToUp
                }
                else {

                    self.beganDirection = .upToDown
                }
            }

            switch self.type {

            case .dismiss:

                if self.dismissDirection == self.beganDirection {
                    self.inProgress = true
                    self.viewController.dismissViewControllerAnimated(true, completion: nil)
                }

            case .pop:

                break

            case .tab:

                let tabBarController = self.viewController.tabBarController!
                let selectedIndex = tabBarController.selectedIndex
                let viewControllers = tabBarController.viewControllers ?? []

                tabBarController.tabBar.userInteractionEnabled = false

                if self.beganDirection == .rightToLeft {

                    if selectedIndex < viewControllers.count - 1 {

                        self.inProgress = true
                        tabBarController.selectedViewController = viewControllers[selectedIndex + 1]
                    }
                }
                else {

                    if selectedIndex > 0 {

                        self.inProgress = true
                        tabBarController.selectedViewController = viewControllers[selectedIndex - 1]
                    }
                }
            }

        case .Changed:

            guard self.inProgress else {

                return
            }

            switch type {

            case .dismiss:

                if self.dismissDirection.isHorizontal {

                    self.progress = fabs(translation.x) / superview.bounds.width
                }
                else {

                    self.progress = fabs(translation.y) / superview.bounds.height
                }

            case .pop:

                break

            case .tab:

                self.progress = fabs(translation.x) / superview.bounds.width

            }

            self.progress = CGFloat(fminf(fmaxf(Float(self.progress), 0.0), 1.0))

            self.shouldCompleteTransition = self.progress > 0.5

            self.updateInteractiveTransition(self.progress)

        case .Cancelled, .Ended:

            self.inProgress = false

            if self.type == .tab {

                let tabBarController = self.viewController.tabBarController!
                tabBarController.tabBar.userInteractionEnabled = true
            }

            if gestureRecognizer.state == .Cancelled {

                self.cancelInteractiveTransition()
                return
            }

            let minSpeed: CGFloat = 0.05
            let maxSpeed: CGFloat = 0.5
            let speedRange = maxSpeed - minSpeed
            let pi = CGFloat(M_PI)
            self.completionSpeed = sin((self.progress * 2 * pi) - (pi / 2)) * (speedRange / 2) + (speedRange / 2) + minSpeed

            if self.shouldCompleteTransition {

                self.finishInteractiveTransition()
            }
            else {

                var flicked = false

                switch type {

                case .dismiss:

                    if self.dismissDirection.isHorizontal {

                        if (self.beganDirection == .rightToLeft && velocity.x < -self.velocityAsFlick)
                            || (self.beganDirection == .leftToRight && velocity.x > self.velocityAsFlick) {

                            flicked = true
                        }
                    }
                    else {

                        if (self.beganDirection == .upToDown && velocity.y > self.velocityAsFlick)
                            || (self.beganDirection == .downToUp && velocity.y < -self.velocityAsFlick) {

                            flicked = true
                        }
                    }

                case .pop:

                    break

                case .tab:

                    if (self.beganDirection == .rightToLeft && velocity.x < -self.velocityAsFlick)
                        || (self.beganDirection == .leftToRight && velocity.x > self.velocityAsFlick) {

                        flicked = true
                    }
                }

                if flicked {

                    self.completionSpeed = 0.75
                    self.finishInteractiveTransition()
                }
                else {

                    self.cancelInteractiveTransition()
                }
            }

        default:

            break
        }
    }
}
