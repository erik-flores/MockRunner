//
//  Alert.swift
//  RoadrunnerDemo
//
//  Created by Erik Flores on 6/6/20.
//  Copyright © 2020 PedidosYa. All rights reserved.
//

import UIKit

struct Alert {
    private static let alertController = UIAlertController(title: "RoudRunner", message: nil, preferredStyle: .alert)

    static func message(with message: String, in viewController: UIViewController, handler: ((UIAlertAction) -> Void)? = nil) {
        alertController.message = message
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(confirmAction)
        viewController.present(alertController, animated: true, completion: nil)
    }

    static func error(with error: NSError, in viewController: UIViewController, handler: @escaping (UIAlertAction) -> Void) {
        let code = error.code
        let underlyingError = error.userInfo["NSUnderlyingError"] as! NSError
        let messageError = underlyingError.localizedDescription
        alertController.title = "Error \(code)"
        alertController.message = messageError
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default, handler: handler)
        alertController.addAction(confirmAction)
        alertController.addAction(tryAgainAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
