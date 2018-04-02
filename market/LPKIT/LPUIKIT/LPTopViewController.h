//
//  LPTopViewController.h
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import "LPViewController.h"

@interface LPTopViewController : LPViewController
//tab索引
@property(nonatomic) NSInteger tabIndex;

//选中
- (void)singleTapOnTabBar:(BOOL)changed;
@end
