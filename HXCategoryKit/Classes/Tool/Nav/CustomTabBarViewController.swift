//
//  CustomTabBarViewController.swift
//  Swift_Tab
//
//  Created by 黄星 on 15/8/31.
//  Copyright (c) 2015年 qingfanqie. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController, MCTabBarDelegate {

    var titleLabel: UILabel?

    /**
    *  输入对应的数字，以便跳转界面 数字1为身边，2为我的，3为更多
    */
    var iPage:NSInteger = 0
    
    var tabBarView = MCTabBarView()
    
    // 单例
    static let sharedInstance:CustomTabBarViewController = CustomTabBarViewController()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initViewPage()
        self.navigationController?.navigationBar.isHidden = true

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        automaticallyAdjustsScrollViewInsets = false
        self.initView()

    }
    
    /**
    *  初始化TabBar , 子控制器
    */
    func initView() {
        
        let vc1 = BookSearchViewController()
        addChildViewController(vc1)
        
        var vc = HomeViewController()
        addChildViewController(vc)
        
        vc = HomeViewController()
        addChildViewController(vc)
//        let mainVC = MainViewController()
////        let nav = BaseNavigationViewController(rootViewController: infoVC)
//        self.addChildViewController(mainVC)
//        
//        let collegeVC = CollegeMenuViewController()
////        let nav1 = BaseNavigationViewController(rootViewController: videoVC)
//        addChildViewController(collegeVC)
//        
//        let emptyVC = UIViewController()
//        addChildViewController(emptyVC)
//        
//        let wanplusVC = WanplusMenuViewController()
////        let wanplusVC = WanplusMaskViewController()
//        addChildViewController(wanplusVC)
//
//        let myVC = MyViewController()
//        //        let nav2 = BaseNavigationViewController(rootViewController: heroVC)
//        addChildViewController(myVC)
        
        self.tabBar.alpha = 0.8
        self.tabBarView.frame = CGRect(x: 0, y: kPHONE_HEIGHT - 49, width: kPHONE_WIDTH, height: 49)
        self.tabBarView.tabDelegate = self
        self.view.addSubview(self.tabBarView)
        
        self.tabBarView.addTabBarButtons()
        
        let dic:NSDictionary = ["key":"1"]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "QUERY_RED_POINT"), object: dic)
    }
    
    func initViewPage() {
        self.selectedIndex = self.iPage
        self.tabBarView.selectedBtn(self.iPage)
    }
    
    /**
    *  监听tabbar按钮的改变
    *  @param from   原来选中的位置
    *  @param to     最新选中的位置
    */
    func tabBar(_ tabBar: MCTabBarView, to: NSInteger) {
        self.selectedIndex = to
        self.iPage = to
    }
    
    // 玩加圈消息个数
    func checkWanplusMessageCount() {
        
    
    }
    
    // 查询红点是否显示
    func initData() {
       
    }
    
    /**
    *  初始化一个子控制器
    *
    *  @param childVc           需要初始化的子控制器
    */
    func setupChildViewController(childVc:UIViewController) {
        self.addChildViewController(childVc)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
