//
//  SegmentMenuTable.swift
//  SwiftDemo
//
//  Created by XFB on 2017/4/20.
//  Copyright © 2017年 fearless. All rights reserved.
//

import UIKit

class SegmentMenuTable: UIView, UIScrollViewDelegate {

    //MARK:- 对外提供属性
    var scrollView = UIScrollView()
    var currentPage : NSInteger = 0
//    var scrollEnabled : Bool = true
    var viewControllers = NSMutableArray()
    
    /// 闭包
    var selectBlock:((_ index: NSInteger)->Void)?

    //MARK:- 系统回调方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var scrollEnabled : Bool? {
        set{
            self.scrollView.isScrollEnabled = (newValue != nil)
            self.scrollEnabled = (newValue != nil)
        }
        get{
            return self.scrollEnabled
        }
    }
}


//MARK:- 初始化UI
extension SegmentMenuTable {
    
    func initUI() {
        
        scrollView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-149)
        scrollView.backgroundColor = UIColor.white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self as UIScrollViewDelegate
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.alwaysBounceHorizontal = false
        addSubview(scrollView)

    }
}

//MARK:- 按照顺序放入ViewController
extension SegmentMenuTable {
    
    func addSubViewController(array : NSArray) {
        self.viewControllers = NSMutableArray.init(array: array)
        self.loadScrollViewWithPage(page: 0)
        self.scrollView.contentSize = CGSize(width: self.bounds.size.width * CGFloat(self.viewControllers.count), height: 0)
    }
}

//MARK: - 加载滚动到指定页的视图
extension SegmentMenuTable {

    func loadScrollViewWithPage(page : NSInteger) {
        let vc = self.viewControllers.object(at: page)
        self.currentPage = page
        var frame = self.scrollView.frame
        frame.origin.x = self.scrollView.frame.size.width * CGFloat(page)
        frame.origin.y = 0
        (vc as! UIViewController).view.frame = frame
        self.scrollView.addSubview((vc as! UIViewController).view)
        
        if self.scrollView.contentOffset.x != frame.origin.x {
            self.scrollView.setContentOffset(CGPoint(x: frame.origin.x, y: 0), animated: true)
        }
    }
}

//MARK:- scrollView的代理方法
extension SegmentMenuTable {
    
    /// scrollView的代理方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let pageWidth = self.scrollView.bounds.size.width
        let page : CGFloat = CGFloat((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        self.currentPage = NSInteger(page)
        
        if self.currentPage >= 0 && self.currentPage <= self.viewControllers.count - 1 {
            self.loadScrollViewWithPage(page: self.currentPage)
        }

        if (self.selectBlock != nil) {
            self.selectBlock!(self.currentPage)
        }
    }
}
