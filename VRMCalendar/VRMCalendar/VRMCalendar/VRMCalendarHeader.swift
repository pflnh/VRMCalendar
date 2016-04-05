//
//  VRMCalendarHeader.swift
//  VRMCalendar
//
//  Created by Jan Posz on 18.03.2016.
//  Copyright © 2016 Jan Posz. All rights reserved.
//

import UIKit

class VRMCalendarHeader: UIView {

    class func defaultHeaderWithDate(date : NSDate, innerFrame frame : CGRect, textColor color : UIColor, backgroundColor bgColor : UIColor) -> VRMCalendarHeader {
        
        let header = VRMCalendarHeader()
        let title = UILabel(frame: frame)
        title.backgroundColor = bgColor
        title.textColor = color
        title.text = date.stringValue()
        title.font = UIFont.boldSystemFontOfSize(20)
        title.textAlignment = .Center
        header.addSubview(title)
        return header
    }
}
