//
//  FindViewController.m
//  market
//
//  Created by 刘松杰 on 2018/3/24.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "FindViewController.h"
#import "SysService.h"
@interface FindViewController ()
@property(nonatomic) UIActivityIndicatorView *indicatorView;
@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
    
    WKWebViewConfiguration *cfg=[[WKWebViewConfiguration alloc] init];
    cfg.allowsInlineMediaPlayback=YES;
    cfg.mediaPlaybackRequiresUserAction=NO;

    _wkWebview=[[WKWebView alloc] initWithFrame:CGViewGetBounds(self.contentView) configuration:cfg];
    _wkWebview.navigationDelegate = self;
    _wkWebview.autoresizingMask=UIViewAutoresizingFlexibleHeight;

    [self.contentView addSubview:_wkWebview];
    _wkWebview.allowsLinkPreview=NO;
    [_wkWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[SysService shared].configure.fast_url]]];
    
    _indicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.contentView addSubview:_indicatorView];
    _indicatorView.lp_midx().lp_midy();
    [_indicatorView startAnimating];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    [_indicatorView stopAnimating];
    decisionHandler(WKNavigationActionPolicyAllow);
}



@end
