//
//  MeTopViewController.m
//  market
//
//  Created by Lipeng on 2017/8/18.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "MeTopViewController.h"
#import "AuthBaseViewController.h"
#import "AuthPhoneViewController.h"
#import "MyLoansViewController.h"
#import "MyFavsViewController.h"
#import "IconViewController.h"
#import "MeViewController.h"
#import "AIWeb1ViewController.h"
#import "AboutViewController.h"
#import "PersonInfoViewController.h"
#import "ScoreStoreViewController.h"

#import "MeTableViewCell.h"
#import "LoginView.h"

#import "UserService.h"
#import "SysService.h"

enum{
    Row_User_Info,
    Row_Phone_Auth,
    Row_My_Loan,
    Row_My_Fav,
    Row_Day_Check,
    Row_About
};
@interface MeTopViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic) UIView *headerView;
@property(nonatomic) UITableView *tableView;
@property(nonatomic) NSArray *rows;
@property(nonatomic, assign) int productType;
@end

@implementation MeTopViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView lp_reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _productType = [SysService shared].configure.project;
    [self hideNavigationBar];
    if (0 == _productType) {
        _rows=@[@[@"ic-me-info",@"个人资料",@"根据所填资料推荐合适的产品",@(Row_User_Info)],
                @[@"ic-me-phone",@"本机授权",@"本机授权是发放贷款基本条件",@(Row_Phone_Auth)],
                @[@"ic-me-man",@"我的贷款",@"反馈贷款情况可以积分兑话费",@(Row_My_Loan)],
                @[@"ic-me-fav",@"我的收藏",@"",@(Row_My_Fav)],
                @[@"ic-me-check",@"每日签到",@"每日签到积1分",@(Row_Day_Check)],
                //            @[@"ic-me-kefu",@"联系客服",@""],
                @[@"ic-me-about",@"关于",@"",@(Row_About)]
                ];
    } else {
        _rows=@[@[@"ic-me-info",@"个人信息",@"",@(Row_User_Info)],
                @[@"ic-me-check",@"每日签到",@"每日签到积1分",@(Row_Day_Check)],
                @[@"ic-me-about",@"关于",@"",@(Row_About)]
                ];
    }

    [self.contentView addSubview:self.headerView];
    _tableView=LPAddPlainTableView(self.contentView,UITableView,NO,self.contentView.bounds);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.lp_iny(self.headerView.y2);
    _tableView.lp_h(_tableView.h-self.headerView.h);
    
    LP_AddObserver(kNotifyUserLogined,self,@selector(onLogin:));
    LP_AddObserver(kNotifyUserUpdated,self,@selector(onUpdate:));
    LP_AddObserver(kNotifyUserLogouted,self,@selector(onLogout:));
}

- (void)onLogin:(id)notify
{
    [self.headerView removeFromSuperview];
    self.headerView=nil;
    [self.contentView addSubview:self.headerView];
    [self.tableView reloadData];
}

- (void)onUpdate:(id)notify
{
    [self.headerView removeFromSuperview];
    self.headerView=nil;
    [self.contentView addSubview:self.headerView];
}

- (void)onLogout:(id)notify
{
    [self.headerView removeFromSuperview];
    self.headerView=nil;
    [self.contentView addSubview:self.headerView];
    [self.tableView reloadData];
}

