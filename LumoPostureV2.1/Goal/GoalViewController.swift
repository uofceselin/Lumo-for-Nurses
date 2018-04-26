// Created by Dante

import UIKit
import CoreImage

class GoalViewController: UIViewController, Updatable {
    private var dataSource: DataSource?
    var rect: UIView!
    var lineRect: UIView!
    var messageView1: UIImageView!
    var messageView2: UIImageView!
    var label: UILabel!
    var goalLabel: UILabel!
    var performLabel: UILabel!
    var lock: UIImageView!
    var show: UIImageView!
    var mySlider: UISlider!
    var scaler = CGFloat(0.6)
    let image = UIImage(named: "smallGuy3.png")!.withRenderingMode(.alwaysTemplate)
    let lockImage = UIImage(named: "lock1.png")!.withRenderingMode(.alwaysTemplate)
    let unlockImage = UIImage(named: "unlock1.png")!.withRenderingMode(.alwaysTemplate)
    let messageImage = UIImage(named: "message.png")!
    var todayPerformance: Float = 0.0 //0-1
    var goal: Int = 0 // 0-100
    var color: UIView = UIView()
    var maskX: CGFloat = 0.0
    var maskY: CGFloat = 0.0
    var imageView: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = LumoManager.instance.getDataSource()
        
        self.view.backgroundColor = .white
        
        scaler = self.view.frame.width*0.7/image.size.width
        
        //let imageView = UIImageView(frame: self.view.frame)
        

        maskX = self.view.frame.width/2 - scaler*image.size.width/2
        maskY = self.view.frame.height/2 - scaler*image.size.height/2
        
        // draw horizontal line
        lineRect =  UIView(frame: CGRect(x: maskX-10, y: maskY+scaler*image.size.height, width: scaler*image.size.width, height: 10)) // correct one
        
        let path = UIBezierPath()
        
        // starting point for the path (bottom left)
        path.move(to: CGPoint(x: 0, y: 0))
        
        
        // segment 1: line
        path.addLine(to: CGPoint(x:scaler*image.size.width, y: 0))
        path.close() // draws the final line to close the path
        
        let shapeLayer = CAShapeLayer()
        
        
        // The Bezier path that we made needs to be converted to
        // a CGPath before it can be used on a layer.
        
        
        // apply other properties related to the path
        shapeLayer.strokeColor = UIColor.white.cgColor
        //        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = 2.0
        shapeLayer.lineDashPattern = [4, 4] // why this doesn't work?
        shapeLayer.position = CGPoint(x: 10, y: 10)
        
        shapeLayer.path = path.cgPath
        
        lineRect.layer.addSublayer(shapeLayer)
        
        imageView.frame = CGRect(x: maskX, y: maskY, width: scaler*image.size.width, height: scaler*image.size.height)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        
        
        imageView.image = image
        
        let height = CGFloat(scaler*image.size.height*CGFloat(todayPerformance))
        let y = maskY + scaler*image.size.height-height
        let newFrame = CGRect(x: maskX, y: y, width: scaler*image.size.width, height: height)
        color.frame = newFrame
        color.backgroundColor = UIColor(hex: 0x599B00, alpha: 1.0)
        
        let backColor = UIView(frame: CGRect(x: maskX, y: maskY, width: scaler*image.size.width, height: scaler*image.size.height))
        backColor.backgroundColor = .gray
        
        let background = UIView(frame: self.view.frame)
        background.backgroundColor = .gray
        
        view.addSubview(backColor)
        
        view.addSubview(color)
        
        self.view.addSubview(lineRect)
        
        view.addSubview(imageView)
        
