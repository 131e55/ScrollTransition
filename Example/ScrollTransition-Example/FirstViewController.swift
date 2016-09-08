//
//  FirstViewController.swift
//  ScrollTransition-Example
//
//  Created by 131e55 on 2016/09/09.
//  Copyright © 2016年 131e55. All rights reserved.
//

import UIKit
import ScrollTransition

class FirstViewController: UIViewController {

    private var animationController = ScrollAnimationController()
    private var interactionController = ScrollInteractionController()

    override func viewDidLoad() {

        super.viewDidLoad()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        segue.destinationViewController.transitioningDelegate = self
        self.interactionController.setTarget(segue.destinationViewController, type: .dismiss)
    }
}

extension FirstViewController: UIViewControllerTransitioningDelegate {

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        self.animationController.direction = .upToDown
        self.interactionController.dismissDirection = .downToUp

        return self.animationController
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        self.animationController.direction = .downToUp

        return self.animationController
    }

    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        return self.interactionController.inProgress ? self.interactionController : nil
    }

    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        return nil
    }
}
