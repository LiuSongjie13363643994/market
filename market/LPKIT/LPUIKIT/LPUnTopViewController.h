//
//  LPUnTopViewController.h
//  MDT
//
//  Created by Lipeng on 15/11/24.
//  Copyright (c) 2015年 West. All rights reserved.
//

#import "LPViewController.h"

@interface LPUnTopViewController : LPViewController
@property(nonatomic) UIButton *backButton;
- (BOOL)invokeBeforePopup;
- (void)onBack:(id)sender;
@end
