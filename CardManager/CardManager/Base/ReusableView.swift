//
//  ReusableView.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit

protocol IReusableView: AnyObject {
    static var reuseIdentifier: String { get }
}

extension IReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