- (UIView *)headerView
{
    if (nil==_headerView){
        UIButton *v=[[UIButton alloc] initWithFrame:CGRectMake(0,0,LP_Screen_Width,120)];
        v.backgroundColor=kColore13f3c;
        CGFloat gw=v.w/4;
        for (int i=0;i<4;i++){
            CGFloat w=20+(arc4random()%40),x=gw*i+(arc4random()%(int)gw),y=(arc4random()%(int)v.h);
            UIImage *img=[[UIImage imageNamed:@"ic-money"] thumbImage:CGSizeMake(w,w)];
            CALayer *layer=[CALayer layer];
            layer.frame=CGRectMake(0,0,w,w);
            layer.position=CGPointMake(x,y);
            layer.contents=(__bridge id)img.CGImage;
            layer.opacity=.1;
            layer.affineTransform=CGAffineTransformMakeRotation(arc4random());
            [v.layer addSublayer:layer];
        }
        
        NSString *register_tip = [SysService shared].configure.register_tip;
        UILabel *la=(UILabel *)v.lp_av(UILabel.class,LP_X_GAP,20,v.w-LP_X_2GAP,100);
        la.numberOfLines=0;
        if (![UserService shared].logined){
            la.attributedText=[NSAttributedString string:@[@"登录",@"\n\n",register_tip]
                                                  colors:@[kColorffffff9,kColorffffff8,kColorffffff8]
                                                   fonts:@[LPFont(20),LPFont(5),LPFont(14)] alignment:NSTextAlignmentLeft lineHeight:0 breakMode:NSLineBreakByWordWrapping];
        } else {
            User *user=[UserService shared].user;
            if (user.name.length>0){
                NSString *level=user.level;
                if (nil==user.level) {
                    level=@" ";
                } else {
                    level=[NSString stringWithFormat:@" %@级",user.level];
                }
                NSString *score=[NSString stringWithFormat:@"%@积分，积分可兑话费",@(user.score)];
                la.attributedText=[NSAttributedString string:@[user.name,level,@"\n\n",score]
                                                      colors:@[kColorffffff9,kColorff8606,kColorffffff8,kColorffffff8]
                                                       fonts:@[LPFont(20),LPBoldFont(14),LPFont(5),LPFont(14)] alignment:NSTextAlignmentLeft lineHeight:0 breakMode:NSLineBreakByWordWrapping];
            } else {
                la.attributedText=[NSAttributedString string:@[user.mobile,@"\n\n",register_tip]
                                                      colors:@[kColorffffff9,kColorffffff8,kColorffffff8]
                                                       fonts:@[LPFont(20),LPFont(5),LPFont(14)] alignment:NSTextAlignmentLeft lineHeight:0 breakMode:NSLineBreakByWordWrapping];
            }
        }
        __weak typeof (self) wself = self;
        UIButton *btn=(UIButton *)v.lp_av(UIButton.class,0,20,0,44);
        btn.fitWidth=YES;
        [btn setTitleFont:LPFont(14) color:kColorffffff text:@"积分商城"];
        btn.lp_inx1(LP_X_GAP);
        [btn addActionBlock:^(UIButton *button) {
//            AIWeb1ViewController *wvc=[[AIWeb1ViewController alloc] init];
//            wvc.url=[SysService shared].configure.score_url;
//            [self pushViewController:wvc];
            ScoreStoreViewController *svc = [[ScoreStoreViewController alloc] init];
            [wself pushViewController:svc];
        }];
        
        [v addActionBlock:^(UIButton *button) {
            [wself instantCheckLogin:^{
                if (0 == wself.productType) {
                    [wself checkAuthed:^{
                        [wself pushViewController:[[MeViewController alloc] init]];
                    }];
                } else {
                    [wself pushViewController:[[PersonInfoViewController alloc] init]];
                }
            }];
        }];
        _headerView=v;
    }
    return _headerView;
}
- (BOOL)hasTodayCheckedIn
{
    NSDate *today=[NSDate date];
    NSDate *date=[UserService shared].user.last_checkin_date;
    return (nil!=date && date.year==today.year && date.month==today.month && date.day==today.day);
}
#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rows.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MeTableViewCell height];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    NSArray *row=_rows[indexPath.row];
    MeTableViewCell *cell=LPMakeSubtitleStyleTableViewCell(tableView,MeTableViewCell,identifier);
    cell.imageView.image=[UIImage imageNamed:row[0]];
    cell.textLabel.text=row[1];
    cell.detailTextLabel.text=row[2];
    switch ([row[3] integerValue]) {
        case Row_User_Info:{
            cell.check_state=[UserService shared].user.name.length>0?kCheckState_YES:kCheckState_No;
        }break;
        case Row_Phone_Auth:{
            cell.check_state=([LPAuthProxy shared].isABAddressBookAuthed && [LPAuthProxy shared].isLocationAuthed)?kCheckState_YES:kCheckState_No;
        }break;
        case Row_Day_Check:{
            cell.check_state=[self hasTodayCheckedIn]?kCheckState_YES:kCheckState_No;
        }break;
        default:{
            cell.check_state=kCheckState_NA;
        }break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) wself=self;
    NSArray *row=_rows[indexPath.row];
    switch ([row[3] integerValue]) {
        case Row_User_Info:
        {
            [self instantCheckLogin:^{
                if (0 == wself.productType) {
                    [wself pushViewController:[[AuthBaseViewController alloc] init]];
                } else {
                    [wself pushViewController:[[PersonInfoViewController alloc] init]];
                }
            }];
        }break;
        case Row_Phone_Auth:
        {
            [self instantCheckLogin:^{
                [wself pushViewController:[[AuthPhoneViewController alloc] init]];
            }];
        }break;
        case Row_My_Loan:
        {
            [self instantCheckLogin:^{
                [wself checkAuthed:^{
                    [wself pushViewController:[[MyLoansViewController alloc] init]];
                }];
            }];
        }break;
        case Row_My_Fav:
        {
            [self instantCheckLogin:^{
                if (0 == wself.productType) {
                    [wself checkAuthed:^{
                        [self pushViewController:[[MyFavsViewController alloc] init]];
                    }];
                }
            }];
        }break;
        case Row_Day_Check:{
            [self instantCheckLogin:^{
                if (0 == _productType) {
                    [wself checkAuthed:^{
                        if ([self hasTodayCheckedIn]){
                        } else {
                            __weak LPLoadingView *loading=[LPLoadingView showAsModal];
                            [[UserService shared] checkIn:^(BOOL result, NSString *msg) {
                                [loading stop:NO];
                                if (result){
                                    [wself.tableView lp_reloadData];
                                    [LPAlertView sure:msg block:nil];
                                } else {
                                    [LPAlertView know:msg block:nil];
                                }
                            }];
                        }
                    }];
                } else {
                    if ([self hasTodayCheckedIn]){
                    } else {
                        __weak LPLoadingView *loading=[LPLoadingView showAsModal];
                        [[UserService shared] checkIn:^(BOOL result, NSString *msg) {
                            [loading stop:NO];
                            if (result){
                                [wself.tableView lp_reloadData];
                                [LPAlertView sure:msg block:nil];
                            } else {
                                [LPAlertView know:msg block:nil];
                            }
                        }];
                    }
                }
            }];
        }break;
        case Row_About:{
            [self pushViewController:[[AboutViewController alloc] init]];
        }
        default:{
            
        }break;
    }
}
@end
