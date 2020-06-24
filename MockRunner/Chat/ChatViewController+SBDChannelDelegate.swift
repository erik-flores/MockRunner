//
//  ChatViewController+SBDChannelDelegate.swift
//  RoadrunnerDemo
//
//  Created by Erik Flores on 6/5/20.
//  Copyright © 2020 PedidosYa. All rights reserved.
//

import SendBirdSDK
import MessageKit

extension ChatViewController: SBDChannelDelegate {
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        let messageId = String(message.messageId)
        if let messageText = message as? SBDUserMessage {
            let remoteSender = ChatSenderType(senderId: messageId, displayName: "Remote User")
            let remoteMessage = ChatMessage(sender: remoteSender, messageId: UUID().uuidString, sentDate: Date(), kind: .text(messageText.message ?? ""))
            insertMessage(remoteMessage)
        }
    }

    

    func channelDidUpdateTypingStatus(_ sender: SBDGroupChannel) {
        if sender.channelUrl == self.groupChannel?.channelUrl {
            if let members = sender.getTypingMembers(), members.isEmpty {
                setTypingIndicatorViewHidden(true)
            } else {
                setTypingIndicatorViewHidden(false)
            }
        }
    }

    func channelDidUpdateReadReceipt(_ sender: SBDGroupChannel) {
        print("read")
    }
}
