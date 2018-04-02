//
//  LPToastView.h
//  DU365
//
//  Created by Lipeng on 16/7/4.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger){
    kToastState_YES=0,
    kToastState_NO,
    kToastState_T,
}ToastState;

//toast view
@interface LPToastView : UIView
+ (void)toast:(ToastState)state text:(NSString *)text;
+ (void)toastBottomText:(NSString *)text;
+ (void)toastCenterText:(NSString *)text;
@end
