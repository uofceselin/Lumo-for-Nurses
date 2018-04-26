//
//  OverviewViewController.swift
//  LumoPostureV2.1
//
//  Created by Emil Selin on 4/17/18.
//  Copyright © 2018 com. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController, Updatable {
    private var badCircleView: CircleView!
    private var goodCircleView: CircleView!
    private let badTimeLabel = UILabel()
    private let goodTimeLabel = UILabel()
    private let percentLabel = UILabel()
    private let totalTimeLabel = UILabel()
    private var dataSource: DataSource?
    
    private var timeImageView: UIImageView = UIImageView(image: UIImage(named: "time.png")!)
    private var badImageView: UIImageView = UIImageView(image: UIImage(named: "bad.png")!)
    private var goodImageView: UIImageView = UIImageView(image: UIImage(named: "good.png")!)
    
    private let lineWidth: CGFloat = 20.0
    private let badColor: UIColor = UIColor(hex: 0xC50F1F, alpha: 1.0)
    private let goodColor: UIColor = UIColor(hex: 0x599B00, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        dataSource = LumoManager.instance.getDataSource()
        
        // circles positions
        let xoffset: CGFloat = 16
        let diameter: CGFloat = UIScreen.main.bounds.width - xoffset*2
        let yoffset: CGFloat = (UIScreen.main.bounds.height - UIScreen.main.bounds.width)/2 - 64
        
        // manual layout needed since animations gets cancelled by auto layout (labels)
        badCircleView = CircleView(frame: CGRect(x: xoffset,
                                                 y: yoffset,
                                                 width: diameter,
                                                 height: diameter),
                                   color: badColor,
                                   width: lineWidth)
        
        goodCircleView = CircleView(frame: CGRect(x: xoffset + lineWidth,
                                                 y: yoffset + lineWidth,
                                                 width: diameter - lineWidth*2,
                                                 height: diameter - lineWidth*2),
                                   color: goodColor,
                                   width: lineWidth)
        
        percentLabel.font = percentLabel.font.withSize(50)

        timeImageView.contentMode = .scaleAspectFit
        badImageView.contentMode = .scaleAspectFit
        goodImageView.contentMode = .scaleAspectFit
        
        self.view.addSubview(badCircleView)
        self.view.addSubview(goodCircleView)
        self.view.addSubview(badTimeLabel)
        self.view.addSubview(goodTimeLabel)
        self.view.addSubview(percentLabel)
        self.view.addSubview(totalTimeLabel)
        self.view.addSubview(timeImageView)
        self.view.addSubview(badImageView)
        self.view.addSubview(goodImageView)
        setConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "Overview"
        
        // reset animation
        badCircleView.currentValue = 0
        goodCircleView.currentValue = 0
        
        // manual update
        update()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // automatic update based on lumo manager timer
        LumoManager.instance.updateDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update() {
        dataSource?.lockData()
        defer { dataSource?.unlockData() }
        
        // get values
        let good = dataSource!.postureTime/dataSource!.totalTime
        let bad = 1.0 - good
        let totalTime = dataSource!.totalTime
        let goodTime = dataSource!.postureTime
        let badTime = dataSource!.totalTime-dataSource!.postureTime

        // labels
        percentLabel.text = "\(Int(good*100))%"
        totalTimeLabel.text = secondsToString(seconds: totalTime)
        goodTimeLabel.text = secondsToString(seconds: goodTime)
        badTimeLabel.text = secondsToString(seconds: badTime)
        
        // circles
        badCircleView.animateCircle(newValue: CGFloat(bad), duration: 2.0)
        goodCircleView.animateCircle(newValue: CGFloat(good), duration: 2.0)
    }
    
    func secondsToString(seconds: Float) -> String {
        let secondsInt = Int(seconds)
        return "\(secondsInt/3600)h \((secondsInt % 3600) / 60)min"
    }
    
    func setConstraints() {
        totalTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        badTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        goodTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeImageView.translatesAutoresizingMaskIntoConstraints = false
        badImageView.translatesAutoresizingMaskIntoConstraints = false
        goodImageView.translatesAutoresizingMaskIntoConstraints = false
        
        totalTimeLabel.centerXAnchor.constraint(equalTo: badCircleView.centerXAnchor).isActive = true
        totalTimeLabel.bottomAnchor.constraint(equalTo: badCircleView.topAnchor, constant: -8).isActive = true
        
        timeImageView.centerYAnchor.constraint(equalTo: totalTimeLabel.centerYAnchor).isActive = true
        timeImageView.trailingAnchor.constraint(equalTo: totalTimeLabel.leadingAnchor, constant: -8).isActive = true
        timeImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        percentLabel.centerXAnchor.constraint(equalTo: goodCircleView.centerXAnchor).isActive = true
        percentLabel.centerYAnchor.constraint(equalTo: goodCircleView.centerYAnchor).isActive = true
        
        badImageView.topAnchor.constraint(equalTo: badCircleView.bottomAnchor, constant: 8).isActive = true
        badImageView.leadingAnchor.constraint(equalTo: badCircleView.leadingAnchor).isActive = true
        badImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        badImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        badTimeLabel.centerYAnchor.constraint(equalTo: badImageView.centerYAnchor).isActive = true
        badTimeLabel.leadingAnchor.constraint(equalTo: badImageView.trailingAnchor, constant: 4).isActive = true
        
        goodImageView.topAnchor.constraint(equalTo: badCircleView.bottomAnchor, constant: 8).isActive = true
        goodImageView.trailingAnchor.constraint(equalTo: badCircleView.trailingAnchor).isActive = true
        goodImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        goodImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        goodTimeLabel.centerYAnchor.constraint(equalTo: goodImageView.centerYAnchor).isActive = true
        goodTimeLabel.trailingAnchor.constraint(equalTo: goodImageView.leadingAnchor, constant: -4).isActive = true
    }
}
