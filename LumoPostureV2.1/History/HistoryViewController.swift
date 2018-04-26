//
//  ViewController.swift
//  BarChart
//
//  Created by Nguyen Vu Nhat Minh on 19/8/17.
//  Copyright © 2017 Nguyen Vu Nhat Minh. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, Updatable {
    var dataChart: BeautifulBarChart!
    var isCurved: Bool = true
    let formatter: DateFormatter = DateFormatter()
    private var dataSource: DataSource?
    private let low: UIColor = UIColor(hex: 0xE81123, alpha: 1.0)
    private let medium: UIColor = UIColor(hex: 0xFCE100, alpha: 1.0)
    private let high: UIColor = UIColor(hex: 0x6BB700, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = LumoManager.instance.getDataSource()
        
        formatter.dateFormat = "d MMM"
        isCurved = true
        self.view.backgroundColor = UIColor.white

        let topOffset = self.navigationController!.navigationBar.frame.height + self.navigationController!.navigationBar.frame.minY
        let bottomOffset = self.tabBarController!.tabBar.frame.height
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - bottomOffset - topOffset)
        dataChart = BeautifulBarChart(frame: frame)
        self.view.addSubview(dataChart)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "History"
        
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
        
        guard let count = dataSource?.posture.count else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        var result: [BarEntry] = []
        for i in 0..<count {
            let posture = dataSource!.posture[i]
            if posture == 0 {
                continue
            }
            let date = dataSource!.dateFrom(index: i)
            let color = UIColor.lerp(colorA: low, colorB: medium, colorC: high, t: CGFloat(posture))
            result.append(BarEntry(color: color, height: posture, textValue: "\(Int(posture*100))%", title: formatter.string(from: date)))
        }
        dataChart.dataEntries = result
    }
}

