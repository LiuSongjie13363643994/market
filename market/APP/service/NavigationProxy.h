//
//  NavigationProxy.h
//  market
//
//  Created by Lipeng on 2017/8/19.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavigationProxy : NSObject
LP_SingleInstanceDec(NavigationProxy)
@property(nonatomic,strong) UINavigationController *navigationController;
@end
