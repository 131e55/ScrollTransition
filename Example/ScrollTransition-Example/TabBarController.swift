//
//  TabBarController.swift
//  tabsample
//
//  Created by 131e55 on 2016/09/08.
//  Copyright © 2016年 131e55. All rights reserved.
//

import UIKit
import ScrollTransition

class TabBarController: UITabBarController {

    private var animationController = ScrollAnimationController()
    private var interactionController = ScrollInteractionController()

    override func viewDidLoad() {

        super.viewDidLoad()

        self.delegate = self

        self.addObserver(
            self,
            forKeyPath: "selectedViewController",
            options: .New,
            context: nil
        )
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {

        if keyPath == "selectedViewController" {

            self.interactionController.setTarget(self.selectedViewController!, type: .tab)
        }
    }
}

extension TabBarController: UITabBarControllerDelegate {

    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let fromVCIndex = tabBarController.viewControllers!.indexOf(fromVC)!
        let toVCIndex = tabBarController.viewControllers!.indexOf(toVC)!
        self.animationController.direction = fromVCIndex < toVCIndex ? .rightToLeft : .leftToRight

        return self.animationController
    }

    func tabBarController(tabBarController: UITabBarController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        return self.interactionController.inProgress ? self.interactionController : nil
    }
}
