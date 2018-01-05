//
//  Toast.swift
//  wanjia
//
//  Created by Stan Hu on 14/10/2016.
//  Copyright © 2016 Stan Hu. All rights reserved.
//

import UIKit
import WSProgressHUD
class Toast{
    static func showToast(msg:String) {
        GrandCue.toast(msg)
    }
    static func showToast(msg:String,originy:Float) {
        GrandCue.toast(msg, verticalScale: originy)
    }
    static func showLoading() {
      WSProgressHUD.show(withStatus: "加载中", maskType: .clear)
    }
    static func showLoading(msg:String) {
        WSProgressHUD.show(withStatus: msg, maskType: .clear)
    }
    static func dismissLoading() {
        WSProgressHUD.dismiss()
    }
}
