//
//  LPUIProxy.m
//  MrMood
//
//  Created by Lipeng on 2017/7/11.
//  Copyright © 2017年 Lipeng. All rights reserved.
//

#import "LPUIProxy.h"
@interface LPUIProxy()
@property(nonatomic,weak) UINavigationController *rootNavigationController;
@end

@implementation LPUIProxy
LP_SingleInstanceImpl(LPUIProxy)

- (void)setRootControllered:(BOOL)rootControllered
{
    _rootControllered = rootControllered;
    if (_rootControllered) {
        if (!_rootNavigationController) {
            _rootNavigationController = _navigationController;
        } else {
            _navigationController = _rootNavigationController;
        }
    }
}

@end
