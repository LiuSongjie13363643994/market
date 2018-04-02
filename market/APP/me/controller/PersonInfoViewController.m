//
//  PersonInfoViewController.m
//  market
//
//  Created by 刘松杰 on 2018/3/25.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "TailImageTableViewCell.h"
#import "TextInputTableViewCell.h"
#import "TailTextTableViewCell.h"

#import "UserService.h"
@interface PersonInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic) UITableView *tableView;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) User *user;
@property(nonatomic, strong) UserInfo *userInfo;
@property(nonatomic) TextInputTableViewCell *inputcell;
@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _user = [UserService shared].user;
    _userInfo = [UserService shared].user.user_info;
    _userInfo = _userInfo ? _userInfo : [[UserInfo alloc] init];
    self.title = @"个人信息";
    
    __weak typeof (self) wself = self;
    [[self addRightNavigationTextButton:@"保存"] addActionBlock:^(UIButton *button) {
        if ([wself isUserInfoUpdated]) {
            [[UserService shared] updateUserInfo:wself.userInfo block:^(BOOL result, NSString *msg) {
                [LPAlertView sure:msg block:nil];
            }];
        }
    }];
    
    _tableView=LPAddPlainTableView(self.contentView,UITableView,NO,self.contentView.bounds);
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (BOOL)isUserInfoUpdated
{
    _userInfo.header_url = nil;
    _userInfo.nick = _inputcell.textfield.text;
    if (0 == _userInfo.nick.length && 0 == _userInfo.sex) {
        return NO;
    } else {
        return YES;
    }
}

#pragma
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *xx[] = {@"昵称", @"性别"};
    UITableViewCell *cell = nil;
    if(0 == indexPath.row){
        static NSString *identifier = @"textinput_cell";
        cell = LPMakeDefaultStyleTableViewCell(tableView, TextInputTableViewCell, identifier);
        _inputcell = (TextInputTableViewCell *)cell;
    } else if(1 == indexPath.row){
        static NSString *identifier = @"tailText_cell";
        cell = LPMakeDefaultStyleTableViewCell(tableView, TailTextTableViewCell, identifier);
        ((TailTextTableViewCell *)cell).tailText = [UserService shared].user.user_info.sex;
    }
    cell.textLabel.text = xx[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof (self) wself = self;
    if(0 == indexPath.row) {
        
    } else if(1 == indexPath.row) {
        TailTextTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIAlertController *sheetVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *sheet0 = [UIAlertAction actionWithTitle:@"美女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            cell.tailText = @"美女";
            wself.userInfo.sex = @"美女";
        }];
        UIAlertAction *sheet1 = [UIAlertAction actionWithTitle:@"帅哥" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            cell.tailText = @"帅哥";
            wself.userInfo.sex = @"帅哥";
        }];
        UIAlertAction *sheet2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [sheetVC addAction:sheet0];
        [sheetVC addAction:sheet1];
        [sheetVC addAction:sheet2];
        [self presentViewController:sheetVC animated:YES completion:nil];
    }
}
@end
