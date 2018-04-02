//
//  LPTopicBar.h
//  PPAlbum
//
//  Created by Lipeng on 2017/10/24.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicButton.h"

@interface LPTopicBar : UIScrollView

@property(nonatomic, strong) TopicStyle *style;
@property(nonatomic, strong) NSArray<id<TopicObject>> *topics;
@property(nonatomic, copy) BOOL (^selected_block)(NSInteger index,BOOL changed);
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, strong, readonly) id<TopicObject> topic;

- (void)offset:(NSInteger)index scale:(CGFloat)offset;

@end
