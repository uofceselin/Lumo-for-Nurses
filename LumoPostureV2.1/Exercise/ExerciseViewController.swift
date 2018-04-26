//
//  ExerciseViewController.swift
//  LBP
//
//  Created by Zheng Liang on 2018/4/4.
//  Copyright © 2018年 LBP. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // data for the class
    let dataInput: ExerciseData = ExerciseData()
    let reuseCellIdentifier = "Cell"
    let exerciseTable = UITableView()//frame: self.view.frame, style: .plain)
    
    // =============================
    // Function for the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataInput.nameOfExercise.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier, for: indexPath) as UITableViewCell
        cell.textLabel?.text = dataInput.nameOfExercise[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(DetailViewController(index: indexPath.row), animated: false)
    }

    // ============================
    // Function for the ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // Table View
        // configure the x, y, width, height later.
        // Style: .plain or .grouped
        exerciseTable.register(UITableViewCell.self, forCellReuseIdentifier: reuseCellIdentifier)
        exerciseTable.delegate = self
        exerciseTable.dataSource = self
        exerciseTable.separatorStyle = .singleLine
        exerciseTable.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
        self.view.addSubview(exerciseTable)
        
        //exerciseTable.allowsSelection = true
        setConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "Exercises"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setConstraints() {
        exerciseTable.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = self.view.layoutMarginsGuide
        
        exerciseTable.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        exerciseTable.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        exerciseTable.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        exerciseTable.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
}
