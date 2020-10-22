//
//  ChatViewController.swift
//  RoadrunnerDemo
//
//  Created by Erik Flores on 4/24/20.
//  Copyright © 2020 PedidosYa. All rights reserved.
//

import MessageKit
import SendBirdSDK
import SendBirdSyncManager
import InputBarAccessoryView

class ChatViewController: MessagesViewController {

    var loaderView: LoaderView = LoaderView()
    var groupChannel: SBDGroupChannel?
    lazy var chatMessages: [ChatMessage] = []
    var collection: SBSMMessageCollection?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigator()
        loaderView.add(in: view)
        delegations()
        scrollsToBottomOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        SBDMain.add(self as SBDUserEventDelegate, identifier: "SBDUserEventDelegate_\(self.description)")
        SBDMain.add(self as SBDChannelDelegate, identifier: "SBDChannelDelegate_\(self.description)")
        SBDMain.add(self as SBDConnectionDelegate, identifier: "SBDConnectionDelegate_\(self.description)")
        connectToChat(with: ChatConfig.user) {
            self.finishLoad()
            SendBirdManager.shared.reRegisterDeviceToken()
        }
    }

    func delegations() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
}

// MARK: - Helpers

extension ChatViewController {
    private func configureNavigator() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController.navigationBar.sizeToFit()
    }


    func connectToChat(with userId: String, completionHandler: (() -> Void)? = nil) {
        SBDMain.connect(withUserId: userId, completionHandler: { (user, error) in
            guard error == nil else {
                Alert().error(with: error!, in: self) { _ in
                    self.connectToChat(with: userId)
                }
                return
            }
            SBDGroupChannel.getWithUrl(ChatConfig.url) { (groupChannel, error) in
                guard error == nil else {
                    Alert().error(with: error!, in: self) { _ in
                        self.connectToChat(with: userId)
                    }
                    return
                }
                self.groupChannel = groupChannel
//                let filter = SBSMMessageFilter(messageType: .all, customType: nil, senderUserIds: nil)
//                self.collection = SBSMMessageCollection(channel: groupChannel!, filter: filter, viewpointTimestamp: LLONG_MAX)
//                self.collection?.delegate = self
                self.loadMessage()
                if let completionHandler = completionHandler {
                    completionHandler()
                }
            }
        })
    }

    func finishLoad() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.messagesCollectionView.scrollToBottom()
            let animation = UIViewPropertyAnimator(duration: 2, dampingRatio: 0.5) {
                self.loaderView.alpha = 0
            }
            animation.addCompletion { position in
                self.loaderView.remove()
            }
            animation.startAnimation()
        }
    }

    func loadMessage() {
        let previousMessageQuery = groupChannel?.createPreviousMessageListQuery()
        previousMessageQuery?.includeMetaArray = true
        previousMessageQuery?.includeReactions = true

        previousMessageQuery?.loadPreviousMessages(withLimit: 20, reverse: false, completionHandler: { (messages, error) in
            guard error == nil else {
                return
            }
            guard let messages = messages else {
                return
            }
            for message in messages {
                guard let userMessage = message as? SBDUserMessage else {
                    continue
                }
                guard let userSender = userMessage.sender else {
                    continue
                }
                let chatSender = ChatSenderType(senderId: userSender.userId, displayName: userSender.nickname ?? "")
                let chatMessage = ChatMessage(sender: chatSender,
                                              messageId: "\(message.messageId)",
                                              sentDate: Date(),
                                              kind: .text(userMessage.message ?? ""))
                self.chatMessages.append(chatMessage)
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
                }
            }
        })
    }

    func setTypingIndicatorViewHidden(_ isHidden: Bool, performUpdates updates: (() -> Void)? = nil) {
           setTypingIndicatorViewHidden(isHidden, animated: true, whilePerforming: updates) { [weak self] success in
               if success, self?.isLastSectionVisible() == true {
                   self?.messagesCollectionView.scrollToBottom(animated: true)
               }
           }
    }

    func isLastSectionVisible() -> Bool {
        guard !chatMessages.isEmpty else { return false }
        let lastIndexPath = IndexPath(item: 0, section: chatMessages.count - 1)
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }

    func insertMessage(_ message: ChatMessage) {
        chatMessages.append(message)
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([chatMessages.count - 1])
                if chatMessages.count >= 2 {
                    messagesCollectionView.reloadSections([chatMessages.count - 2])
                }
        }, completion: { _ in
            print("batch completion")
            //self.markAllRead()
        })
    }

    private func markAllRead() {
        SBDMain.connect(withUserId: ChatConfig.user) { (user, error) in
            guard error == nil else {
                print("connect user for mark read - error \(error.debugDescription)")
                return
            }
            SBDMain.markAsReadAll { (error) in
                guard error == nil else {
                    print("mark read- error \(error.debugDescription)")
                    return
                }
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
        }
    }
}



