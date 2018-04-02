//
//  LPLoadingView.h
//  DU365
//
//  Created by Lipeng on 16/7/16.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPLoadingView : UIView
- (void)stop:(BOOL)animated;
+ (LPLoadingView *)show;
+ (LPLoadingView *)showAsModal;
+ (LPLoadingView *)showAsModal:(UIView *)view;
@end
