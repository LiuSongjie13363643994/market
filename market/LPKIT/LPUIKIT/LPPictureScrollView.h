//
//  LPPictureScrollView.h
//  DU365
//
//  Created by Lipeng on 16/7/5.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPPictureScrollView;
typedef void (^pic_reach_block)(NSInteger preIndex, NSInteger currentIndex);
typedef BOOL (^pic_reach0_block)();

@interface LPPictureScrollView : UIScrollView
@property(nonatomic,strong) NSArray<NSString *>* imageURLs;
@property(nonatomic,copy) pic_reach_block reach_block;
@property(nonatomic,copy) pic_reach0_block reach0_block;
@property(nonatomic,readonly,assign) NSInteger currentIndex;
- (void)gotoPageAtIndex:(NSInteger)index;
@end
