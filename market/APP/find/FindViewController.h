//
//  FindViewController.h
//  market
//
//  Created by 刘松杰 on 2018/3/24.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "AITopViewController.h"
#import <WebKit/WebKit.h>

@interface FindViewController : AITopViewController<WKNavigationDelegate>
@property(nonatomic,readonly) WKWebView *wkWebview;
@end
