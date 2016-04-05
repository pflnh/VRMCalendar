//
//  VRMCalendarCell.swift
//  VRMCalendar
//
//  Created by Jan Posz on 18.03.2016.
//  Copyright © 2016 Jan Posz. All rights reserved.
//

import UIKit

class VRMCalendarCell: UICollectionViewCell {
    
    var inCurrentMonth = true
    var selectionEnabled : Bool?
    
    func makeInactiveMonthDay() {
        inCurrentMonth = false
        self.contentView.hidden = true
        self.alpha = 0
        selectionEnabled = false
    }
    
    func onTouchDown() {
        UIView.animateWithDuration(0.1) { () -> Void in
            self.alpha = 0.5
        }
    }
    
    func onTouchUp() {
        UIView.animateWithDuration(0.1) { () -> Void in
            self.alpha = 1.0
        }
    }
    
    func select() {
        self.backgroundColor = UIColor.blueColor()
    }
    
    func deselect() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.onTouchDown()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        self.onTouchUp()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        self.onTouchUp()
    }
}
