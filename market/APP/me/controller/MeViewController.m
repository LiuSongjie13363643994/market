//
//  MeViewController.m
//  market
//
//  Created by Lipeng on 2017/8/26.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "MeViewController.h"
#import "AIWeb1ViewController.h"

#import "SysService.h"
#import "UserService.h"
#import <WebKit/WebKit.h>

@interface MeViewController ()
@end

@implementation MeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=[UserService shared].user.name;
    __weak typeof(self) wself=self;
    [[self addRightNavigationTextButton:@"积分规则"] addActionBlock:^(UIButton *button){
        AIWeb1ViewController *wvc=[[AIWeb1ViewController alloc] init];
        wvc.url=[SysService shared].configure.score_url;
        [wself pushViewController:wvc];
    }];
    UITableView *table=LPAddPlainTableView(self.contentView,UITableView,NO,self.contentView.bounds);
    table.tableHeaderView=self.headerView;
    table.tableFooterView=self.footerView;
}
- (UIView *)headerView
{
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0,0,LP_Screen_Width,self.contentView.h-49)];
    
    UIView *v1=v.lp_av(UIView.class,0,30,-1,104).lp_midx();
//    v1.layer.shadowColor=kColorff8606.CGColor;
//    v1.layer.shadowRadius=2;
//    v1.layer.shadowOffset=CGSizeZero;
//    v1.layer.shadowOpacity=0.8;
    
    UILabel *la=(UILabel *)v1.lp_av(UILabel.class,0,0,-1,-1);
//    [la asRoundStlye:kColorffffff6];
    [la setFont:LPBoldFont(34) color:kColore13f3c alignment:NSTextAlignmentCenter];
    la.attributedText=[NSAttributedString string:@[@"100",@"积分"]
                                          colors:@[kColore13f3c,kColorff8606]
                                           fonts:@[LPBoldFont(34),LPFont(14)]];
    
    UIButton *btn=(UIButton *)v.lp_av(UIButton.class,LP_X_GAP,v1.y2+30,v.w-LP_X_2GAP,44);
    [btn asRoundStlye:kColore13f3c];
    [btn setTitleFont:LPFont(17) color:kColorffffff text:@"兑换话费"];
    
    return v;
}
- (UIView *)footerView
{
    __weak typeof(self) wself=self;
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0,0,LP_Screen_Width,49)];
    btn.backgroundColor=kColorffffff;
    [btn drawTopLine:kColore8e8e8];
    [btn setTitleFont:LPFont(16) color:kColorff0000 text:@"退出登录"];
    [btn addActionBlock:^(UIButton *button) {
        [LPAlertView alertViewWithTitle:nil message:@"确实要退出当前账户？" completionBlock:^(NSUInteger buttonIndex) {
            if (1==buttonIndex) {
                __weak LPLoadingView *loadingview=[LPLoadingView showAsModal];
                [[UserService shared] logout:^(BOOL result, NSString *msg) {
                    [loadingview stop:NO];
                    [wself popupViewController];
                }];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"现在退出",nil];
    }];
    return btn;
}
@end
