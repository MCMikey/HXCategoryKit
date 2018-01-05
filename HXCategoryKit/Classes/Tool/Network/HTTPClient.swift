//
//  HTTPClient.swift
//  YiLinkerOnlineBuyer
//
//  Created by zhengxuening on 16/3/11.
//  Copyright © 2016年 yiLinker-online-buyer. All rights reserved.
//

/**
 网络请求封装类
 */

import UIKit
import AFNetworking

enum RequestErrorType {
    case NoInternetConnection  // 没有网络连接
    case RequestTimeOut        // 请求超时
    case PageNotFound          // 页面没有找到
    case ResponseError         // 请求成功,但在服务器遇到错误
    case NoError               // 没有错误
    case Cancel                // 取消
}

/// 函数回调别名
//typealias httpClosure = (_ successful: Bool, _ responseJSON: Any?, _ requestErrorType: RequestErrorType) -> Void
typealias completed = ((_ result: ResultInfo) -> Void)

class HTTPClient: NSObject {
    
    /**
     *  服务器返回码
     */
    struct WebServiceStatusCode {
        static let pageNotFound: Int = 404
    }
    
    /// 网络请求个数
    var taskCount = 0
    
    var dicTask = [String: URLSessionDataTask]()
    
    /// 单例
    static let sharedInstance:HTTPClient = {
        let client = HTTPClient()
        return client
    }()
    
    /// 这个变量不要用！
    private var selfInstanceAFN: AFHTTPSessionManager?
    
    func shareInstanceAFN()-> AFHTTPSessionManager {
        if selfInstanceAFN == nil {
            selfInstanceAFN = AFHTTPSessionManager(baseURL: nil)
            selfInstanceAFN?.responseSerializer = AFHTTPResponseSerializer()
            selfInstanceAFN?.requestSerializer.willChangeValue(forKey: "timeoutInterval")
            selfInstanceAFN?.requestSerializer.timeoutInterval = 20.0
            selfInstanceAFN?.requestSerializer.didChangeValue(forKey: "timeoutInterval")
        }
        return selfInstanceAFN!
    }
    
    // MARK: - 私有init
    private override init() {}
    
    // MARK: - 请求方法
    // MARK: - GET方法
    /// GET请求  url, httpName, closure
    static func get(url:String, httpName:String?, closure:@escaping completed) {
        print(url)
        let _ = HTTPClient.sharedInstance.request(url: url, params: nil, httpName:httpName, isPOST: false, closure: closure)
    }
    
    /// GET请求  url, params, httpName, closure
    static func get(url:String, params:[String:Any]?, httpName:String?, closure:@escaping completed) {
        print(url)
        let _ = HTTPClient.sharedInstance.request(url: url, params: params, httpName:httpName, isPOST: false, closure: closure)
    }
    
    /// GET请求  url, httpName, closure
    static func getNor(url:String, httpName:String?, closure:@escaping completed) {
        print(url)
        let _ = HTTPClient.sharedInstance.requestNor(url: url, params: nil, httpName:httpName, isPOST: false, closure: closure)
    }
    
    // MARK: - POST方法
    /// POST请求  url, params, httpName, closure
    static func post(url:String, params:[String:Any]?, httpName:String?, closure:@escaping completed) {
        print(url)
        let _ = HTTPClient.sharedInstance.request(url: url, params: params, httpName:httpName, isPOST: true, closure: closure)
    }
    
    /// 图片上传
    static func postPic(url:String, params:[String:Any]?, imgs:[Any], httpName:String?, closure:@escaping completed) {
        print(url)
        let _ = HTTPClient.sharedInstance.requestPic(url: url, params: params, imgs: imgs, httpName:httpName, closure: closure)
    }
    
