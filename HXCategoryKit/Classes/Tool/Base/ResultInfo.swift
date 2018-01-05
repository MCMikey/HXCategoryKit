//
//  ResultInfo.swift
//  wanjia
//
//  Created by Stan Hu on 31/10/2016.
//  Copyright © 2016 Stan Hu. All rights reserved.
//

import Foundation
import SwiftyJSON
class ResultInfo:NSObject {
    var resultCode:Int = -1
    var resultMessage:String = "无法连接网络，请重新再试"
    var resultContent:AnyObject?
    var requestId = ""
    static func convertPHPResponseToResultInfo(response:Any?) -> ResultInfo {
        let result = ResultInfo()
        if response == nil {
            return result
        }
        let err: NSErrorPointer = nil
//        if !JSONSerialization.isValidJSONObject(response!) {
//            result.resultMessage = "非法的JSON"
//             return result
//        }
        guard let anyObject = try? JSONSerialization.jsonObject(with: response! as! Data, options: .mutableContainers) else {
                result.resultMessage = "非法的JSON"
                 return result
        }
        let json = JSON(anyObject)
        
       // Log(message: "输出Json = \(json)")
        if err != nil {
            Log("解析JSON错误:\(String(describing: err))")
        }
        if  let code = json["ret_code"].int{
            result.resultCode = code
        }
        result.resultMessage = json["ret_msg"].string ?? "无法连接网络，请重新再试"
        result.resultContent = json["data"].object as AnyObject?
//        result.requestId = json["sSerialCode"].string ?? ""
//        print("该次请求id是\(result.requestId)")
        return result
    }
    
}
