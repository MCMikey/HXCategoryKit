//
//  TabBarView.swift
//  Swift_Tab
//
//  Created by 黄星 on 15/8/31.
//  Copyright (c) 2015年 qingfanqie. All rights reserved.
//

import UIKit

let kPHONE_WIDTH = (UIScreen.main.bounds.size.width)
let kPHONE_HEIGHT = (UIScreen.main.bounds.size.height)

// 设置Tab上面按钮的个数
let kBUTTONCOUNT = 3

protocol MCTabBarDelegate:NSObjectProtocol {
    func tabBar(_ tabBar:MCTabBarView, to:NSInteger)
}

class MCTabBarView: UIView {
    
    var tabDelegate:MCTabBarDelegate?
    
    var str_img_nav = NSArray()
    var str_img_nav_focus = NSArray()
    var str_title = NSArray()
    var img_nav = NSMutableArray()
    var dic = NSMutableDictionary()
    
    // 按钮底图
    var imgTab_Nor = UIImage(named: "tab_nor")
    var imgTab_Sel = UIImage(named: "tab_sel")
    
    let colorTextDefault = UIColor.lightGray
    let colorTextSelected = colorBlackText

    override init (frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = UIColor.redColor()
        
        self.str_img_nav = ["icon_tab_1_nor", "icon_tab_2_nor", "icon_tab_3_nor"]
        
        self.str_img_nav_focus = ["icon_tab_1_selected", "icon_tab_2_selected", "icon_tab_3_selected"]
        
        self.str_title = ["Home", "All", "Me"];
    }
    
    func goFor(_ sender:UIButton) {
        
        for i in 0..<kBUTTONCOUNT {
            let button = self.img_nav[i] as! MCTabBarButton
            self.setBtnNormal(button, index: i)
            if sender.tag == i {
                self.setBtnSelect(button, index: i)
            }
        }
        
        if self.tabDelegate != nil && self.tabDelegate?.responds(to: Selector(("tabBar:"))) == false {
            self.tabDelegate?.tabBar(self, to: sender.tag)
        }
    }
    
    func selectedBtn(_ iPage:NSInteger) {
        for i in 0..<kBUTTONCOUNT {
            let button = self.img_nav[i] as! MCTabBarButton
            self.setBtnNormal(button, index: i)
            if iPage == i {
                self.setBtnSelect(button, index: i)
            }
        }
    }
    
    /**
    *   加入内部按钮
    */
    func addTabBarButtons() {
        self.initView()
    }
    
    /**
        设置按钮普通状态
    */
    func setBtnNormal(_ sender:UIButton, index:NSInteger) {
        sender.setImage(UIImage(named: self.str_img_nav[index] as! String), for: .normal)
        sender.setBackgroundImage(imgTab_Nor, for: UIControlState.normal)
        sender.setTitleColor(colorTextDefault, for: .normal)
    }
    
    /**
        设置按钮选中状态
    */
    func setBtnSelect(_ sender:UIButton, index:NSInteger) {
        sender.setImage(UIImage(named: self.str_img_nav_focus[index] as! String), for: .normal)
        sender.setBackgroundImage(imgTab_Sel, for: UIControlState.normal)
        sender.setTitleColor(colorTextSelected, for: .normal)
    }
    
    // 退出登录时
//    func hideView() {
//        let button = self.img_nav[2] as! MCTabBarButton
//        button .hiddenView()
//    }
//    
//    func showRedDot(_ data:Notification) {
//        let dic:NSDictionary = data.object as! NSDictionary
//        if (dic["key"] as AnyObject).isEqual("1") == true {
//            // 让红点显示
//            let button = self.img_nav[2] as! MCTabBarButton
//            button.hiddenView()
//        } else {
//            // 让红点消失
//            let button = self.img_nav[2] as! MCTabBarButton
//            button.hideView()
//        }
//    }



    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        self.alpha = 0.9
        let tabBarBG = UIImageView(frame: CGRect(x: 0, y: 0, width: kPHONE_WIDTH, height: 49))
        tabBarBG.isUserInteractionEnabled = true;
        tabBarBG.image = UIImage(named: "nav_bg")
        tabBarBG.backgroundColor = UIColor(white: 0.98, alpha: 0.7)
        self.addSubview(tabBarBG)
        // 按钮的frame数据
        let buttonH = self.frame.size.height
        let buttonW = self.frame.size.width / CGFloat(kBUTTONCOUNT)
        let buttonY = 0
        
        for index in 0..<kBUTTONCOUNT {
            print("\(index)")
            let buttonX = CGFloat(index) * buttonW
            let item = MCTabBarButton(frame: CGRect(x: buttonX, y: CGFloat(buttonY), width: buttonW, height: buttonH))
            item.contentMode = UIViewContentMode.center
            item.tag = index
            item.backgroundColor = UIColor.clear
            item.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            item.layoutStyle = .upImageDownTitle
            item.setTitle(self.str_title[index] as? String, for: UIControlState())
            item.setTitleColor(colorTextDefault, for: .normal)
            self.setBtnNormal(item, index: index)
            item.addTarget(self, action: #selector(goFor(_:)), for: UIControlEvents.touchUpInside)
            self.img_nav.add(item)
            self.addSubview(item)
        }
    }

}
