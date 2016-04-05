//
//  VRMCalendarCell.swift
//  VRMCalendar
//
//  Created by Jan Posz on 18.03.2016.
//  Copyright © 2016 Jan Posz. All rights reserved.
//

import UIKit

class VRMCalendarCell: UICollectionViewCell {
    
    var selectionHandler: ((VRMCalendarCell, NSDate) -> ())?

    var inCurrentMonth = true
    var selectionEnabled : Bool?
    
    func makeBlank() {
        inCurrentMonth = false
        self.contentView.hidden = true
        self.alpha = 0
        selectionEnabled = false
    }
}
