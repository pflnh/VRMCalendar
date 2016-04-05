//
//  ViewController.swift
//  VRMCalendar
//
//  Created by Jan Posz on 05.04.2016.
//  Copyright © 2016 Vorm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var calendar : VRMCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar = VRMCalendarView(frame: CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width), currentDate: NSDate())
        calendar.allowsRangeSelection = true
        calendar.registerCellNib(UINib(nibName: "FOOCell", bundle: nil))
        calendar.delegate = self
        calendar.dataSource = self
        self.view.addSubview(calendar.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController : VRMCalendarViewDelegate {
    
    func VRMCalendar(calendar calendarView: VRMCalendarView, didSelectCell cell: VRMCalendarCell, withDate date: NSDate) {
        print("Selected: \(date)")
    }
}

extension ViewController : VRMCalendarViewDataSource {
    
    func VRMCalendar(calendar calendarView: VRMCalendarView, customizedCell cell: VRMCalendarCell, forItemWithDate date: NSDate) -> VRMCalendarCell {
        let fooCell = cell as! FOOCell
        fooCell.loadWithDate(date)
        return cell
    }
    
    func VRMCalendar(calendar calendarView: VRMCalendarView, headerForMonth month: Int, inYear year: Int) -> VRMCalendarHeader? {
        let header = FOOHeader(frame: CGRectMake(0, 0, calendarView.view.frame.size.width, 50.0))
        header.dateLabel.text = "\(month)" + " " + "\(year)"
        return header
    }
    
    func VRMCalendar(calendar calendarView: VRMCalendarView, headerHeightForMonth month: Int, inYear year: Int) -> CGFloat? {
        return 50.0
    }
    
    func VRMCalendar(calendar calendarView: VRMCalendarView, sizeForCellWithDate date: NSDate) -> CGSize {
        return CGSizeMake(40.0, 40.0)
    }
}

