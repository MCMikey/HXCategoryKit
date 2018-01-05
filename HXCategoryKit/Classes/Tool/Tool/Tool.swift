//
//  Tool.swift
//  wanjia
//
//  Created by Mikey on 16/11/22.
//  Copyright © 2016年 Stan Hu. All rights reserved.
//

import UIKit

class Tool: NSObject {
    
    static func getCurrentAppDelegate()->AppDelegate {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app
    }
    
    static func getCurrentController()->UIViewController? {
        
        var vc = UIApplication.shared.windows.first?.rootViewController
        
        if vc != nil {
            if vc!.isKind(of: UINavigationController.self) {
                vc = (vc as! UINavigationController).viewControllers.last!
            }
        }
        
        return vc
    }
    
    static func delAfterZero(testNumber:String) -> String{
        var outNumber = testNumber
        var i = 1
        
        if testNumber.contains("."){
            while i < testNumber.characters.count{
                if outNumber.hasSuffix("0"){
                    outNumber.remove(at: outNumber.index(before:outNumber.endIndex))
                    i = i + 1
                }else{
                    break
                }
            }
            
            if outNumber.hasSuffix("."){
                outNumber.remove(at: outNumber.index(before:outNumber.endIndex))
            }
            return outNumber
        } else{
            return testNumber
        }
    }
    
    static func numberOfChars(_ str: String) -> Int {
        var number = 0
        
        guard str.characters.count > 0 else {return 0}
        
        for i in 0...str.characters.count - 1 {
            let c: unichar = (str as NSString).character(at: i)
            
            if (c >= 0x4E00) {
                number += 2
            }else {
                number += 1
            }
        }
        return number
    }
    
    // NSCoding 存入信息
    static func saveCodingInfo(info: AnyObject, name:String) {
            var sp = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            sp = sp!.appending("/jxdcl_\(name).data")
            let succ = NSKeyedArchiver.archiveRootObject(info, toFile: sp!)
            Log("写入路径为 = \(String(describing: sp)),\n 失败或者成功 = \(succ)")
    }
    
    // 获得信息
    static func getCodingInfo(name:String)-> AnyObject {
        var sp = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        sp = sp!.appending("/jxdcl_\(name).data")
        let info = NSKeyedUnarchiver.unarchiveObject(withFile: sp!) as AnyObject
        Log("取出路径为 = \(String(describing: sp)), \n")
        
        return info
    }
    
    // 返回整点时间
    static func getNextHourDate(hour: Int = 1)->Date {
        let date = Date(timeIntervalSinceNow: 60 * 60 * hour)
        let calendar = NSCalendar.current
        let coms: Set<Calendar.Component> = [.era, .year, .month, .day, .hour, .minute, .second]
        var comps: DateComponents = calendar.dateComponents(coms, from: date)
        comps.minute = 0
        return calendar.date(from: comps)!
    }

    
    // 版本更新提示
    static func checkVersion() {
        
//        if let info = Tool.getCurrentAppDelegate().systemInfo {
//            
//            if !Tool.compareVersion(version: info.version) {
//                return
//            }
//            
//            let alertVC = UIAlertController(title: "发现新版本\(info.version)", message: "\(info.versionIntro)", preferredStyle: .alert)
//            
//            let action = UIAlertAction(title: "前往更新", style: .default, handler: { (_) in
//                let url = URL(string: "https://itunes.apple.com/cn/app/id1176755755")
//                UIApplication.shared.openURL(url!)
//            })
//            
//            let actionCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//            
//            alertVC.addAction(action)
//            alertVC.addAction(actionCancel)
//            Tool.getCurrentController()?.presentVC(alertVC)
//        }
        
    }
    
    // 比较版本
    static func compareVersion(version: String)-> Bool {
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        
        if currentVersion == version {
            //先比较是不是一样的,是一样的就不要升级
            return false
        }
        let currentVersionArray = currentVersion.components(separatedBy: ".")
        let compareVersionArray = version.components(separatedBy: ".")
        if compareVersionArray.count != 3 {
            return false
        }
        
        let fCurrent = currentVersionArray[0].toInt()!
        let fCompare = compareVersionArray[0].toInt()!
        let sCurrent = currentVersionArray[1].toInt()!
        let sCompare = compareVersionArray[1].toInt()!
        let tCurrent = currentVersionArray[2].toInt()!
        let tCompare = compareVersionArray[2].toInt()!
        if fCurrent < fCompare {
            return true
        } else if sCurrent < sCompare && fCompare == fCurrent {
            return true
        } else if tCurrent < tCompare && sCompare == sCurrent && fCurrent == fCompare {
            return true
        }
        
        return false
    }
    
    

}





