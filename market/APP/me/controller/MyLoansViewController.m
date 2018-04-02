//
//  MyLoansViewController.m
//  market
//
//  Created by Lipeng on 2017/8/20.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "MyLoansViewController.h"
#import "LoanTableViewCell.h"
#import "MasterMenu.h"
#import "LoanView.h"

#import "MeService.h"

@interface MyLoansViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic) UITableView *tableView;
@property(nonatomic,assign) NSInteger state;
@property(nonatomic,strong) LPCollection *loans;
@end

@implementation MyLoansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"我的贷款";
    _state=kLoan_State_All;
    _loans=[[MeService shared] loans:kLoan_State_All];
    [self loanBlocks];
    __weak typeof(self) wself=self;
    UIImage *img=[UIImage imageNamed:@"btn-filter"];
    [[self addRightNavigationImageButton:img] addActionBlock:^(UIButton *button) {
        MasterMenu *menu=(MasterMenu *)wself.navigationController.view.lp_av(MasterMenu.class,0,0,-1,-1);
        [menu setItems:@[@[@"",@"全部"],
                         @[@"",@"已申请"],
                         @[@"",@"已放款"],
                         @[@"",@"已逾期"]]];
        menu.block=^(NSInteger index){
            if (0==index){
                wself.state=kLoan_State_All;
            } else if (1==index){
                wself.state=kLoan_State_Apply;
            } else if (2==index){
                wself.state=kLoan_State_Loan;
            } else {
                wself.state=kLoan_State_Overdue;
            }
        };
    }];
    
    _tableView=LPAddPlainTableView(self.contentView,UITableView,NO,self.contentView.bounds);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self fetchState];
}
- (void)setState:(NSInteger)state
{
    if (state!=_state){
        _state=state;
        _loans=[[MeService shared] loans:state];
        [_tableView lp_reloadData];
        _tableView.mj_header=nil;
        _tableView.mj_footer=nil;
        [self loanBlocks];
        [self fetchState];
    }
}
- (void)fetchState
{
    if (kLoading_NA==_loans.state){
        if (0==_loans.items.count){
            _tableView.stateObject=[ViewStateObject initWithState:ViewState_Loading object:nil];
            [[MeService shared] firstLoans:_loans];
        } else {
            [self fetchBlocks];
        }
    } else if (kLoading_First==_loans.state){
        self.contentView.stateObject=[ViewStateObject initWithState:ViewState_Loading object:nil];
    } else if (kLoading_Refresh==_loans.state){
        [self fetchBlocks];
        [_tableView.mj_header beginRefreshing];
    } else if (kLoading_More==_loans.state){
        [self fetchBlocks];
        [_tableView.mj_footer beginRefreshing];
    }
}
- (void)loanBlocks
{
    __weak typeof(self) wself=self;
    _loans.first_block=^(BOOL result,NSInteger count,id echo,NSString *msg){
        wself.tableView.stateObject=[ViewStateObject initWithState:ViewState_Done object:nil];
        [wself fetchBlocks];
        [wself.tableView lp_reloadData];
    };
    _loans.refresh_block=^(BOOL result,NSInteger count,id echo,NSString *msg){
        [wself.tableView.mj_header endRefreshing];
        [wself fetchBlocks];
        [wself.tableView lp_reloadData];
    };
    _loans.more_block=^(BOOL result,NSInteger count,id echo,NSString *msg){
        [wself.tableView.mj_footer endRefreshing];
        [wself fetchBlocks];
        [wself.tableView lp_reloadData];
    };
    _loans.change_block=^(id echo){
        [wself.tableView lp_reloadData];
    };
}

- (void)fetchBlocks
{
    __weak typeof(self) wself=self;
    _tableView.mj_header=[MJRefreshGifHeader headerWithRefreshingBlock:^{
        [[MeService shared] refreshLoans:wself.loans];
    }];
    if (_loans.hasmore){
        _tableView.mj_footer=[MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            [[MeService shared] moreLoans:wself.loans];
        }];
    } else {
        _tableView.mj_footer=nil;
    }
}
- (Loan *)loanAtIndexPath:(NSIndexPath *)indexPath
{
    return _loans.items[indexPath.row];
}
#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _loans.items.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [LoanTableViewCell height];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    LoanTableViewCell *cell=LPMakeSubtitleStyleTableViewCell(tableView,LoanTableViewCell,identifier);
    cell.loan=[self loanAtIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) wself=self;
    __weak Loan *loan=[self loanAtIndexPath:indexPath];
    if (kLoan_State_Apply==loan.state){
        [[LPActionSheet sheetWithTitle:nil buttonTitles:@[@"联系客服",@"已经放款",@"已经拒绝"] completionBlock:^(NSUInteger buttonIndex){
            if (0==buttonIndex){
                
            } else if (1==buttonIndex){
                __weak LoanView *lv=(LoanView *)self.contentView.lp_av(LoanView.class,0,0,-1,-1);
                [lv setLoan:loan];
                void (^block)(void)=^{
                    [UIView animateWithDuration:.2f animations:^{
                        lv.transform=CGAffineTransformMakeTranslation(0,lv.h);
                    } completion:^(BOOL finished) {
                        [lv removeFromSuperview];
                    }];
                };
                lv.cancel_block=^{
                    block();
                };
                lv.done_block=^(NSInteger amount, NSDate *loanDate, NSDate *repayDate){
                    __weak LPLoadingView *loading=[LPLoadingView showAsModal];
                    [[MeService shared] loan:loan amount:amount loan_date:loanDate repay_date:repayDate block:^(BOOL result, NSString *msg) {
                        [loading stop:NO];
                        if (result){
                            [LPAlertView sure:msg block:^{
                                [wself.tableView lp_reloadData];
                                block();
                            }];
                        } else {
                            [LPAlertView know:msg block:nil];
                        }
                    }];
                };
                lv.transform=CGAffineTransformMakeTranslation(0,lv.h);
                [UIView animateWithDuration:.2f animations:^{
                    lv.transform=CGAffineTransformIdentity;
                }];
            } else if (2==buttonIndex){
                
            }
        }] showInView:self.view];
    } else if (kLoan_State_Loan==loan.state){
        [[LPActionSheet sheetWithTitle:nil buttonTitles:@[@"联系客服",@"已经还款"] completionBlock:^(NSUInteger buttonIndex){
            if (0==buttonIndex){
            } else if (1==buttonIndex){
            }
        }] showInView:self.view];
    } else if (kLoan_State_Repay==loan.state){
        [[LPActionSheet sheetWithTitle:nil buttonTitles:@[@"联系客服",@"续借"] completionBlock:^(NSUInteger buttonIndex){
            if (0==buttonIndex){
            } else if (1==buttonIndex){
            }
        }] showInView:self.view];
    } else if (kLoan_State_Overdue==loan.state){
        [[LPActionSheet sheetWithTitle:nil buttonTitles:@[@"联系客服",@"已经还款"] completionBlock:^(NSUInteger buttonIndex){
            if (0==buttonIndex){
            } else if (1==buttonIndex){
            }
        }] showInView:self.view];
    }
}
@end
