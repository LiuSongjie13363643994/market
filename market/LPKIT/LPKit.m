//
//  LPKit.m
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import "LPKit.h"
#import <objc/runtime.h>

void SwizzleSelector(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod  = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}
@implementation LPKit
+ (NSString *)uuid
{
    LPKeychain *kc=[[LPKeychain alloc] init];
    NSString *uuidStr=[kc load:@"k_lp_udid_key"];
    if (0==uuidStr.length){
        CFUUIDRef udid = CFUUIDCreate(nil);
        uuidStr=(__bridge NSString*)CFUUIDCreateString(nil, udid);
        CFRelease(udid);
        [kc save:@"k_lp_udid_key" data:uuidStr];
    }
    return uuidStr;
}

+ (void)loadSwizzling
{
    [UINavigationController loadSwizzling];
    [UITableView loadSwizzling];
    [UITableViewCell loadSwizzling];
    [UILabel loadSwizzling];
    [UIViewController loadSwizzling];
    [UIWebView loadSwizzling];
    [MKMapView loadSwizzling];
    [UIView loadSwizzling];
}
@end
