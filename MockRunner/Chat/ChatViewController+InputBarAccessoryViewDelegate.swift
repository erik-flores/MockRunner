//
//  ChatViewController+InputBarAccessoryViewDelegate.swift
//  RoadrunnerDemo
//
//  Created by Erik Flores on 6/5/20.
//  Copyright © 2020 PedidosYa. All rights reserved.
//

import SendBirdSDK
import MessageKit
import InputBarAccessoryView

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending ..."

        groupChannel?.sendUserMessage(text, completionHandler: { (userMessage, error) in
            guard error == nil else {
                print("Send User Message error : \(error.debugDescription)")
                return
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.messageInputBar.sendButton.stopAnimating()
                self.messageInputBar.inputTextView.placeholder = "Aqui se mande un mensaje"
                self.messageInputBar.inputTextView.text = ""
                let chatSender = ChatSenderType(senderId: "RoadrunnerUserDemo", displayName: "")
                let userMessage = ChatMessage(sender: chatSender, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text))
                self.insertMessage(userMessage)
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
        collection?.appendMessage(SBDBaseMessage(dictionary: ["data" : text])!)
    }

    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        if text.isEmpty {
            groupChannel?.endTyping()
        } else {
            groupChannel?.startTyping()
        }
    }
}
