//
//  AIWebViewController.m
//  market
//
//  Created by Lipeng on 2017/8/18.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "AIWebViewController.h"

@interface AIWebViewController ()

@end

@implementation AIWebViewController

- (void)dealloc
{
    [_wkWebview removeObserver:self forKeyPath:@"loading"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WKWebViewConfiguration *cfg=[[WKWebViewConfiguration alloc] init];
    cfg.allowsInlineMediaPlayback=YES;
    cfg.mediaPlaybackRequiresUserAction=NO;
    [self initUserContentController:cfg.userContentController];
    
    _wkWebview=[[WKWebView alloc] initWithFrame:CGViewGetBounds(self.contentView) configuration:cfg];
    _wkWebview.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    
    [self.contentView addSubview:_wkWebview];
    if ([_wkWebview respondsToSelector:@selector(setAllowsLinkPreview:)]){
        _wkWebview.allowsLinkPreview=NO;
    }
    [_wkWebview addObserver:self forKeyPath:@"loading" options:0 context:NULL];
    [self startLoad];
}

- (void)startLoad
{
    [_wkWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    if ([@"loading" isEqualToString:keyPath]) {
        if (_wkWebview.loading){
            [self webViewWillLoad];
        } else {
            [self webViewDidLoad];
        }
    }
}
- (void)initUserContentController:(WKUserContentController *)userContenrController
{
}
- (void)webViewWillLoad
{
    
}
- (void)webViewDidLoad
{
}
@end
