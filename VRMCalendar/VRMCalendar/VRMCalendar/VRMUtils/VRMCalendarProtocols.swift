//
//  VRMCalendarProtocols.swift
//  VRMCalendar
//
//  Created by Jan Posz on 18.03.2016.
//  Copyright © 2016 Jan Posz. All rights reserved.
//

import UIKit

//MARK: calendar view

protocol VRMCalendarViewDataSource {
    
    func VRMCalendar(calendar calendarView : VRMCalendarView, customizedCell cell : VRMCalendarCell, forItemWithDate date : NSDate) -> VRMCalendarCell
    func VRMCalendar(calendar calendarView : VRMCalendarView, headerForMonth month : Int, inYear year : Int) -> VRMCalendarHeader?
    func VRMCalendar(calendar calendarView : VRMCalendarView, headerHeightForMonth month : Int, inYear year : Int) -> CGFloat?
    func VRMCalendar(calendar calendarView : VRMCalendarView, sizeForCellWithDate date : NSDate) -> CGSize
}

protocol VRMCalendarViewDelegate {
    
    func VRMCalendar(calendar calendarView : VRMCalendarView, didSelectCell cell : VRMCalendarCell, withDate date : NSDate)
}

//MARK: calendar page

protocol VRMCalendarPageDataSource {
    
    func VRMPage(customizeCell cell : VRMCalendarCell, withDate date : NSDate) -> VRMCalendarCell
    func VRMPage(headerForMonth month : Int, inYear year : Int) -> VRMCalendarHeader?
    func VRMPage(headerHeightFor month: Int, inYear year : Int) -> CGFloat?
    func VRMPage(sizeForCellWithDate date : NSDate) -> CGSize
}

protocol VRMCalendarPageDelegate {
    
    func VRMPage(didSelectCell cell : VRMCalendarCell, withDate date : NSDate)
}
