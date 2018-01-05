//
//  NSString+Extension.m
//  wanjia
//
//  Created by Mikey on 2017/6/1.
//  Copyright © 2017年 Stan Hu. All rights reserved.
//

#import "NSString+Extension.h"
#import <CoreText/CoreText.h>

@implementation NSString(Extension)

/**
 *  获取每行的文字
 *
 *  @param text     文本内容
 *  @param font     字体
 *  @param maxWidth 容器的最大宽度
 *
 *  @return 存储每行文字的数组
 */

+ (NSArray *)getSeparatedLinesFromtext:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,maxWidth,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    CGPathRelease(path);
    CFRelease(frameSetter);
    CFRelease(myFont);
    CFRelease(frame);
    
    NSLog(@"输出lines = %lu", [lines count]);
    return (NSArray *)linesArray;
}

//判断是否含有Emoji表情
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue =NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800) {
            if (0xd800 <= hs && hs <= 0xdbff) {
                if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                    if (0x1d000 <= uc && uc <= 0x1f77f) {
                        returnValue =YES;
                    }
                }
            }else if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    returnValue =YES;
                }
            }else {
                // non surrogate
                if (0x2100 <= hs && hs <= 0x27ff) {
                    returnValue =YES;
                }else if (0x2B05 <= hs && hs <= 0x2b07) {
                    returnValue =YES;
                }else if (0x2934 <= hs && hs <= 0x2935) {
                    returnValue =YES;
                }else if (0x3297 <= hs && hs <= 0x3299) {
                    returnValue =YES;
                }else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                    returnValue =YES;
                }
            }
        }
    }];
    return returnValue;
}
//第三步：循环存储每行文字内容的数组，处理字符串

+ (NSMutableAttributedString *)changeLineSpacing:(NSArray *)stringList {
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] init];
    for (NSString *string in stringList) {
        //如果含有Emoji表情，不做处理
        if ([NSString stringContainsEmoji:string]) {
            NSMutableAttributedString *contentEmojistring = [[NSMutableAttributedString alloc] initWithString:string];
            [mutableString appendAttributedString:contentEmojistring];
        }else { //否则设置段落样式，行高为4（这个高度要根据自己的需求慢慢的试）
            NSMutableAttributedString *unContentEmojistring = [[NSMutableAttributedString alloc] initWithString:string];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 4;
            [unContentEmojistring addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [unContentEmojistring length])];
            [mutableString appendAttributedString:unContentEmojistring];
        }
    }
    return mutableString; //返回最后处理完成的字符串
}


@end
