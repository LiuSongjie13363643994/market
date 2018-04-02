//
//  main.m
//  market
//
//  Created by Lipeng on 2017/8/17.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LPViewController+AI.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [LPKit loadSwizzling];
        [LPViewController loadSwizzling];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
