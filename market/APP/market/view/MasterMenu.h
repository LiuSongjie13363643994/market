//
//  MasterMenu.h
//  market
//
//  Created by Lipeng on 2017/8/20.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterMenu : UIView
- (void)setItems:(NSArray<NSArray *> *)items;
@property(nonatomic,copy) void (^block)(NSInteger index);
@end
