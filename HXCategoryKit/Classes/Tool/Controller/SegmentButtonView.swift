//
//  SegmentButtonView.swift
//  SwiftDemo
//
//  Created by XFB on 2017/4/20.
//  Copyright © 2017年 fearless. All rights reserved.
//

import UIKit

class SegmentButtonView: UIView {

    //MARK:- 对外暴露的属性
    var buttonBottomView = UIView()
    var buttonCount : NSInteger = 0

    
    //MARK:- 闭包回调
    var closure:((_ buttonIndex: NSInteger)->Void)?

    //MARK:- 系统回调函数
    override init(frame : CGRect) {
        super.init(frame: frame)
        
        //初始化UI
        self.initUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:- 初始化UI
extension SegmentButtonView {
    
    func initUI() -> () {
        self.backgroundColor = UIColor.white
        self.buttonBottomView = UIView()
        self.buttonBottomView.backgroundColor = UIColor.clear
        addSubview(self.buttonBottomView)
    }
}

// MARK:- 初始化推荐/投诉热点/网友回音/处理结果按钮
extension SegmentButtonView {
    
    func setSegmentViewWithButtonName(nameArray : NSArray, closure : @escaping(NSInteger)->Void) {
        
        self.closure = closure
        self.buttonCount = nameArray.count
        
        let buttonW : CGFloat = 80
        let buttonH : CGFloat = self.frame.size.height
        let buttonY : CGFloat = 0
        
        let buttonMargin = (self.frame.size.width - CGFloat(nameArray.count) * buttonW) / CGFloat(nameArray.count + 1);
        
        for i in 0..<nameArray.count {
            
            let button = UIButton()
            let buttonX = CGFloat(i) * (buttonMargin + buttonW) + buttonMargin
            button.frame = CGRect(x: buttonX, y: buttonY, width: buttonW, height: buttonH)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.setTitle(nameArray[i] as? String, for: .normal)
            button.setTitleColor(UIColor.init(red: 51/255, green: 51/255, blue: 51/255, alpha: 1), for: .normal)
            
            if i == 0 {
                button.setTitleColor(UIColor.init(red: 54/255, green: 192/255, blue: 120/255, alpha: 1), for: .normal)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                
                /// 设置凸起三角形的frame
                var buttonFrame = button.frame
                buttonFrame.origin.y = buttonFrame.size.height - 3
                buttonFrame.size.height = 3;
                self.buttonBottomView.frame = buttonFrame
            }
            button.tag = 1000 + i
            button.addTarget(self, action:#selector(SegmentButtonView.clickButton(sender:)), for:.touchUpInside)
            self.addSubview(button)
        }
    }
}

// MARK: - 按钮点击
extension SegmentButtonView {
    
    @objc func clickButton(sender : UIButton) {
        self.closure!(sender.tag - 1000)
        self.changeButtonsStyle(index: sender.tag - 1000)
    }
}

// MARK: - 改变样式
extension SegmentButtonView {

    func changeButtonsStyle(index : NSInteger) {
        
        for i in 0..<self.buttonCount {
            let tagButton = self.viewWithTag(1000 + i) as! UIButton!
            tagButton?.setTitleColor(UIColor.init(red: 51/255, green: 51/255, blue: 51/255, alpha: 1), for: .normal)
            tagButton?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        }
        
        /// 得到当前选中的button，并且设置文字的大小和颜色
        let button = self.viewWithTag(1000 + index) as! UIButton!
        button?.setTitleColor(UIColor.init(red: 54/255, green: 192/255, blue: 120/255, alpha: 1), for: .normal)
        button?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        /// 重新设置frame
        var lineFrame = button?.frame
        lineFrame?.origin.y = (lineFrame?.size.height)! - 3
        lineFrame?.size.height = 3;
        
        UIView.animate(withDuration: 0.2) {
            self.buttonBottomView.frame = lineFrame!
        };
    }
}

