//
//  AboutViewController.m
//  market
//
//  Created by 刘松杰 on 2018/3/24.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutTableViewCell.h"

#import "UserService.h"
#import "SysService.h"
#import <UserNotifications/UserNotifications.h>

#define kLocalNotifiy_Time_key @"kLocalNotifiy_Time_key"

@interface AboutViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic) UITableView *tableView;
@property(nonatomic, strong) NSArray *rows;
@property(nonatomic, strong) NSArray *titles;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于";
    _titles = @[@"客服公众号", @"客服QQ号", @"上新提醒"];
    NSString *timeTip = LP_ReadUserDefault(kLocalNotifiy_Time_key);
    if (!timeTip) {
        timeTip = @"";
    }
    _rows = @[@"AI救急", @"3034563965", timeTip];
    
    _tableView = LPAddPlainTableView(self.contentView, UITableView, NO, self.contentView.bounds);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.headView;
    
    __weak typeof (self) wself = self;
    UIButton *exitBtn = (UIButton *)_tableView.lp_av(UIButton.class, 0, 0, self.contentView.w, 50);
    exitBtn.lp_midx().lp_iny1(0);
    exitBtn.backgroundColor = kColorffffff;
    [exitBtn setTitleFont:LPFont(18) color:[UIColor redColor] text:@"退出登录"];
    [exitBtn addActionBlock:^(UIButton *button) {
        UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"K头条" message:@"确定退出当前账户" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UserService shared] logout:^(BOOL result, NSString *msg) {
                [wself popupViewController];
            }];
        }];
        [avc addAction:cancel];
        [avc addAction:confirm];
        [wself presentViewController:avc animated:YES completion:nil];
    }];
    
    UILabel *la = (UILabel *)_tableView.lp_av(UILabel.class, 0, 0, self.contentView.w, LPFontHeight(15));
    [la setFont:LPFont(15) color:kColor717171 alignment:NSTextAlignmentCenter];
    la.lp_iny1(exitBtn.h + 10);
    la.text = [NSString stringWithFormat:@"V %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}

- (UIView *)headView
{
    UIView *v = (UIView *)self.contentView.lp_av(UIView.class, 0, 0, self.contentView.w, 200);
    UIImageView *iv = (UIImageView *)v.lp_av(UIImageView.class, 0, 30, 85, 85);
    [iv setImage:[UIImage imageNamed:@"app_icon"]];
    iv.lp_midx();
    iv.cornerRadius = iv.w/2;
    iv.backgroundColor = [UIColor redColor];
    
    UILabel *la = (UILabel *)v.lp_av(UILabel.class, 0, 0, v.w, LPFontHeight(15));
    [la setFont:LPFont(15) color:kColor717171 alignment:NSTextAlignmentCenter];
    la.lp_iny(iv.y2 + 15).lp_midx();
    la.text = @"更快的金融头条";
    return v;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    AboutTableViewCell *cell = LPMakeValue1StyleTableViewCell(tableView,AboutTableViewCell,identifier);
    cell.textLabel.text = _titles[indexPath.row];
    cell.tailText = _rows[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL * url = nil;
    if (0 == indexPath.row) {
        url = [NSURL URLWithString:@"weixin://"];
        [LPAlertView know:@"微信服务号已复制到剪切板" block:^{
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    [[UIPasteboard generalPasteboard] setString:@"AI救急"];
                } else {
                    [LPAlertView know:@"您没有安装微信" block:^{
                    }];
                }
            }];
        }];
    } else if (1 == indexPath.row) {
        url = [NSURL URLWithString:@"mqq://"];
        [LPAlertView know:@"QQ服务号已复制到剪切板" block:^{
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    [[UIPasteboard generalPasteboard] setString:@"3034563965"];
                } else {
                    [LPAlertView know:@"您没有安装QQ" block:^{
                    }];
                }
            }];
        }];
    } else if (2 == indexPath.row) {
        __weak typeof (self) wself = self;
        AboutTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIAlertController *sheet_vc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *sheet0 = [UIAlertAction actionWithTitle:@"早上8点" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            cell.tailText = @"早上8点";
            [wself registerLocalNotification:@"08:00:00"];
            LP_WriteUserDefault(kLocalNotifiy_Time_key, @"早上8点");
        }];
        UIAlertAction *sheet1 = [UIAlertAction actionWithTitle:@"早上9点" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            cell.tailText = @"早上9点";
            [wself registerLocalNotification:@"09:00:00"];
            LP_WriteUserDefault(kLocalNotifiy_Time_key, @"早上9点");
        }];
        UIAlertAction *sheet2 = [UIAlertAction actionWithTitle:@"早上10点" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            cell.tailText = @"早上10点";
            [wself registerLocalNotification:@"10:00:00"];
            LP_WriteUserDefault(kLocalNotifiy_Time_key, @"早上10点");
        }];
        UIAlertAction *sheet3 = [UIAlertAction actionWithTitle:@"不提醒" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            cell.tailText = @"不提醒";
            [self cancelAllLocalNotify];
            LP_WriteUserDefault(kLocalNotifiy_Time_key, @"不提醒");
        }];
        UIAlertAction *sheet4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [sheet_vc addAction:sheet0];
        [sheet_vc addAction:sheet1];
        [sheet_vc addAction:sheet2];
        [sheet_vc addAction:sheet3];
        [sheet_vc addAction:sheet4];
        [self presentViewController:sheet_vc animated:YES completion:nil];
    }
}


- (void)registerLocalNotification:(NSString *)timeSting{
    [self cancelAllLocalNotify];
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"K头条" arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:[SysService shared].configure.day_tip arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    
    //定时发送通知
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate *date = [formatter dateFromString:timeSting];
    NSCalendar *calender = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComponents = [calender components:kCFCalendarUnitHour | kCFCalendarUnitMinute | kCFCalendarUnitSecond fromDate:date];
    UNCalendarNotificationTrigger* trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:YES];

    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"ppIdentifier" content:content trigger:trigger];
    
    //添加通知到通知中心
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}

- (void)cancelAllLocalNotify
{
    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
}

@end
