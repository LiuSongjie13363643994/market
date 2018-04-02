//
//  AIWebViewController.h
//  market
//
//  Created by Lipeng on 2017/8/18.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "AIUnTopViewController.h"
#import <WebKit/WebKit.h>

@interface AIWebViewController : AIUnTopViewController<WKNavigationDelegate>
@property(nonatomic,strong) NSString *url;
@property(nonatomic,readonly) WKWebView *wkWebview;
@property(nonatomic,copy) void (^done_block)(void);

- (void)initUserContentController:(WKUserContentController *)userContenrController;
- (void)webViewWillLoad;
- (void)webViewDidLoad;
- (void)startLoad;
@end
