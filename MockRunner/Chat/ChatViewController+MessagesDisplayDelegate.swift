//
//  ChatViewController+MessagesDisplayDelegate.swift
//  RoadrunnerDemo
//
//  Created by Erik Flores on 6/5/20.
//  Copyright © 2020 PedidosYa. All rights reserved.
//

import SendBirdSDK
import MessageKit

extension ChatViewController: MessagesDisplayDelegate {
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(tail, .pointedEdge)
    }
}
