//
//  ApplyView.h
//  market
//
//  Created by Lipeng on 2017/8/25.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyView : UIView
@property(nonatomic,copy) void (^cancel_block)(void);
@property(nonatomic,copy) void (^done_block)(NSInteger amount);
@end
