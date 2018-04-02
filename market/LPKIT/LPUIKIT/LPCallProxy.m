//
//  LPCallProxy.m
//  MDT
//
//  Created by Lipeng on 15/11/28.
//  Copyright (c) 2015年 West. All rights reserved.
//

#import "LPCallProxy.h"

@implementation LPCallProxy
+ (void)callNumber:(NSString *)number onView:(UIView *)view
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", number]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [view addSubview:callWebview];
}
@end
