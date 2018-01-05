//
//  BaseViewController.swift
//  jxdcl
//
//  Created by Mikey on 2017/7/6.
//  Copyright © 2017年 jxd. All rights reserved.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    lazy var vNav: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.alpha = 0.97
        return v
    }()
    
    lazy var btnBack: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    lazy var lblNavTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = color9bca31
        return label
    }()
    
    lazy var vNavLine: UIView = {
        let v = UIView()
        v.backgroundColor = colorLineGray
        return v
    }()
    
    lazy var btnRight: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    lazy var pageName: String = {
        return ""
    }()
    
    /// tableView plain
    lazy var tableViewOfPlain: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: .plain)
        tb.estimatedRowHeight = 0
        tb.estimatedSectionHeaderHeight = 0
        tb.estimatedSectionFooterHeight = 0
        tb.tableFooterView = UIView()
        if #available(iOS 11.0, *) {
            tb.contentInsetAdjustmentBehavior = .never
        }
        return tb
    }()
    
    /// tableView grouped
    lazy var tableViewOfGrouped: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: .grouped)
        tb.estimatedRowHeight = 0
        tb.estimatedSectionHeaderHeight = 0
        tb.estimatedSectionFooterHeight = 0
        if #available(iOS 11.0, *) {
            tb.contentInsetAdjustmentBehavior = .never
        }
        return tb
    }()
    
    lazy var scrollView: UIScrollView = {
        let sc = UIScrollView()

        if #available(iOS 11.0, *) {
            sc.contentInsetAdjustmentBehavior = .never
        }
        return sc
    }()
    
    /// 当前的navigationController
//    var currentNavigationController: UINavigationController{
//        get {
//            let delegate = UIApplication.shared.delegate as! AppDelegate
//            return delegate.nav!
//        }
//    }
    
    /// 返回当前的nav, 没有就会抓window的
//    override var navigationController: UINavigationController? {
//        get {
//            var nav = super.navigationController
//            if nav == nil {
//                nav = currentNavigationController
//            }
//            return nav
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
    }
    
    /// 设置导航栏
    func setNav(back:Bool,navTitle:String,navLine:Bool)  {
        vNav.backgroundColor = colorNavTheme
        view.addSubview(vNav)
        //        btnBack.setTitle("返回", for: .normal)
        //btnBack.setImage(#imageLiteral(resourceName: "public_btn_back_white"), for: .normal)
        //btnBack.addTarget(self, action: #selector(clickBack), for: .touchUpInside)
        if back {
            vNav.addSubview(btnBack)
        }
        lblNavTitle.text = navTitle
        lblNavTitle.textColor = colorBlackText
        lblNavTitle.textAlignment = .center
        vNav.addSubview(lblNavTitle)
        if navLine {
            vNav.addSubview(vNavLine)
        }
        
        vNav.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(64)
        }
        
        lblNavTitle.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.centerX.equalTo(ScreenWidth / 2)
            make.width.equalTo(ScreenWidth - 100)
            make.height.equalTo(43.5)
        }
        
        if back {
            btnBack.snp.makeConstraints({ (make) in
                make.left.equalTo(0)
                make.top.equalTo(20)
                make.width.equalTo(49)
                make.height.equalTo(43.5)
            })
        }
        if navLine {
            vNavLine.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(0)
                make.height.equalTo(0.5)
            })
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
