//
//  UIViewController+Ext.swift
//  ExampleFormController
//
//  Created by Чаусов Николай on 26.09.2022.
//

import UIKit

extension UIViewController {
    
    static func initiate() -> Self {
        return Self(nibName: String(describing: self), bundle: nil)
    }
}
