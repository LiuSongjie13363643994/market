//
//  LPUIProxy.h
//  MrMood
//
//  Created by Lipeng on 2017/7/11.
//  Copyright © 2017年 Lipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPUIProxy : NSObject
LP_SingleInstanceDec(LPUIProxy)
@property(nonatomic, weak) UINavigationController *navigationController;
@property(nonatomic, assign) BOOL rootControllered;
@end
