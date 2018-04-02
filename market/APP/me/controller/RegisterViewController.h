//
//  RegisterViewController.h
//  market
//
//  Created by 刘松杰 on 2018/3/24.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "AIUnTopViewController.h"

@interface RegisterViewController : AIUnTopViewController
@property(nonatomic, copy) void (^loginBlock)(void);
@end
