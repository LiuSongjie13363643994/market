//
//  PPShareButton.h
//  ppablum
//
//  Created by Lipeng on 2018/1/2.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPShareButton : UIButton
@property(nonatomic, strong, readonly) NSString *text;
- (void)setImage:(UIImage *)image text:(NSString *)text;
+ (CGSize)size;
@end
