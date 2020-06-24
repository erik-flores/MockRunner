//
//  AppDelegate.swift
//  MockRunner
//
//  Created by Erik Flores on 6/7/20.
//  Copyright © 2020 PedidosYa. All rights reserved.
//

import UIKit
import SendBirdSDK
import UserNotifications
import AppSpectorSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initSendBird()
        let acceptAction = UNNotificationAction(identifier: "OK_ACTION", title: "OK", options: UNNotificationActionOptions(rawValue: 0))
        let cancelAction = UNNotificationAction(identifier: "CANCEL_ACTION", title: "Cancel", options: UNNotificationActionOptions(rawValue: 1))
        let notificationActions = [acceptAction, cancelAction]
        let chatResponseCategory = UNNotificationCategory(identifier: "CHAT_MESSAGE", actions: notificationActions, intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
        let notification = UNUserNotificationCenter.current()
        notification.delegate = self
        notification.setNotificationCategories([chatResponseCategory])
        notification.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if let error = error {
                print("💔 Notification Accepted error: \(error)")
            } else {
                print("Notification Accepted")
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SBDMain.registerDevicePushToken(deviceToken, unique: false, completionHandler: { (status, error) in
            guard error == nil else {
                print("💔 registerDevicePushToken failure: \(String(describing: error?.debugDescription))")
                return
            }
            if status == SBDPushTokenRegistrationStatus.pending {
                SBDMain.connect(withUserId: ChatConfig.user, completionHandler: { (user, error) in
                    guard error == nil else {
                        print("💔 Error to connect : \(error.debugDescription)")
                        return
                    }
                    SBDMain.registerDevicePushToken(SBDMain.getPendingPushToken()!, unique: true, completionHandler: { (status, error) in
                        print("🙃 registraiton error \(error.debugDescription)")
                        print("🙃 registraiton status \(status)")
                    })
               })
           }
        })
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("💔 remote error: \(error)")
    }

//    func pushSendBird() {
//        let alertMsg = (userInfo["aps"] as! NSDictionary)["alert"] as! NSString
//                   let payload = userInfo["sendbird"] as! NSDictionary
//
//                  if (application.applicationState == .inactive) {
//                       print("📩 alertMsg inactive \(alertMsg)")
//                       print("📩 payload inactive \(payload)")
//                  } else {
//                       print("📩 alertMsg \(alertMsg)")
//                       print("📩 payload \(payload)")
//                  }
//    }

    func initSendBird() {
        let sendBirdID = "1E181C4C-686F-44EA-8B59-9CE0FF6ECDF0"
        SBDMain.initWithApplicationId(sendBirdID)
    }

    func initAppInspector() {
        let config = AppSpectorConfig(apiKey: "ios_M2I1OWQxOTMtNGJiYy00ZTllLTg4YTEtNDE2YWZmNTU3ZmU2", monitorIDs: [Monitor.http, Monitor.logs, Monitor.notifications])
        AppSpector.run(with: config)
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
           // Get the meeting ID from the original notification.
          let userInfo = response.notification.request.content.userInfo
          let meetingID = userInfo["MEETING_ID"] as! String
          let userID = userInfo["USER_ID"] as! String

        print("meetingID \(meetingID) - userID \(userID)")

          // Perform the task associated with the action.
          switch response.actionIdentifier {
          case "OK_ACTION":
             print("SEND MESSAGE")
             break

          case "CANCEL_ACTION":
             print("CANCEL MESSAGE")
             break

          // Handle other actions…

          default:
             break
          }

          // Always call the completion handler when done.
          completionHandler()
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent response \(notification.request.content)")
        completionHandler([.badge, .alert])
    }
}

