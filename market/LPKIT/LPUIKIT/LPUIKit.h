//
//  LPUIKit.h
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#ifndef HR_LPUIKit_h
#define HR_LPUIKit_h

#define LP_X_GAP    (15)
#define LP_X_2GAP   (LP_X_GAP+LP_X_GAP)

#define LP_COL_GAP  (10)
//行间距
#define LP_ROW_SPACE_12 (6)

#define LP_Float_2(x) ceilf((x)/2)

#define LP_Screen_Width ([UIScreen mainScreen].bounds.size.width)
#define LP_Screen_Height ([UIScreen mainScreen].bounds.size.height)

#define iPhoneX ([UIScreen mainScreen].bounds.size.height == 812)   //是否是iPhoneX设备
#define TabBarHeight (iPhoneX ? 83 : 49)

#define LPColor(r,g,b,a) ((UIColor *)[UIColor colorWithRed:(float)(r)/255.0 green:(float)(g)/255.0 blue:(float)(b)/255.0 alpha:a])
#define LPFont(s)       [UIFont systemFontOfSize:(s)]
#define LPBoldFont(s)   [UIFont boldSystemFontOfSize:(s)]
#define LPFontHeight(s) ([UIFont systemFontOfSize:(s)].lineHeight)
#define LPBoldFontHeight(s) ([UIFont boldSystemFontOfSize:(s)].lineHeight)

#define LPWidthOfPx (1.f/[UIScreen mainScreen].scale)

#define LPPixOfDT(dt) ([UIScreen mainScreen].scale * dt)
//控件KEY
#define kRouterEventKey_Responder @"kRouterEventKey_Responder"
//信息KEY
#define kRouterKeyInformation @"kRouterKeyInformation"

#define kRouterEventKey2_Information @"kRouterEventKey2_Information"

#import "LPGeometry.h"
#import "UIViewController+LP.h"
#import "LPViewController.h"
#import "LPTopViewController.h"
#import "LPUnTopViewController.h"
#import "LPTabBarController.h"
#import "UINavigationController+LP.h"
#import "LPNavigationController.h"
#import "LPPictureScrollView.h"
#import "LPLoadingView.h"
#import "LPToastView.h"

#import "UIUtil.h"
#import "UIColor+LP.h"
#import "UITableView+LP.h"

#import "UITableViewCell+LP.h"
#import "UIGestureRecognizer+LP.h"
#import "UIScrollView+LP.h"


#import "UIView+LP.h"
#import "UILabel+LP.h"
#import "UIButton+LP.h"
#import "UITextView+LP.h"
#import "UIImage+LP.h"
#import "UITextField+LP.h"
#import "UIResponder+LP.h"
#import "MKMapView+LP.h"
#import "UIWebView+LP.h"
#import "UICollectionView+LP.h"

#import "LPActionSheet.h"
#import "LPAlertView.h"
#import "LPBGButton.h"
#import "LPAlertEditView.h"
#import "LPImageBrowerCollectionView.h"
#import "LPCollectionViewLayout.h"

#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "LPKeybordMonitor.h"
#import "LPVideoMaker.h"
#import "LPCollectionViewFlowLayout.h"
#import "LPImagePicker.h"
#import "UIView+Layout.h"
#import "LPUIProxy.h"
#import "UIView+ViewState.h"
#import "LPTopicBar.h"
#import "LPWaterViewLayout.h"

#endif
