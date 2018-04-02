//
//  LPKeybordMonitor.h
//  DU365
//
//  Created by Lipeng on 16/6/26.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import <Foundation/Foundation.h>
//键盘监听
@interface LPKeybordMonitor : NSObject
//开始键盘监听
- (void)startMointoring;
//停止键盘监听
- (void)stopMointoring;
//是否完全展示adjuster
@property(nonatomic) BOOL adjusterAllExpand;
- (void)adjust:(UIView *)adjuster with:(UIView *)responser;
- (void)hideKeybord;
@end
