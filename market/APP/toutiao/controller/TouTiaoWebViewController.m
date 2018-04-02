//
//  TouTiaoWebViewController.m
//  market
//
//  Created by 刘松杰 on 2018/3/24.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "TouTiaoWebViewController.h"
#import "PersonInfoViewController.h"
#import "PPShareMenu.h"
#import "SysService.h"
@interface TouTiaoWebViewController ()

@end

@implementation TouTiaoWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    __weak typeof (self) wself = self;
//    [[self addRightNavigationTextButton:@"分享"] addActionBlock:^(UIButton *button) {
//        [wself checkLogin:^{
//            [PPShareMenu show:^(NSInteger platformtype, NSString *platformname) {
//                [wself shareContent:[SysService shared].configure.share.templet type:platformtype];
//            }];
//        }];
//    }];
}

- (void)shareContent:(NSString *)content type:(NSInteger)platformtype
{
    NSURL *url = nil;
    [[UIPasteboard generalPasteboard] setString:content];
    if (kPPShare_WX_TimeLine == platformtype || kPPShare_WX_Session == platformtype) {
        url = [NSURL URLWithString:@"weixin://"];
        [LPAlertView know:@"微信服务号已复制到剪切板" block:^{
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                if (success) {
                } else {
                    [LPAlertView know:@"您没有安装微信" block:^{
                    }];
                }
            }];
        }];
    } else {
        url = [NSURL URLWithString:@"mqq://"];
        [LPAlertView know:@"QQ服务号已复制到剪切板" block:^{
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                if (success) {
                } else {
                    [LPAlertView know:@"您没有安装QQ" block:^{
                    }];
                }
            }];
        }];
    }
}

@end
