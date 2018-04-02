//
//  LPImagePicker.h
//  Beauty
//
//  Created by Lipeng on 2017/6/3.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPImagePicker : NSObject
LP_SingleInstanceDec(LPImagePicker)
- (void)pick:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing block:(void (^)(UIImage *image))block;
@end