    private func request(url:String, params:[String:Any]?, httpName:String?, isPOST:Bool, closure:@escaping completed) ->URLSessionDataTask {
        
        var sessionDataTask:URLSessionDataTask?
        let sAllURL = url
        
        if isPOST{
            sessionDataTask = HTTPClient.sharedInstance.shareInstanceAFN().post(sAllURL, parameters: params, progress: nil, success: {[weak self] (task, responseObject) in
                let res = ResultInfo.convertPHPResponseToResultInfo(response: responseObject)
                closure(res)
                //网络请求-1
                self?.decreaseTaskCount()
                self?.delTaskId(httpName: httpName!)
                }, failure: {[weak self] (task, error) in
                    let res = ResultInfo()
                    if let task = task!.response as? HTTPURLResponse {
                        if task.statusCode == WebServiceStatusCode.pageNotFound {
                            // 页面没有找到
                            res.resultCode = -100
                            res.resultMessage = "没有找到页面"
                        } else {
                            // 服务器遇到错误
                            res.resultCode = -200
                            res.resultMessage = "服务器内部错误"
                        }
                    } else {
                        // 取消
                        res.resultCode = -500
                        res.resultMessage = "网络异常"
                        if error.localizedDescription == "已取消"{
                            res.resultCode = -501
                            
                        }
                    }
                    closure(res)
                    //网络请求-1
                    self?.decreaseTaskCount()
                    self?.delTaskId(httpName: httpName!)
                    Log("********网络请求分割线********\n POST请求失败：\(sAllURL) \n 错误提示：\(error) \n ********网络请求分割线********")
                    
            })
        } else {
            sessionDataTask = HTTPClient.sharedInstance.shareInstanceAFN().get(sAllURL, parameters: params, progress: nil, success: {[weak self] (task, responseObject) in
                let res = ResultInfo.convertPHPResponseToResultInfo(response: responseObject)
                closure(res)
                //网络请求-1
                self?.decreaseTaskCount()
                self?.delTaskId(httpName: httpName!)
                }, failure: {[weak self] (task, error) in
                    let res = ResultInfo()
                    if let task = task!.response as? HTTPURLResponse {
                        if task.statusCode == WebServiceStatusCode.pageNotFound {
                            // 页面没有找到
                            res.resultCode = -100
                            res.resultMessage = "没有找到页面"
                        } else {
                            // 服务器遇到错误
                            res.resultCode = -200
                            res.resultMessage = "服务器内部错误"
                        }
                    } else {
                        // 取消
                        res.resultCode = -500
                        res.resultMessage = "网络异常"
                        if error.localizedDescription == "已取消"{
                            res.resultCode = -501
                            
                        }
                    }
                    closure(res)
                    //网络请求-1
                    self?.decreaseTaskCount()
                    self?.delTaskId(httpName: httpName!)
                    Log("********网络请求分割线********\n GET请求失败：\(sAllURL) \n 错误提示：\(error) \n ********网络请求分割线********")
            })
        }
        
        Log("\n当前请求的Url = \(String(describing: sessionDataTask?.currentRequest?.url))\n")
        if httpName != nil {
            dicTask[httpName!] = sessionDataTask
        }
        // 网络请求+1
        increaseTaskCount()
        return sessionDataTask!
    }
    
    // 直接抓取返回数据response
    private func requestNor(url:String, params:[String:Any]?, httpName:String?, isPOST:Bool, closure:@escaping completed) ->URLSessionDataTask {

        var sessionDataTask:URLSessionDataTask?
        let sAllURL = url
        
        if isPOST{
            sessionDataTask = HTTPClient.sharedInstance.shareInstanceAFN().post(sAllURL, parameters: params, progress: nil, success: {[weak self] (task, responseObject) in
                let res = ResultInfo()
                res.resultContent = responseObject as AnyObject?
                closure(res)
                //网络请求-1
                self?.decreaseTaskCount()
                self?.delTaskId(httpName: httpName!)
            }, failure: {[weak self] (task, error) in
                let res = ResultInfo()
                if let task = task!.response as? HTTPURLResponse {
                    if task.statusCode == WebServiceStatusCode.pageNotFound {
                        // 页面没有找到
                        res.resultCode = -100
                        res.resultMessage = "没有找到页面"
                    } else {
                        // 服务器遇到错误
                        res.resultCode = -200
                        res.resultMessage = "服务器内部错误"
                    }
                } else {
                    // 取消
                    res.resultCode = -500
                    res.resultMessage = "网络异常"
                    if error.localizedDescription == "已取消"{
                        res.resultCode = -501
                        
                    }
                }
                closure(res)
                //网络请求-1
                self?.decreaseTaskCount()
                self?.delTaskId(httpName: httpName!)
                Log("********网络请求分割线********\n POST请求失败：\(sAllURL) \n 错误提示：\(error) \n ********网络请求分割线********")
                
            })
        } else {
            sessionDataTask = HTTPClient.sharedInstance.shareInstanceAFN().get(sAllURL, parameters: params, progress: nil, success: {[weak self] (task, responseObject) in
//                let res = ResultInfo.convertPHPResponseToResultInfo(response: responseObject)
                
                let res = ResultInfo()
                res.resultContent = responseObject as AnyObject?
                closure(res)
                //网络请求-1
                self?.decreaseTaskCount()
                self?.delTaskId(httpName: httpName!)
            }, failure: {[weak self] (task, error) in
                let res = ResultInfo()
                if let task = task!.response as? HTTPURLResponse {
                    if task.statusCode == WebServiceStatusCode.pageNotFound {
                        // 页面没有找到
                        res.resultCode = -100
                        res.resultMessage = "没有找到页面"
                    } else {
                        // 服务器遇到错误
                        res.resultCode = -200
                        res.resultMessage = "服务器内部错误"
                    }
                } else {
                    // 取消
                    res.resultCode = -500
                    res.resultMessage = "网络异常"
                    if error.localizedDescription == "已取消"{
                        res.resultCode = -501
                        
                    }
                }
                closure(res)
                //网络请求-1
                self?.decreaseTaskCount()
                self?.delTaskId(httpName: httpName!)
                Log("********网络请求分割线********\n GET请求失败：\(sAllURL) \n 错误提示：\(error) \n ********网络请求分割线********")
            })
        }
        
        Log("\n当前请求的Url = \(String(describing: sessionDataTask?.currentRequest?.url))\n")
        if httpName != nil {
            dicTask[httpName!] = sessionDataTask
        }
        // 网络请求+1
        increaseTaskCount()
        return sessionDataTask!
    }
    
