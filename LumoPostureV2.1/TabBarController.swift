//
//  TabBarController.swift
//  LumoPostureV2.1
//
//  Created by Emil Selin on 4/17/18.
//  Copyright © 2018 com. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // overview
        let overviewViewController = OverviewViewController()
        let overviewViewTabItem = UITabBarItem(title: "Overview", image: UIImage(named: "overview.png"), selectedImage: nil)
        overviewViewController.tabBarItem = overviewViewTabItem
        
        // goal
        let goalViewController = GoalViewController()
        let goalViewTabItem = UITabBarItem(title: "Goal", image: UIImage(named: "goal.png"), selectedImage: nil)
        goalViewController.tabBarItem = goalViewTabItem
        
        // history
        let historyViewController = HistoryViewController()
        let historyViewTabItem = UITabBarItem(title: "History", image: UIImage(named: "history.png"), selectedImage: nil)
        historyViewController.tabBarItem = historyViewTabItem
        
        // exercises
        let exercisesViewController = ExerciseViewController()
        let exercisesViewTabItem = UITabBarItem(title: "Exercises", image: UIImage(named: "exercises.png"), selectedImage: nil)
        exercisesViewController.tabBarItem = exercisesViewTabItem
        
        // add tab bar items
        self.viewControllers = [overviewViewController,goalViewController, historyViewController, exercisesViewController]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // custom navigation animation
        self.navigationController?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
   }
   
    // custom navigation animation
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            if operation == UINavigationControllerOperation.pop {
                LumoManager.instance.logout()
                return LogoutAnimation()
            }
            return nil
    }
}
