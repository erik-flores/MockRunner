//
//  ChatViewController+MessagesDataSource.swift
//  RoadrunnerDemo
//
//  Created by Erik Flores on 6/5/20.
//  Copyright © 2020 PedidosYa. All rights reserved.
//

import SendBirdSDK
import MessageKit

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return ChatSenderType(senderId: ChatConfig.user, displayName: "")
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return chatMessages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return chatMessages.count
    }

    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let sentDate = chatMessages[indexPath.row].sentDate
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let stringDate = formatter.string(from: sentDate)
        let attr: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
        let stringWithAttr = NSAttributedString(string: stringDate, attributes: attr)
        return stringWithAttr
    }
}
