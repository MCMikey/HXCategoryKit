//
//  NSString+Extension.h
//  wanjia
//
//  Created by Mikey on 2017/6/1.
//  Copyright © 2017年 Stan Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Extension)

/**
 *  获取每行的文字
 *
 *  @param text     文本内容
 *  @param font     字体
 *  @param maxWidth 容器的最大宽度
 *
 *  @return 存储每行文字的数组
 */

+ (NSArray *)getSeparatedLinesFromtext:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth;

//判断是否含有Emoji表情
+ (BOOL)stringContainsEmoji:(NSString *)string;

+ (NSMutableAttributedString *)changeLineSpacing:(NSArray *)stringList;

@end
