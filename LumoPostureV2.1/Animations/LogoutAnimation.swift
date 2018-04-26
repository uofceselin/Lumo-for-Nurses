//
//  LogoutAnimation.swift
//  LumoPostureV2.1
//
//  Created by Emil Selin on 4/17/18.
//  Copyright © 2018 com. All rights reserved.
//

import UIKit

class LogoutAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    // hide tab and navigation bars animation
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let containerView = transitionContext.containerView
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        guard let tabController = fromViewController as? UITabBarController else {
            return
        }
        
        guard let navController = fromViewController.navigationController else {
            return
        }
        
        let tabOffset = tabController.tabBar.frame.size.height
        let navOffset = -navController.navigationBar.frame.height - navController.navigationBar.frame.minY
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            tabController.tabBar.frame = tabController.tabBar.frame.offsetBy(dx: 0, dy: tabOffset)
            navController.navigationBar.frame = navController.navigationBar.frame.offsetBy(dx: 0, dy: navOffset)
        }, completion: { _ in
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancelled)
        })
    }
}
