//
//  LPVideoMaker.h
//  MrMood
//
//  Created by Lipeng on 16/9/20.
//  Copyright © 2016年 Lipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
//录制屏幕
@interface LPVideoMaker : NSObject
LP_SingleInstanceDec(LPVideoMaker)
@property(nonatomic) __weak UIView *view;
- (void)start;
- (void)stop;
@end
