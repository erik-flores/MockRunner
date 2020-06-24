//
//  ChatViewController+SBDUserEventDelegate.swift
//  MockRunner
//
//  Created by Erik Flores on 6/13/20.
//  Copyright © 2020 PedidosYa. All rights reserved.
//

import SendBirdSDK

extension ChatViewController: SBDUserEventDelegate {
    func didUpdateTotalUnreadMessageCount(_ totalCount: Int32, totalCountByCustomType: [String : NSNumber]?) {
        print("didUpdateTotalUnreadMessageCount - totalCount \(totalCount)")
    }
}
