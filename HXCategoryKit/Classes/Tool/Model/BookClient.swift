//
//  BookClient.swift
//  boring
//
//  Created by Mikey on 2018/1/3.
//  Copyright © 2018年 bbj. All rights reserved.
//

import UIKit

class BookInfo: GrandModel {
    
    var bookThumb = ""
    
    var bookName = ""
    
    var bookIntro = ""
    
    var bookAuthor = ""
    
    var bookUpdateTime = ""
    
    var bookChapterUrl = ""
    
    var bookChapterName = ""
    
    var bookChapterDetailUrl = ""
    
    /// 上一章
    var bookLastChapterUrl = ""
    
    /// 下一章
    var bookNextChapterUrl = ""
    
    var bookChapterContent = ""
    
    
    var cellHeight: CGFloat = 0
    
}

class BookClient: GrandModel {
    

    // 搜索url
    func getSearchUrl(name: String, p: Int)-> String {
        return ""
    }
    
    // 搜索列表
    func getSearchMapper(url: String) {
        
    }
    
    // 章节目录
    func getChapterMapper(url: String) {
        
    }
    
    // 获取内容
    func getContentMapper(url: String) {
        
    }
}

// 笔趣岛
class ApiBiqudao: GrandModel {
    
    // 搜索url
    static func getSearchUrl(name: String, p: Int)-> String {
        let url = "http://zhannei.baidu.com/cse/search?s=3654077655350271938&q=\(name)&p=\(p)"
        return url
    }
    
    // 搜索列表
    static func getSearchMapper(name: String, p: Int, complete:@escaping completed) {
        //https://www.zwdu.com/search.php?keyword=%E5%A4%A7
        let url = "https://www.zwdu.com/search.php?keyword=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&page=\(p)"
        HTTPClient.getNor(url: url, httpName: "") { (result) in
            
            if let data = result.resultContent as? Data {
                
                let html = TFHpple(htmlData: data)
                
                var arrBook = [BookInfo]()
                
                //  //div[@class='result-list']
                if let arr = html?.search(withXPathQuery: "//div[@class='result-item result-game-item']") as? [TFHppleElement] {
                    
                    for ele in arr {
                        let info = BookInfo()
                        
                        if let chapter = ele.search(withXPathQuery: "//div[@class='result-game-item-pic']//a") as? [TFHppleElement] {
                            //Log("标题 = \(tits[0].content)")
                            if let s = chapter[0].object(forKey: "href") {
                                info.bookChapterUrl = s
                            }
                        }
                        
                        if let thumb = ele.search(withXPathQuery: "//div[@class='result-game-item-pic']//img") as? [TFHppleElement] {
                            //Log("标题 = \(tits[0].content)")
                            if let s = thumb[0].attributes["src"] as? String {
                                info.bookThumb = s
                            }
                        }
                        
                        ////h3[@class='result-item-title result-game-item-title']
                        if let tits = ele.search(withXPathQuery: "//div[@class='result-game-item-detail']//h3") as? [TFHppleElement] {
                            //Log("标题 = \(tits[0].content)")
                            info.bookName = tits[0].content
                        }
                        
                        if let intros = ele.search(withXPathQuery: "//div[@class='result-game-item-detail']//p") as? [TFHppleElement] {
                            //Log("标题 = \(tits[0].content)")
                            info.bookIntro = intros[0].content
                        }
                        
                        if let author = ele.search(withXPathQuery: "//div[@class='result-game-item-detail']//div//p") as? [TFHppleElement] {
                            //Log("标题 = \(tits[0].content)")
                            if author.count > 0 {
                                info.bookAuthor = author[0].content
                            }
                        }
                        
                        info.bookName = info.bookName.replacingOccurrencesOfString(" ", withString: "").replacingOccurrencesOfString("\r\n", withString: "")
                        
                        info.bookIntro = info.bookIntro.replacingOccurrencesOfString(" ", withString: "").replacingOccurrencesOfString("\r\n", withString: "")
                        
                        info.bookAuthor = info.bookAuthor.replacingOccurrencesOfString(" ", withString: "").replacingOccurrencesOfString("\r\n", withString: "")
                        arrBook.append(info)

                    }
                }
                
                result.resultContent = arrBook as AnyObject
                complete(result)
            }
        }
    }
    
    // 章节目录
    static func getChapterMapper(url: String, complete:@escaping completed) {
        
        HTTPClient.getNor(url: url, httpName: "") { (result) in
            if let data = result.resultContent as? Data {
                
                let html = TFHpple(htmlData: data)
                
                if let arr = html?.search(withXPathQuery: "//div[@id='list']") as? [TFHppleElement] {
                    if arr.count > 0 {
                        
                        var arrChapter = [BookInfo]()
                        if let chapters = arr[0].search(withXPathQuery: "//dd//a") as? [TFHppleElement] {
                            for c in chapters {
                                let info = BookInfo()
                                info.bookChapterName = c.content
                                info.bookChapterDetailUrl = c.object(forKey: "href")
                                
                                arrChapter.append(info)
                            }
                        }
                        
                        
                        result.resultContent = arrChapter as AnyObject
                        complete(result)
                    }
                }
            }
        }
    }
    
    // 获取内容
    static func getContentMapper(url: String, complete:@escaping completed) {
            
            HTTPClient.getNor(url: "https://www.zwdu.com\(url)", httpName: "") { (result) in
                if let data = result.resultContent as? Data {
                    
                    let html = TFHpple(htmlData: data)
                    
                    let info = BookInfo()
                    
                    if let arr = html?.search(withXPathQuery: "//div[@class='bookname']//h1") as? [TFHppleElement] {
                        if arr.count > 0 {
                            info.bookChapterName = arr[0].content
                        
                        }
                    }
                    
                    if let arr = html?.search(withXPathQuery: "//div[@class='bottem2']") as? [TFHppleElement] {
                        if arr.count > 0 {
                            if let chapters = arr[0].search(withXPathQuery: "//a") as? [TFHppleElement] {
                                for c in chapters {
                                    if c.content.contain(subStr: "上") {
                                        info.bookLastChapterUrl = c.object(forKey: "href")
                                    }
                                    
                                    if c.content.contain(subStr: "下") {
                                        info.bookNextChapterUrl = c.object(forKey: "href")
                                    }
                                }
                            }
                            
                        }
                    }
                    
                    if let arr = html?.search(withXPathQuery: "//div[@id='content']") as? [TFHppleElement] {
                        if arr.count > 0 {
                            info.bookChapterContent = arr[0].raw
                            info.bookChapterContent = info.bookChapterContent.replacingOccurrencesOfString("<br />", withString: "\r")
                            info.bookChapterContent = info.bookChapterContent.replacingOccurrencesOfString("<div id=\"content\">", withString: "").replacingOccurrencesOfString("</div>", withString: "")
                            
                        }
                    }
                    
                    result.resultContent = info
                    complete(result)
                }
            }
        }
    
}
