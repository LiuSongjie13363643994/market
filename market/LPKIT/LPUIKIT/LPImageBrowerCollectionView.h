//
//  LPImageBrowerCollectionView.h
//  MrMood
//
//  Created by Lipeng on 16/9/14.
//  Copyright © 2016年 Lipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LPImageBrowerCollectionViewCell.h"

@interface LPImageBrowerCollectionView : UICollectionView
//
@property(nonatomic,strong) NSArray<NSURL *> *imageURLs;
@property(nonatomic,copy) void (^reached_block)(NSInteger index,CGFloat scale);
@property(nonatomic,assign) NSInteger currentIndex;
//是否吸收左滑手势
@property(nonatomic,assign) BOOL receiveGesture;
@property(nonatomic,assign) BOOL endBySingleTap;
@end
