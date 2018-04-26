//
//  LoginAnimation.swift
//  LumoPostureV2.1
//
//  Created by Emil Selin on 4/17/18.
//  Copyright © 2018 com. All rights reserved.
//

import UIKit

class LoginAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    // fade animation
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let containerView = transitionContext.containerView
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
 
        guard let navController = fromViewController.navigationController else {
            return
        }
        
        navController.navigationBar.alpha = 0.0
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            fromViewController.view.alpha = 0.0
            navController.navigationBar.alpha = 1.0
        }, completion: { _ in
            fromViewController.view.alpha = 1.0
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancelled)
        })
    }
}
