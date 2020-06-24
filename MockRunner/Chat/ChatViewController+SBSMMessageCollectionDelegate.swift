//
//  ChatViewController+SBSMMessageCollectionDelegate.swift
//  MockRunner
//
//  Created by Erik Flores on 6/16/20.
//  Copyright © 2020 PedidosYa. All rights reserved.
//

import SendBirdSDK
import SendBirdSyncManager

extension ChatViewController: SBSMMessageCollectionDelegate {
    func collection(_ collection: SBSMMessageCollection, didReceive action: SBSMMessageEventAction, succeededMessages: [SBDBaseMessage]) {
        switch (action) {
           case .insert:
               print("insert collection \(succeededMessages)")
           case .update:
               print("update collection \(succeededMessages)")
           case .remove:
               print("remove collection \(succeededMessages)")
           case .clear:
               print("clear collection \(succeededMessages)")
           case .none:
               print("none collection \(succeededMessages)")
       @unknown default:
           fatalError()
       }
    }

}
