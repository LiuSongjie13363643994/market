//
//  UIScrollView+LP.h
//  DU365
//
//  Created by Lipeng on 16/7/1.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView(LP)
@property(nonatomic,assign) CGPoint preContentOffset;
//强制停止滚动
- (void)stopScrolling;
- (UIImage *)snapshotY:(NSArray *)cgrects;
- (UIImage *)snapshotX:(NSArray *)cgrects;
@end
