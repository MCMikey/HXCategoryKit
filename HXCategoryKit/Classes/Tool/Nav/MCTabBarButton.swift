//
//  QFQTabBarButton.swift
//  Swift_Tab
//
//  Created by 黄星 on 15/9/1.
//  Copyright (c) 2015年 qingfanqie. All rights reserved.
//

import UIKit

class MCTabBarButton: JXLayoutButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var imgPoint = UIImageView()
    
    /// 带数字的红点
    var labelPoint = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imgPoint.frame = CGRect(x: 46, y: 5, width: 10, height: 10)
        self.imgPoint.backgroundColor = .red
        self.imgPoint.isHidden = true
        self.imgPoint.layer.cornerRadius = 5
        self.addSubview(self.imgPoint)
        
        self.labelPoint.frame = CGRect(x: 45, y: 3, width: 16, height: 16)
        self.labelPoint.layer.masksToBounds = true
        self.labelPoint.layer.cornerRadius = 8
        self.labelPoint.adjustsFontSizeToFitWidth = true
        self.labelPoint.textAlignment = .center
        self.labelPoint.font = UIFont.systemFont(ofSize: 10)
        self.labelPoint.textColor = .white
        self.labelPoint.backgroundColor = .red
        self.labelPoint.isHidden = true
        self.addSubview(self.labelPoint)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 显示红点
    func hiddenView() {
        self.imgPoint.isHidden = false
    }
    
    // 隐藏红点
    func hideView() {
        self.imgPoint.isHidden = true
    }
    
    /**
     显示数字
     */
    func showPoint(count: Int) {
        if count == 0 {
            self.labelPoint.text = nil
            self.labelPoint.isHidden = true
        } else {
            self.labelPoint.text = "\(count)"
            self.labelPoint.isHidden = false
        }
    }
    
    /**
     隐藏数字
     */
    func dissmissPoint() {
        self.labelPoint.isHidden = true
    }
    
}
