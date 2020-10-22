//
//  SendBirdManager.swift
//  MockRunner
//
//  Created by Erik Flores on 7/15/20.
//  Copyright © 2020 PedidosYa. All rights reserved.
//

import SendBirdSDK

class SendBirdManager {
    static let shared = SendBirdManager()

    func registerDeviceToken(with deviceToken: Data) {
        SBDMain.registerDevicePushToken(deviceToken, unique: true, completionHandler: { (status, error) in
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

    func reRegisterDeviceToken() {
        guard let pushToken = SBDMain.getPendingPushToken() else {
            print("no getPendingPushToken")
            return
        }
        SBDMain.registerDevicePushToken(pushToken, unique: true, completionHandler: { (status, error) in
            print("🙃 registraiton error \(error.debugDescription)")
            print("🙃 registraiton status \(status.rawValue)")
        })
    }
    
}
