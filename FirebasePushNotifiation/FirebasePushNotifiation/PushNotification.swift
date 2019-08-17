//
//  AppDelegate.swift
//  FirebasePushNotifiation
//
//  Created by Magic-IOS on 17/08/19.
//  Copyright © 2019 Magic-IOS. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class PushNotification: NSObject {
    
    
    class func setupForPushNotiFication(application: UIApplication,_ isNotiGranted : @escaping (Bool) -> Swift.Void){
        FirebaseApp.configure()
        PushNotification.setUpFirebasePushNotification(application: application, isGranted: { (isAuthenticated) in
           isNotiGranted(isAuthenticated)
        })
    }
    
    class func registerPushNotificationWithToken(deviceToken: Data){
        Messaging.messaging()
            .setAPNSToken(deviceToken, type: MessagingAPNSTokenType.unknown)
    }
    
    
    class func setUpFirebasePushNotification(application: UIApplication,isGranted : @escaping (_ isAuthenticated : Bool)-> Swift.Void) -> Void {
        //Push Notification Register
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            
            // For iOS 10 data message (sent via FCM)
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                    guard error == nil else {
                        isGranted(false)
                        return
                    }
                isGranted(granted)
            }
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(PushNotification.tokenRefreshNotification),
                                               name: .InstanceIDTokenRefresh,
                                               object: nil)
    }
    
    @objc class func tokenRefreshNotification(_ notification: Notification) {
        InstanceID.instanceID().instanceID { (result, error) in
            if error != nil {
                
            } else if let refreshedToken = result {
                
                UserDefaults.standard.setValue(refreshedToken.token, forKey: "DEVICE_TOKEN")
                UserDefaults.standard.synchronize()
            }
        }

        PushNotification.connectToFcm()
    }
    
    
    
    
    class func connectToFcm() {
        InstanceID.instanceID().instanceID { (result, error) in
            if error != nil {
                
            } else if let refreshedToken = result {
                
                UserDefaults.standard.setValue(refreshedToken.token, forKey: "DEVICE_TOKEN")
                UserDefaults.standard.synchronize()
                //AppDelegate.apiCallForDeviceToken()
            }
        }
        
        Messaging.messaging().shouldEstablishDirectChannel = false
        Messaging.messaging().shouldEstablishDirectChannel = true
        if Messaging.messaging().shouldEstablishDirectChannel {
            
        } else {
            
            
        }
        
    }
    
    
    
}

extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
    }
}