    // MARK: - 图片上传
    private func requestPic(url:String, params:[String:Any]?, imgs: [Any], httpName:String?, closure:@escaping completed) ->URLSessionDataTask {

        var sessionDataTask:URLSessionDataTask?
        let sAllURL = url
        
        sessionDataTask = HTTPClient.sharedInstance.shareInstanceAFN().post(sAllURL, parameters: params, constructingBodyWith: { (formData) in
            
            var index = 0
            for obj in imgs {
                var data: Data?
                if obj is UIImage {
                    data = UIImageJPEGRepresentation(obj as! UIImage, 0.7)!
                }
                if obj is Data {
                    data = obj as? Data
                }
                if data == nil {continue}
                
                let name = "image[]"
                let fileName = "image\(index).jpg"
                formData.appendPart(withFileData: data!, name: name, fileName: fileName, mimeType: "image/jpeg")
                index += 1
            }
            }, progress: { (uploadProgress) in
                
            }, success: {[weak self] (task, responseObject) in
                let res = ResultInfo.convertPHPResponseToResultInfo(response: responseObject)
                closure(res)
                //网络请求-1
                self?.decreaseTaskCount()
                self?.delTaskId(httpName: httpName!)
            }) {[weak self] (task, error) in
                 let res = ResultInfo()
                if let task = task!.response as? HTTPURLResponse {
                    if task.statusCode == WebServiceStatusCode.pageNotFound {
                        // 页面没有找到
                        res.resultCode = -100
                        res.resultMessage = "没有找到页面"

                    } else {
                        // 服务器遇到错误
                        res.resultCode = -200
                        res.resultMessage = "服务器内部错误"
                    }
                } else {
                    // 取消
                    res.resultCode = -500
                    res.resultMessage = "网络异常"
                    if error.localizedDescription == "已取消"{
                        res.resultCode = -501
                        
                    }
                }
                //网络请求-1
                 closure(res)
                self?.decreaseTaskCount()
                self?.delTaskId(httpName: httpName!)
                Log("********网络请求分割线********\n POST请求失败：\(sAllURL) \n 错误提示：\(error) \n ********网络请求分割线********")
        }
        
        if httpName != nil {
            dicTask[httpName!] = sessionDataTask
        }
        // 网络请求+1
        increaseTaskCount()
        return sessionDataTask!
    }
    
    
    // MARK: - 取消网络请求
    /// 通过httpName取消单个网络请求
    static func cancelSigleTask(httpName: String) {
        HTTPClient.sharedInstance.cancelSigleTask(httpName: httpName)
    }
    
    /// 取消当前controller所有网络请求
    static func cancelSigleControllerTask(httpName: String) {
        HTTPClient.sharedInstance.cancelSigleControllerTask(httpName: httpName)
    }
    
    /// 取消所有网络请求
    static func cancelAllTask() {
        for obj in HTTPClient.sharedInstance.dicTask {
            HTTPClient.sharedInstance.cancelSigleTask(httpName: obj.key)
        }
    }
    
    // 取消网络请求，根据key删除字典dicTask里面的value
    private func cancelSigleTask(httpName: String) {
        for (k,v) in dicTask{
            Log("k是\(k)的请求会取消")
            if(k.hasPrefix(httpName)){
                v.cancel()
                Log("k是\(k)的请求已经取消")
                delTaskId(httpName: httpName)
            }
        }
//        if let task = dicTask[httpName] {
//            task.cancel()
//            delTaskId(httpName: httpName)
//           Log(message:"\(httpName) 已经成功取消")
//        }
    }
    
    // 取消当前class的所有网络请求
    private func cancelSigleControllerTask(httpName: String) {
        for (k,v) in dicTask{
            if k.hasPrefix(httpName){
                v.cancel()
                delTaskId(httpName: httpName)
//                Log(message:"\(httpName) 已经成功取消")
            }
        }
    }
    
    private func delTaskId(httpName: String?) {
        if httpName != nil {
            _ = dicTask.removeValue(forKey: httpName!)
//            if let value = dicTask.removeValue(forKey: httpName!) {
//                Log(message:"The value \(value) was removed.\(httpName)")
//            }
        }
    }
    
    /// 网络请求总数+1
    private func increaseTaskCount() {
        // 加线程安全?
        taskCount += 1
        toggleNetworkActivityIndicator()
    }
    
    /// 网络请求总数-1
    private func decreaseTaskCount() {
        // 加线程安全?
        taskCount -= 1
        toggleNetworkActivityIndicator()
    }
    
    /// 判断菊花转动
    private func toggleNetworkActivityIndicator() {
//        Log(message:"当前网络请求个数 = \(taskCount)")
        UIApplication.shared.isNetworkActivityIndicatorVisible = taskCount > 0
    }
    
}

extension NSObject{
    var httpTokenRandom:String{
        get{
            let token = "\(type(of:self))\(arc4random())"
//            Log(message:"httpTokenRandom = \(token)")
           return token
        }
    }
    
    var httpToken:String{
        get{
            return "\(type(of:self))"
        }
    }
}

