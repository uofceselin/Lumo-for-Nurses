//
//  DetailViewController.swift
//  LBP
//
//  Created by Zheng Liang on 2018/4/4.
//  Copyright © 2018年 LBP. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    let dataInput: ExerciseData = ExerciseData()
    let textView = UILabel()
    var index: Int
    
    init(index: Int) {
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Text view
        textView.textAlignment = .left
        textView.numberOfLines = 0
        textView.text = dataInput.dataOfExercise[index]
        
        // Image
        let image = UIImage(named: dataInput.pictureOfExercise[index])
        let imageView = UIImageView(image:image)

        // ScrollView
        let scrollView = UIScrollView()
        scrollView.addSubview(textView)
        scrollView.addSubview(imageView)
        self.view.addSubview(scrollView)
        
        let margins = self.view.layoutMarginsGuide
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        textView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8).isActive = true
        textView.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        
        imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8).isActive = true
        imageView.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = dataInput.nameOfExercise[index]
        self.navigationController?.delegate = nil
    }
}
