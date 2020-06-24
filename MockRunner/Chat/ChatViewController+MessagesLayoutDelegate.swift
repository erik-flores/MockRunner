//
//  ChatViewController+MessagesLayoutDelegate.swift
//  RoadrunnerDemo
//
//  Created by Erik Flores on 6/5/20.
//  Copyright © 2020 PedidosYa. All rights reserved.
//

import SendBirdSDK
import MessageKit

extension ChatViewController: MessagesLayoutDelegate {
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
}
