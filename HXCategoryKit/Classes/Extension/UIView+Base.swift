//
//  UIView+Base.swift
//  wanjia
//
//  Created by Stan Hu on 26/12/2016.
//  Copyright © 2016 Stan Hu. All rights reserved.
//

import UIKit
extension UIView{
    func addTo(view:UIView) ->Self {
        view.addSubview(self)
        return self
    }
    func borderWidth(width:CGFloat) -> Self {
        self.layer.borderWidth = width
        return self
    }
    func borderColor(color:UIColor) -> Self {
        self.layer.borderColor = color.cgColor
        return self
    }
    func cornerRadius(radius:CGFloat) -> Self {
        self.layer.cornerRadius = radius
        return self
    }
    
    func bgColor(color:UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    func clearText() {
        for v in self.subviews{
            if let t = v as? UITextField{
                 t.text = ""
            }
            else if let t = v as? UITextView{
                t.text = ""
            }
        }
    }
    
    func completed()  {
        
    }
}

extension UILabel{
    func text(text:String) -> Self {
        self.text = text
        return self
    }
    
    func attrText(text:NSAttributedString) -> Self {
        self.attributedText = text
        return self
    }
    
    func setFont(font:CGFloat) -> Self {
        self.font = UIFont.systemFont(ofSize: font)
        return self
    }
    
    func setUIFont(font:UIFont) -> Self {
        self.font = font
        return self
    }
    
    
    func color(color:UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    func txtAlignment(ali:NSTextAlignment) -> Self {
        self.textAlignment = ali
        return self
    }
  
    func lineNum(num:Int) -> Self {
        self.numberOfLines = num
        return self
    }
    
    
    

    
}
