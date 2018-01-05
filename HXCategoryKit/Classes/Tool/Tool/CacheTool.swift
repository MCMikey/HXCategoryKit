//
//  CacheTool.swift
//  jxdcl
//
//  Created by Mikey on 2017/7/6.
//  Copyright © 2017年 jxd. All rights reserved.
//

import UIKit

class CacheTool<T>{
    fileprivate var name:String!
    fileprivate var defaultValue:T?
    fileprivate var value:T?

    public  init(name:String,defaultValue:T) {
        self.name = name;
        self.defaultValue = defaultValue;
    }
    


}
