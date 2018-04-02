//
//  TopicButton.h
//  PPAlbum
//
//  Created by Lipeng on 2017/10/24.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopicObject<NSObject>
- (NSString *)code;
- (NSString *)title;
@end

extern const NSString *kNotifySetTopicBadge;
extern const NSString *kNotifyClearTopicBadge;

@interface TopicStyle : NSObject
@property(nonatomic, strong) UIColor *lineColor;
@property(nonatomic, strong) UIColor *normalColor;
@property(nonatomic, strong) UIFont *normalFont;

@property(nonatomic, strong) UIColor *selectedColor;
@property(nonatomic, strong) UIFont *selectedFont;
@end

@interface TopicButton : UIButton
@property(nonatomic, strong) id<TopicObject> topic;
@property(nonatomic, strong) TopicStyle * style;
@end
