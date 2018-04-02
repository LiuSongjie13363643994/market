//
//  LPWebViewController.h
//  JamGo
//
//  Created by Lipeng on 2017/7/3.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "LPUnTopViewController.h"
#import <WebKit/WebKit.h>

@interface LPWebViewController : LPUnTopViewController<WKNavigationDelegate>
@property(nonatomic,strong) NSString *url;
@property(nonatomic,readonly) WKWebView *wkWebview;
@property(nonatomic,copy) void (^done_block)(void);

- (void)initUserContentController:(WKUserContentController *)userContenrController;
- (void)webViewWillLoad;
- (void)webViewDidLoad;

@end
