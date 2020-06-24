//
//  ChatViewController+SBDConnectionDelegate.swift
//  MockRunner
//
//  Created by Erik Flores on 6/13/20.
//  Copyright © 2020 PedidosYa. All rights reserved.
//

import UIKit
import SendBirdSDK
import SendBirdSyncManager

extension ChatViewController: SBDConnectionDelegate {
    func didStartReconnection() {
        print("didStartReconnection")
    }

    func didSucceedReconnection() {
        print("didSucceedReconnection")
        SBSMSyncManager.resumeSynchronize()
    }

    func didFailReconnection() {
        print("didFailReconnection")
    }

    func didCancelReconnection() {
        print("didCancelReconnection")
    }
}
