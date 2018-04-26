//
//  LoginViewController.swift
//  LumoPostureV2.1
//
//  Created by Emil Selin on 4/15/18.
//  Copyright © 2018 com. All rights reserved.
//

import UIKit
import CoreGraphics
import SafariServices

class LoginViewController: UIViewController, SFSafariViewControllerDelegate, UINavigationControllerDelegate, LoginDelegate, Updatable {
    private let activity: UIActivityIndicatorView = UIActivityIndicatorView()
    private let loginButton: UIButton = UIButton(type: .system)
    private var dataSource: DataSource?
    private var circle : UIView = UIView()
    private var imageView: UIImageView = UIImageView(image: UIImage(named: "login.png")!)
    private let titleLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // reference to data source
        dataSource = LumoManager.instance.getDataSource()
        
        // set as login delegate
        LumoManager.instance.loginDelegate = self
        
        // default settings
        self.view.backgroundColor = .white
        self.title = "Logout"
        
        // title label
        titleLabel.text = "Lumo for Nurses"
        titleLabel.font = titleLabel.font.withSize(100)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 1
        
        // login button
        loginButton.setTitle("Lumo Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(.gray, for: .selected)
        loginButton.layer.cornerRadius = loginButton.frame.height/2
        loginButton.clipsToBounds = true
        loginButton.backgroundColor = UIColor(hex: 0xFF4343, alpha: 1.0)
        loginButton.addTarget(self, action: #selector(self.loginButtonAction), for: .touchUpInside)
        
        // loading
        activity.center = self.view.center
        activity.hidesWhenStopped = true
        activity.activityIndicatorViewStyle = .whiteLarge
        
        // circle
        circle.backgroundColor = UIColor(hex: 0xFF4343, alpha: 1.0)
        
        // add views
        self.view.addSubview(imageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(loginButton)
        self.view.addSubview(circle)
        self.view.addSubview(activity)
        
        // set views constraints
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // initial circle state
        circle.frame = CGRect()
        circle.transform = CGAffineTransform.identity
        
        // initial button state
        loginButton.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        // custom navigation animation
        self.navigationController?.delegate = self
        
        // automatic update based on lumo manager timer
        LumoManager.instance.updateDelegate = self
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // rounded login button
        loginButton.layer.cornerRadius = loginButton.frame.height/2
        loginButton.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // custom navigation animation
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.push {
            return LoginAnimation()
        }
        return nil
    }
    
    // login button clicked
    @objc func loginButtonAction() {
        LumoManager.instance.login(viewcontroller: self, safariDelegate: self)
    }

    // login succeeded/failed
    func login(success: Bool) {
        if !success {
            return
        }
        
        // loading circle
        circle.frame = loginButton.frame
        circle.layer.cornerRadius = circle.frame.height/2
        loginButton.isHidden = true
        
        // shrink login button
        UIView.animate(withDuration: 1, animations: {
            self.circle.frame = CGRect(x: self.view.center.x-self.circle.frame.height/2,
                                       y: self.circle.frame.minY,
                                       width: self.circle.frame.height,
                                       height: self.circle.frame.height)
        }, completion: { _ in
            self.activity.startAnimating()
            LumoManager.instance.run()
        })
    }
    
    // initial update done
    func update() {
        self.activity.stopAnimating()
        let scale = UIScreen.main.bounds.height*2 / circle.frame.height
        UIView.animate(withDuration: 2, animations: {
            self.circle.transform = CGAffineTransform(scaleX: scale,y: scale)
        }, completion: { _ in
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(TabBarController(), animated: true)
        })
    }
    
    func setConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        activity.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = self.view.layoutMarginsGuide
        
        imageView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        
        loginButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        loginButton.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        activity.heightAnchor.constraint(equalTo: loginButton.heightAnchor).isActive = true
        activity.widthAnchor.constraint(equalTo: loginButton.heightAnchor).isActive = true
        activity.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor).isActive = true
    }
}
