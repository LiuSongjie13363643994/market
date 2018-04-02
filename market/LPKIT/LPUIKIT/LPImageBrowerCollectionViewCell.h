//
//  LPImageBrowerCollectionViewCell.h
//  MrMood
//
//  Created by Lipeng on 16/9/14.
//  Copyright © 2016年 Lipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRouterEvent_ImageBrowerSingleTaped @"kRouterEvent_ImageBrowerSingleTaped"

@interface LPImageBrowerCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) NSURL *URL;
@property(nonatomic,assign) BOOL endBySingleTap;
@end
