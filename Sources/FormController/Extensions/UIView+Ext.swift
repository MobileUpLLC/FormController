//
//  File.swift
//  
//
//  Created by Чаусов Николай on 26.09.2022.
//

import UIKit

public extension UIView {
    
    func setConstraint(type: NSLayoutConstraint.Attribute, value: CGFloat) {
        if let constraint = findConstraint(type: type) {
            
            constraint.constant = value
        }
    }
    
    func findConstraint(type: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        if let constraint = findConstraintInSuperview(type: type) {
            
            return constraint
        }
        
        return constraints.first(where: { $0.firstAttribute == type &&  $0.secondAttribute != type })
    }
    
    func findConstraintInSuperview(type: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        if let superview = superview {
            
            for constraint in superview.constraints {
                
                let isFirstItemIsSelf = (constraint.firstItem as? UIView) == self
                let isSecondItemIsSelf = (constraint.secondItem as? UIView) == self
                let isConstraintAssociatedWithSelf = (isFirstItemIsSelf || isSecondItemIsSelf)
                
                if constraint.firstAttribute == type && isConstraintAssociatedWithSelf {
                    
                    return constraint
                }
            }
        }
        
        return nil
    }
}

