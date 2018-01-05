//
//  NSData+Base64.h
//  IOS-Categories
//
//  Created by Jakey on 15/1/26.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;

///加密
- (NSData *)AES256ParmEncryptWithKey:(NSString *)key;

///解密
- (NSData *)AES256ParmDecryptWithKey:(NSString *)key;


- (NSData *)encryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;
- (NSData *)decryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;

- (NSData *)encryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;
- (NSData *)decryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;

@end
