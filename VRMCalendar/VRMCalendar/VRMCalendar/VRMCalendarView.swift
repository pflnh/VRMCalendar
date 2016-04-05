//
//  VRMCalendarView.swift
//  VRMCalendar
//
//  Created by Jan Posz on 17.03.2016.
//  Copyright © 2016 Jan Posz. All rights reserved.
//

import UIKit

class VRMCalendarView: UIViewController {
    
    //MARK: public
    
    var date : NSDate!
    
    //MARK: private

    var scrollView : UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    
    var test : VRMCalendarView?
    var currentPageNumber = maximumPages / 2
    var previousPage : VRMCalendarPage! {
        didSet {
            previousPage.delegate = self
            previousPage.dataSource = self
            previousPage.registerCellNib(registerdNib)
        }
    }
    var currentPage : VRMCalendarPage! {
        didSet {
            currentPage.delegate = self
            currentPage.dataSource = self
            currentPage.registerCellNib(registerdNib)
        }
    }

    var nextPage : VRMCalendarPage! {
        didSet {
            nextPage.delegate = self
            nextPage.dataSource = self
            nextPage.registerCellNib(registerdNib)
        }
    }

    var internalFrame : CGRect!
    
    var delegate : VRMCalendarViewDelegate?
    var dataSource : VRMCalendarViewDataSource?
    var registerdNib : UINib!

    //MARK: init
    
    init(frame : CGRect!, currentDate : NSDate!) {
        super.init(nibName: nil, bundle: nil)
        date = currentDate
        internalFrame = frame
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = internalFrame
        scrollView = UIScrollView(frame: CGRectMake(0, 0, internalFrame.size.width, internalFrame.size.height))
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let scrollViewContentWidth = CGFloat(maximumPages) * scrollView.frame.size.width
        scrollView.contentSize = CGSizeMake(scrollViewContentWidth, scrollView.frame.size.height)
        scrollView.setContentOffset(CGPointMake(scrollViewContentWidth / 2.0, 0), animated: false)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
    }
    
    override func viewWillAVRMear(animated: Bool) {
        super.viewWillAVRMear(animated)
        constrainScrollView()
        loadInitialCalendar()
    }
    
    func constrainScrollView() {
        let upConstrain = NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0)
        let downConstrain = NSLayoutConstraint(item: scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let rightConstrain = NSLayoutConstraint(item: scrollView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 0)
        let leftConstrain = NSLayoutConstraint(item: scrollView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: 0)
        self.view.addConstraints([upConstrain, downConstrain, rightConstrain, leftConstrain])
    }
    
    func registerCellNib(nib : UINib) {
        registerdNib = nib
    }
    
    //MARK: reloading calendar
    
    func loadInitialCalendar() {
        let prevMonth = date.dateByDecrementingMonth()
        previousPage = VRMCalendarPage(date: prevMonth)
        let currentMonth = date
        currentPage = VRMCalendarPage(date: currentMonth)
        let nextMonth = date.dateByIncrementingMonth()
        nextPage = VRMCalendarPage(date: nextMonth)
        
        previousPage.view.frame = previousPageFrameForPageNumber(currentPageNumber)
        currentPage.view.frame = currentPageFrameForPageNumber(currentPageNumber)
        nextPage.view.frame = nextPageFrameForPageNumber(currentPageNumber)
        
        self.scrollView.addSubview(previousPage.view)
        self.scrollView.addSubview(currentPage.view)
        self.scrollView.addSubview(nextPage.view)
    }
    
    func reloadCaledarDates() {
        let prevMonth = date.dateByDecrementingMonth()
        previousPage.date = prevMonth
        let currentMonth = date
        currentPage.date = currentMonth
        let nextMonth = date.dateByIncrementingMonth()
        nextPage.date = nextMonth
    }
    
    func loadCalendarForNextPage(pageNumber : Int) {
        date = date.dateByIncrementingMonth()
        previousPage.view.removeFromSuperview()
        let temp = currentPage
        currentPage = nextPage
        previousPage = temp
        nextPage = VRMCalendarPage(date: date.dateByIncrementingMonth())
        reloadCaledarDates()
        nextPage.view.frame = nextPageFrameForPageNumber(pageNumber)
        self.scrollView.addSubview(nextPage.view)
    }
    
    func loadCalendarForPreviousPage(pageNumber : Int) {
        date = date.dateByDecrementingMonth()
        nextPage.view.removeFromSuperview()
        let temp = currentPage
        currentPage = previousPage
        nextPage = temp
        previousPage = VRMCalendarPage(date: date.dateByDecrementingMonth())
        reloadCaledarDates()
        previousPage.view.frame = previousPageFrameForPageNumber(pageNumber)
        self.scrollView.addSubview(previousPage.view)
    }

    func previousPageFrameForPageNumber(pageNumber : Int) -> CGRect {
        return currentPageFrameForPageNumber(pageNumber - 1)
    }
    
    func nextPageFrameForPageNumber(pageNumber : Int) -> CGRect {
        return currentPageFrameForPageNumber(pageNumber + 1)
    }
    
    func currentPageFrameForPageNumber(pageNumber : Int) -> CGRect {
        let xOrigin = CGFloat(pageNumber) * self.view.frame.size.width
        return CGRectMake(xOrigin, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)
    }
}

extension VRMCalendarView : UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageNumber = calculateScrollViewPage()
        if (pageNumber > currentPageNumber) {
            loadCalendarForNextPage(pageNumber)
        }
        else if (pageNumber < currentPageNumber) {
            loadCalendarForPreviousPage(pageNumber)
        }
        currentPageNumber = pageNumber
    }
    
    func calculateScrollViewPage() -> Int {
        return Int(scrollView.contentOffset.x / scrollView.frame.size.width);
    }
    
    func calculateFloatingScrollViewPage() -> Float {
        return Float(scrollView.contentOffset.x / scrollView.frame.size.width);
    }
}

extension VRMCalendarView : VRMCalendarPageDelegate {
    
    func VRMPage(didSelectCell cell: VRMCalendarCell, withDate: NSDate) {
        delegate?.VRMCalendar(calendar: self, didSelectCell: cell, withDate: withDate)
    }
}

extension VRMCalendarView : VRMCalendarPageDataSource {
    
    func VRMPage(sizeForCellWithDate date: NSDate) -> CGSize {
        return (dataSource?.VRMCalendar(calendar: self, sizeForCellWithDate: date))!
    }
    
    func VRMPage(headerHeightFor month: Int, inYear year: Int) -> CGFloat? {
        if let height = dataSource?.VRMCalendar(calendar: self, headerHeightForMonth: month, inYear: year) {
            return height;
        }
        return CGFloat(0)
    }
    
    func VRMPage(headerForMonth month: Int, inYear year: Int) -> VRMCalendarHeader? {
        if let header = dataSource?.VRMCalendar(calendar: self, headerForMonth: month, inYear: year) {
            return header
        }
        return nil
    }
    
    func VRMPage(customizeCell cell: VRMCalendarCell, withDate date: NSDate) -> VRMCalendarCell {
        return (dataSource?.VRMCalendar(calendar: self, customizedCell: cell, forItemWithDate: date))!
    }
}


