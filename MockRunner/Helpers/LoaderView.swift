//
//  LoaderView.swift
//  RoadrunnerDemo
//
//  Created by Erik Flores on 4/24/20.
//  Copyright © 2020 PedidosYa. All rights reserved.
//

import UIKit

class LoaderView: UIView {

    private var viewIndicator: UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView(style: .gray)
        if #available(iOS 13.0, *) {
            indicator = UIActivityIndicatorView(style: .medium)
            indicator.color = UIColor(named: "ActivityColor")
        }
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .white
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(viewIndicator)
        center(viewIndicator, to: self)
    }

    func add(in view: UIView) {
        view.addSubview(self)
        adjustFrom(view: self, to: view)
    }

    func remove() {
        self.removeFromSuperview()
    }

}

extension LoaderView {
    private func adjustFrom(view: UIView, to nextView: UIView) {
        let top = view.topAnchor.constraint(equalTo: nextView.topAnchor)
        let bottom = view.bottomAnchor.constraint(equalTo: nextView.bottomAnchor)
        let leading = view.leadingAnchor.constraint(equalTo: nextView.leadingAnchor)
        let trailing = view.trailingAnchor.constraint(equalTo: nextView.trailingAnchor)
        NSLayoutConstraint.activate([top, bottom, leading, trailing])
    }

    private func center(_ view: UIView, to nextView: UIView) {
        let centerX = view.centerXAnchor.constraint(equalTo: nextView.centerXAnchor)
        let centerY = view.centerYAnchor.constraint(equalTo: nextView.centerYAnchor)
        NSLayoutConstraint.activate([centerX, centerY])
    }
}
