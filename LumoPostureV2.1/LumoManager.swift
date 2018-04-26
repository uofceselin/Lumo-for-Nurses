//
//  LumoManager.swift
//  LumoPostureV2.1
//
//  Created by Emil Selin on 4/15/18.
//  Copyright © 2018 com. All rights reserved.
//

import Foundation
import OAuthSwift
import SafariServices

protocol Updatable: class {
    func update()
}

protocol LoginDelegate: class {
    func login(success: Bool)
}

class LumoManager {
    // singleton
    static let instance = LumoManager()
    
    // oauth2
    private var oauthswift: OAuth2Swift
    private var handler: OAuthSwiftRequestHandle?
    
    // data source
    private var dataSource: DataSource
    
    // delegates
    weak var loginDelegate: LoginDelegate?
    weak var updateDelegate: Updatable?
    
    // 5 min timer
    private var timer: Timer?
    private let interval: TimeInterval = 300
    
    // thread
    private let waitLock = DispatchSemaphore(value: 1)
    private var thread: DispatchWorkItem?
    private var running = false
    
    // lumo server properties
    private let consumerKey: String = "IEtPsjuQ7har2YYnf2zoLa9vSiumnwLmO7n9oG2r"
    private let consumerSecret: String = "zPaqfpNkBW3WV0gNHz6QGOW1bC0ejHq3OcF4TcHWXJN6JumiSf"
    private let authorizeUrl: String = "https://api.lumobodytech.com/oauth2/authorize"
    private let accessTokenUrl: String = "https://api.lumobodytech.com/oauth2/token/"
    private let responseType: String = "code"
    private let postureUrl: String = "https://api.lumobodytech.com/v1/users/me/activities/posture/"
    private let callbackURL: String = "com.LumoPosture://oauth-callback"
    
    // lumo data properties
    private let dataTime = "localTime"
    private let dataType = "dataType"
    private let dataValue = "value"
    private let goodType = "TIME_IN_GOOD_POSTURE"
    private let badType = "TIME_IN_BAD_POSTURE"
    
    init() {
        // setup oauth2
        oauthswift = OAuth2Swift(consumerKey: consumerKey, consumerSecret: consumerSecret, authorizeUrl: authorizeUrl, accessTokenUrl: accessTokenUrl, responseType: responseType)
        oauthswift.encodeCallbackURL = true
        oauthswift.encodeCallbackURLQuery = false
        oauthswift.allowMissingStateCheck = true
        
        // data source
        dataSource = DataSource()
    }
    
    // oauth2 login with lumo server
    func login(viewcontroller: UIViewController, safariDelegate: SFSafariViewControllerDelegate) {
        let handler = SafariURLHandler(viewController: viewcontroller, oauthSwift: oauthswift)
        handler.delegate = safariDelegate
        handler.animated = false
        oauthswift.authorizeURLHandler = handler
        waitLock.wait()
        oauthswift.authorize(withCallbackURL: callbackURL, scope: "", state: "",
                             success: { credential, response, parameters in
                                self.loginDelegate?.login(success: true)
                             },
                             failure: { error in
                                self.loginDelegate?.login(success: false)
                             }
        )
        waitLock.signal()
    }
    
    // logout from current session
    func logout() {
        // cancel update
        cancel()
        
        // new oauth2
        oauthswift = OAuth2Swift(consumerKey: consumerKey, consumerSecret: consumerSecret, authorizeUrl: authorizeUrl, accessTokenUrl: accessTokenUrl, responseType: responseType)
        oauthswift.encodeCallbackURL = true
        oauthswift.encodeCallbackURLQuery = false
        oauthswift.allowMissingStateCheck = true
        
        // reset data source
        dataSource.reset()
    }
    
    // gets data from lumo's between start time and end time
    func get(start: Date, end: Date) -> [[String:Any]]? {
        // raw data
        var rawData: [[String:Any]]?
        
        // lock
        waitLock.wait()
        
        // server times
        let startTime = Int(start.toServer().timeIntervalSince1970)
        let endTime = Int(end.toServer().timeIntervalSince1970)
        
        // request
        handler = oauthswift.client.get(postureUrl, parameters: ["start_time": startTime, "end_time": endTime, "data_source": "LUMO_LIFT", "granularity": "day"],
                                        success: { response in
                                            do {
                                                // received data
                                                if let json = try response.jsonObject() as? [String: Any] {
                                                    rawData = (json["data"] as? [[String: Any]])!
                                                }
                                            } catch {
                                                // do nothing
                                            }
                                            // unlock
                                            self.waitLock.signal()
                                        },
                                        failure: { error in
                                            // unlock
                                            self.waitLock.signal()
                                        }
        )

        // wait for unlock
        waitLock.wait()
        
        // unlock
        waitLock.signal()
        return rawData
    }
    
    // get data from lumo server every 5min in a background thread
    func run() {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            if self.thread != nil {
                return
            }
            self.thread = DispatchWorkItem { [weak self] in
                self?.update()
                self?.thread = nil
            }
            DispatchQueue.global(qos: .background).async(execute: self.thread!)
        }
        timer?.fire()
    }
    
    // process data from lumo
    func update() {
        // current time is end time
        let endTime = Date()
        
        // last data source update is start time
        let startTime = self.dataSource.lastUpdated
        
        // get data from lumo
        guard let rawData = self.get(start: startTime, end: endTime) else {
            return
        }
        
        // no new data
        if rawData.count == 0 {
            self.dataSource.lockData()
            // cancelled
            if (self.thread?.isCancelled)! {
                return
            }
            self.dataSource.lastUpdated = endTime
            self.dataSource.unlockData()
            return
        }
        
        // prepare raw data for data source update
        var posture: [Date:(good: Float, bad: Float)] = [Date:(good: Float, bad: Float)]()
        
        for day in rawData {
            // server time
            guard let serverTime = day[self.dataTime] as? Double else {
                continue
            }
            
            // posture type
            guard let type = day[self.dataType] as? String else {
                continue
            }
            
            // posture value
            guard let value = day[self.dataValue] as? Float else {
                continue
            }
            
            // local time
            let localTime = Date(timeIntervalSince1970: serverTime).toLocal()
            
            // add date
            if posture[localTime] == nil {
                posture[localTime] = (0,0)
            }
            
            // add value
            if type == self.goodType {
                posture[localTime]?.good = value
            } else if type == self.badType {
                posture[localTime]?.bad = value
            }
            
            // cancelled
            if (self.thread?.isCancelled)! {
                return
            }
        }
        
        // update data source
        self.dataSource.lockData()
        // cancelled
        if (self.thread?.isCancelled)! {
            return
        }
        self.dataSource.addDates(start: posture.keys.min()!, end: endTime)
        for day in posture {
            self.dataSource.addValue(date: day.key, good: day.value.good, bad: day.value.bad)
        }
        self.dataSource.lastUpdated = endTime
        self.dataSource.unlockData()
        
        // call update delegate
        DispatchQueue.main.async {
            self.updateDelegate?.update()
        }
    }
    
    // stop timer and thread
    func cancel() {
        // stop timer
        timer?.invalidate()
        
        // cancel any current request
        handler?.cancel()
        
        // cancel thread if it's not working with data source
        dataSource.lockData()
        thread?.cancel()
        dataSource.unlockData()
    }
    
    func getDataSource() -> DataSource {
        return dataSource
    }
}