        lock = UIImageView(image: lockImage)
        lock.frame = CGRect(x: maskX+scaler*image.size.width, y: maskY-85, width: 50, height: 50)
        lock.contentMode = .scaleAspectFit
        lock.tintColor = .black
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.tapDetected))
        lock.isUserInteractionEnabled = true
        lock.addGestureRecognizer(singleTap)
        view.addSubview(lock)
        
        show = UIImageView(image: messageImage)
        show.frame = CGRect(x: self.view.frame.minX+60, y: maskY-80, width: 50, height: 50)
        show.contentMode = .scaleAspectFit
        show.tintColor = .black
        
        let aTap = UITapGestureRecognizer(target: self, action: #selector(self.tapDetected2))
        show.isUserInteractionEnabled = true
        show.addGestureRecognizer(aTap)
        view.addSubview(show)
        
        let label2 = UILabel(frame: CGRect(x: self.view.frame.minX+60, y:maskY-81 , width: 50, height: 50))
        label2.textAlignment = NSTextAlignment.center
        label2.text = "Data"
        view.addSubview(label2)
        
        
        
        
        //add a slider
        mySlider = UISlider(frame:CGRect(x: maskX+scaler*image.size.width/2-20, y: maskY+scaler*image.size.height/2-10, width: scaler*image.size.height+30, height: 20))
        

        mySlider.minimumValue = 0
        mySlider.maximumValue = 100
        mySlider.isContinuous = true
        mySlider.tintColor = UIColor(hex: 0x599B00, alpha: 1.0)
        mySlider.addTarget(self, action: #selector(self.sliderValueDidChange(sender:)), for: .valueChanged)
        mySlider.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        mySlider.setValue(Float(goal), animated: true)
        self.view.addSubview(mySlider)
        mySlider.isHidden = true
        
        let sliderFrame = self.mySlider.frame
        let lineY = sliderFrame.minY + (sliderFrame.size.height-CGFloat(30)) * CGFloat(Float(1)-mySlider.value/Float(100.0))+CGFloat(20) / 2
        lineRect.center.y = lineY
      
        messageView1 = UIImageView(frame: CGRect(x: imageView.center.x, y: y-50, width: 50, height: 50))
        messageView1.contentMode = .scaleAspectFit
        messageView1.tintColor = .black
        messageView1.image = messageImage
        self.view.addSubview(messageView1)
        
        messageView2 = UIImageView(frame: CGRect(x: imageView.center.x+60, y: lineY-20, width: 50, height: 50))
        messageView2.contentMode = .scaleAspectFit
        messageView2.tintColor = .black

        messageView2.center.y = lineY-20
        messageView2.image = messageImage
        self.view.addSubview(messageView2)
        
        performLabel = UILabel(frame: CGRect(x: imageView.center.x, y:y-40 , width: 50, height: 20))
        performLabel.textAlignment = NSTextAlignment.center
        performLabel.text = String(Int(todayPerformance*100))
        view.addSubview(performLabel)
        
        label = UILabel(frame: CGRect(x: imageView.center.x+60, y:lineY-25, width: 50, height: 50))
        label.textAlignment = NSTextAlignment.center
        label.text = String(goal)
        label.center.y=lineY-25
        view.addSubview(label)
        
        messageView1.isHidden = true
        messageView2.isHidden = true
        label.isHidden = true
        performLabel.isHidden = true
    }
    
    @objc func sliderValueDidChange(sender:UISlider!)
    {
        self.label.text = String(sender.value)
        
        let sliderFrame = self.mySlider.frame
        let y = sliderFrame.minY + (sliderFrame.size.height-CGFloat(30)) * CGFloat(Float(1)-sender.value/Float(100.0))+CGFloat(20) / 2

        lineRect.center.y = y
        
        messageView2.center.y = y - 20
        label.center.y = y - 25
        label.text = String(Int(sender.value))
        goal = Int(sender.value)
    }
    
    @objc func tapDetected() {
        if(lock.image == lockImage){
            mySlider.isHidden = false
            lock.image = unlockImage
        }else{
            lock.image = lockImage
            mySlider.isHidden = true
        }
    }
    
    @objc func tapDetected2() {
        if(messageView2.isHidden == true){
            messageView1.isHidden = false
            messageView2.isHidden = false
            label.isHidden = false
            performLabel.isHidden = false
        }else{
            messageView1.isHidden = true
            messageView2.isHidden = true
            label.isHidden = true
            performLabel.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // automatic update based on lumo manager timer
        LumoManager.instance.updateDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "Goal"
        
        // manual update
        update()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update() {
        dataSource?.lockData()
        defer { dataSource?.unlockData() }
        
        // get today's value
        todayPerformance = (dataSource?.getToday())!
        let height = CGFloat(scaler*image.size.height*CGFloat(todayPerformance))
        let y = maskY + scaler*image.size.height-height
        
        // update label
        performLabel.frame = CGRect(x: imageView.center.x, y:y-40 , width: 50, height: 20)
        performLabel.text = String(Int(todayPerformance*100))
        
        // update label message
        messageView1.frame = CGRect(x: imageView.center.x, y: y-50, width: 50, height: 50)
        
        // update mask
        let newFrame = CGRect(x: maskX, y: y, width: scaler*image.size.width, height: height)
        color.frame = newFrame
    }
}
