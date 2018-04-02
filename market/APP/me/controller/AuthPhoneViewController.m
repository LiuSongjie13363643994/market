//
//  AuthPhoneViewController.m
//  market
//
//  Created by Lipeng on 2017/8/20.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "AuthPhoneViewController.h"
#import "AuthTableViewCell.h"
#import "GradeView.h"

#import "AuthService.h"

enum{
    Auth_PhoneBook,
    Auth_Location
};
@interface AuthPhoneViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic) UITableView *tableView;
@property(nonatomic,strong) NSArray *rows;
@end

@implementation AuthPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"本机授权";
    
    if (_grade){
        __weak typeof(self) wself=self;
        [[self addRightNavigationTextButton:@"去评级"] addActionBlock:^(UIButton *button){
            __weak LPLoadingView *loading=[LPLoadingView showAsModal];
            [[AuthService shared] grade:^(BOOL result, GradeLevel *grade, NSString *msg) {
                [loading stop:NO];
                if (!result){
                    [LPAlertView know:msg block:nil];
                } else {
                    GradeView *gv=(GradeView *)wself.contentView.lp_av(GradeView.class,0,0,-1,-1);
                    gv.grade=grade;
                }
            }];
        }];
    }
    
    _rows=@[@[@"通讯录授权",@"请授权",@(Auth_PhoneBook)],
            @[@"获取位置授权",@"请授权",@(Auth_Location)]];
    
    _tableView=LPAddPlainTableView(self.contentView,UITableView,NO,self.contentView.bounds);
    _tableView.dataSource=self;
    _tableView.delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rows.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AuthTableViewCell height];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    NSArray *row=_rows[indexPath.row];
    AuthTableViewCell *cell=LPMakeValue1StyleTableViewCell(tableView,AuthTableViewCell,identifier);
    cell.check_state=kCheckState_NA;
    cell.textLabel.text=row[0];
    cell.detailTextLabel.text=row[1];
    if (0==indexPath.row){
        cell.detailTextLabel.text=[LPAuthProxy shared].isABAddressBookAuthed?@"已授权":@"请授权";
    } else {
        cell.detailTextLabel.text=[LPAuthProxy shared].isLocationAuthed?@"已授权":@"请授权";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) wself=self;
    if (0==indexPath.row){
        __weak LPLoadingView *loading=[LPLoadingView showAsModal];
        [[LPAuthProxy shared] authABAddressBook:^(BOOL ready) {
            [loading stop:NO];
            [wself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];            
            if (ready){
                [LPAlertView sure:@"您已授权全网速贷访问您的通讯录信息！" block:nil];
            }
        }];
    } else {
        __weak LPLoadingView *loading=[LPLoadingView showAsModal];
        [[LPLocationManager shared] start:@"xx"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [loading stop:NO];
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            if ([LPAuthProxy shared].isLocationAuthed){
                [LPAlertView sure:@"您已授权全网速贷访问您的位置信息！" block:nil];
            }
        });
    }
}
@end
