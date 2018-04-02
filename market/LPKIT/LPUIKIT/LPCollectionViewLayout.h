//
//  LPCollectionViewLayout.h
//  Beauty
//
//  Created by Lipeng on 2017/5/20.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPCollectionViewLayout;
@protocol LPCollectionViewLayoutDelegate <NSObject>
@required
- (CGFloat)waterLayout:(UICollectionViewLayout *)waterLayout itemWidth:(CGFloat)itemWidth indexPath:(NSIndexPath *)indexPath;
@optional
/** 行间距 */
- (CGFloat)rowIntervalInWaterFlowLayout:(UICollectionViewLayout *)layout;
/** 列间距 */
- (CGFloat)columnIntervalInWaterFlowLayout:(UICollectionViewLayout *)layout;
/** 列数 */
- (NSInteger)columnCountInWaterFlowLayout:(UICollectionViewLayout *)layout;
/** collectionView内边距 */
- (UIEdgeInsets)edgeInsetsInWaterFlowLayout:(UICollectionViewLayout *)layout;
@end

@interface LPCollectionViewLayout : UICollectionViewFlowLayout
@property(nonatomic,assign) id<LPCollectionViewLayoutDelegate> delegate;
@end
