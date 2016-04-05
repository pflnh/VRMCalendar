//
//  VRMCalendarPage.swift
//  VRMCalendar
//
//  Created by Jan Posz on 17.03.2016.
//  Copyright © 2016 Jan Posz. All rights reserved.
//

import UIKit

class VRMCalendarPage: UIViewController {
    
    var collectionView : UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    var date : NSDate!
    var selectedSingleDate : NSDate?
    var selectedStartDeta : NSDate?
    var selectedEndDate : NSDate?
    
    var registerdNib : UINib!
    var delegate : VRMCalendarPageDelegate?
    var dataSource : VRMCalendarPageDataSource?
    
    var currentMonth : Int!
    
    required init(date currentDate : NSDate) {
        super.init(nibName: nil, bundle: nil)
        date = currentDate
        currentMonth = date.month()
    }

    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
         super.viewWillAppear(animated)
        loadCalendar()
    }
    
    func loadCalendar() {
        var headerHeight = CGFloat(0)
        if let height = dataSource?.VRMPage(headerHeightFor: currentMonth, inYear: date.year()) {
            headerHeight = height
        }
        
        collectionView = UICollectionView(frame: CGRectMake(0, headerHeight, self.view.frame.size.width, self.view.frame.size.height - headerHeight), collectionViewLayout: calendarFlowLayout())
        collectionView.registerNib(registerdNib, forCellWithReuseIdentifier: pageCollectionViewCellIdentifier)
        collectionView.scrollEnabled = false
        collectionView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(collectionView)
        
        loadHeader()
    }
    
    func loadHeader() {
        if let header = dataSource?.VRMPage(headerForMonth: currentMonth, inYear: date.year()) {
            self.view.addSubview(header)
        }
    }
    
    func registerCellNib(nib : UINib) {
        registerdNib = nib
    }
    
    func calendarFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(self.view.frame.size.width / 7, self.view.frame.size.height / 6)
        return layout
    }
    
    func debug_randomColor() -> UIColor {
        
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    func calculateDateAtIndexPath(indexPath : NSIndexPath) -> NSDate {
        let day = dayByDecodingIndexPath(indexPath)
        return NSDate.dateWith(year: date.year(), month: currentMonth, day: day)
    }
    
    func dayByDecodingIndexPath(indexPath : NSIndexPath) -> Int {
        let row = indexPath.row
        return row - date.firstMonthDayIndex() + 1
    }
    
    func reloadData() {
        self.collectionView.performBatchUpdates({ () -> Void in
            [self.collectionView .reloadSections(NSIndexSet(index: 0))]
            }, completion: nil)
    }
}

extension VRMCalendarPage : UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! VRMCalendarCell
        let selectedDate = calculateDateAtIndexPath(indexPath)
        delegate?.VRMPage(didSelectCell: cell, withDate: selectedDate)
    }
}

extension VRMCalendarPage : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(pageCollectionViewCellIdentifier, forIndexPath: indexPath) as! VRMCalendarCell
        let indexedDate = calculateDateAtIndexPath(indexPath)
        if let customizedCell = dataSource?.VRMPage(customizeCell: cell, withDate: indexedDate) {
            if (indexedDate.month() != currentMonth) {
                customizedCell.makeInactiveMonthDay()
            }
            if (dataSource?.VRMPageShouldMarkCellWithDate(indexedDate) == true) {
                customizedCell.select()
            }
            else {
                customizedCell.deselect()
            }
            return customizedCell
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension VRMCalendarPage : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if let size = dataSource?.VRMPage(sizeForCellWithDate: calculateDateAtIndexPath(indexPath)) {
            return CGSizeMake(self.view.frame.size.width / 7, size.height)
        }
        return CGSizeMake(self.view.frame.size.width / 7, self.view.frame.size.height / 6)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
}
