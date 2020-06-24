//
//  ChatMessage.swift
//  RoadrunnerDemo
//
//  Created by Erik Flores on 5/28/20.
//  Copyright © 2020 PedidosYa. All rights reserved.
//

import MessageKit

struct ChatSenderType: SenderType {
    var senderId: String
    var displayName: String
}

struct ChatMessage: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
