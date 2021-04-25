//
//  NotificationService.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-04-13.
//

import UIKit

class NotificationService: NSObject {
    
    func configure(context:UNUserNotificationCenterDelegate,application:UIApplication){
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = context
            center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
                if granted {
                    print("Notification Enable Successfully")
                }else{
                   print("Some Error Occure")
                }
            }
        } else {
            let center = UNUserNotificationCenter.current()
            center.delegate = context
            center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
                if granted {
                    print("Notification Enable Successfully")
                }else{
                   print("Some Error Occure")
                }
            }
        }
    }
    
    func registerNotification(title:String,subtitle:String,body:String,time:Double,isRepeat:Bool,orderId:String){
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.subtitle = subtitle
        notificationContent.body = body
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: time, repeats: isRepeat)
        
        let req=UNNotificationRequest(identifier: orderId, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(req) { (error:Error?) in

        if error != nil {
            print(error?.localizedDescription ?? "some unknown error")
        }
            print("Notification Register Success")
        }
    }
        
    func pushNotification(order:Order){
        switch order.status {
            case 1:
                print("Your order is accepted and start to proccess")
                self.registerNotification(title: "Alert", subtitle: "Order", body: "Your order is accepted and start to proccess", time: 1.0, isRepeat: false, orderId: order.orderId)
            case 2:
                print("Your order is ready! Please come and pick your order")
                self.registerNotification(title: "Alert", subtitle: "Order", body: "Your order is ready! Please come and pick your order", time: 1.0, isRepeat: false, orderId: order.orderId)
                
            case 4:
                print("Your order is successfully completed. Thank you")
                self.registerNotification(title: "Alert", subtitle: "Order", body: "Your order is successfully completed. Thank you", time: 1.0, isRepeat: false, orderId: order.orderId)
            case 5:
                print("Sorry! We are unable to accept your order at the moment")
                self.registerNotification(title: "Alert", subtitle: "Order", body: "Sorry! We are unable to accept your order at the moment", time: 1.0, isRepeat: false, orderId: order.orderId)
            default:
                print("Unexpected notification")
        }
    }
}
