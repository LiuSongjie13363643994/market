//
//  CheatWebViewController.m
//  market
//
//  Created by Lipeng on 2017/8/19.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "CheatWebViewController.h"
#import "CheatService.h"

@interface CheatWebViewController ()

@end

@implementation CheatWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=_cheat.title;
    [[CheatService shared] readCheat:_cheat];
}

- (void)setCheat:(Cheat *)cheat
{
    _cheat=cheat;
    self.url=cheat.cheat_url;
}
@end
