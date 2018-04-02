//
//  NSData+LP.m
//  PPAlbum
//
//  Created by Lipeng on 2017/10/26.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "NSData+LP.h"
#import "NSString+LP.h"
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

@implementation NSData(LP)
- (NSString*)MD5String
{
    return [[self base64EncodedStringWithOptions:0] MD5String:NSUTF8StringEncoding];
}
@end
