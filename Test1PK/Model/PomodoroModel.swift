//
//  PomodoroModel.swift
//  Test1PK
//
//  Created by Luigi Cirillo on 13/12/23.
//

import Foundation
import SwiftUI

@Observable
class PomodoroModel : NSObject {
    var progress : CGFloat = 1
    var timerStringValue : String = "00:00"
    var isStarted : Bool = false
    var addNewTimer : Bool = false
    
    var hour : Int = 0
    var minutes : Int = 0
    var seconds : Int = 0
    
    var totalSeconds : Int = 0
    var staticTotalSeconds: Int = 0
    
    var isFinished = false
    
    
    func startTimer () {
        withAnimation(.easeInOut(duration: 0.25)) {
            isStarted = true
        }
        timerStringValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes):" : "0\(minutes):")\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        totalSeconds = (hour*3600)+(minutes*60)+seconds
        staticTotalSeconds = totalSeconds
        addNewTimer = false
        addNotification()
    }
    
    func stopTimer() {
        withAnimation {
            isStarted = false
        }
    }
    
    func resetTimer() {
        withAnimation {
            isStarted = false
            hour = 0
            minutes = 0
            seconds = 0
            progress = 1
        }
        totalSeconds = 0
        staticTotalSeconds = 0
        timerStringValue = "00:00"
    }
    
    func updateTimer () {
        totalSeconds -= 1
        progress = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        progress = (progress<0 ? 0 : progress )
        hour = totalSeconds/3600
        minutes = (totalSeconds/60)%60
        seconds = totalSeconds % 60
        timerStringValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes):" : "0\(minutes):")\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        if (hour + minutes + seconds) == 0 {
            isStarted = false
            print("Finished")
            isFinished = true
        }

    }
    
    func addNotification(){
        let content = UNMutableNotificationContent()
        content.title = "NoteCraft Timer"
        content.body = "Time is up!!!"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger:  UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalSeconds), repeats: false))
        
        UNUserNotificationCenter.current().add(request)
    }
    
    override init() {
        super.init()
        self.authorizeNotification()
    }
}

extension PomodoroModel : UNUserNotificationCenterDelegate {
    func authorizeNotification () {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { _, _ in
        }
        
        UNUserNotificationCenter.current().delegate =  self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
    
}
