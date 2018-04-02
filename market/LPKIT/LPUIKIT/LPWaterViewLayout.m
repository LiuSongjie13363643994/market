//
//  LPWaterViewLayout.m
//  PPAlbum
//
//  Created by Lipeng on 2017/11/1.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "LPWaterViewLayout.h"

/** 默认的列数 */
static const NSInteger kZYDefaultColumnCount = 2;
/** 每一列之间的间距 */
static const CGFloat kZYDefaultColumnInterval = 10;
/** 每一行之间的间距 */
static const CGFloat kZYDefaultRowInterval  = 10;
/** 边缘间距 */
static const UIEdgeInsets kZYDsfultEdgeInsets = { 10 ,10 , 10 , 10};

@interface LPWaterViewLayout ()
/** 存放所有cell的布局属性 */
@property (nonatomic , strong)NSMutableArray *attrsArray;
/** 存放所有列的当前高度 */
@property (nonatomic , strong)NSMutableArray *columnHeights;
/** 内容的高度 */
@property (nonatomic , assign)CGFloat contentHeight;

@end

@implementation LPWaterViewLayout
/** 行间隔 */
- (CGFloat)rowInterval
{
    if ([self.delegate respondsToSelector:@selector(rowIntervalInWaterFlowLayout:)]) {
        return [self.delegate rowIntervalInWaterFlowLayout:self];
    }else {
        return kZYDefaultRowInterval;
    }
}
/** 列间隔 */
- (CGFloat)columnInterval
{
    if ([self.delegate respondsToSelector:@selector(columnIntervalInWaterFlowLayout:)]) {
        return [self.delegate columnIntervalInWaterFlowLayout:self];
    }else {
        return kZYDefaultColumnInterval;
    }
}
/** 列数 */
- (NSInteger)columCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterFlowLayout:)]) {
        return  [self.delegate columnCountInWaterFlowLayout:self];
    }else {
        return kZYDefaultColumnCount;
    }
}
/** 边缘间隔 */
- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterFlowLayout:)]) {
        return [self.delegate edgeInsetsInWaterFlowLayout:self];
    }else {
        return kZYDsfultEdgeInsets;
    }
}
- (NSMutableArray *)columnHeights
{
    if (nil == _columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}
- (NSMutableArray *)attrsArray
{
    if (nil == _attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}
/** 初始化 */
- (void)prepareLayout
{
    [super prepareLayout];
    self.contentHeight = 0.f;
    //清除以前计算的所有高度
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < [self columCount]; i ++) {
        //重新布局 , 给出默认的高度
        [self.columnHeights addObject:@(self.headerReferenceSize.height)];
    }
    //清除之前的所有布局属性
    [self.attrsArray removeAllObjects];
    UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self.attrsArray addObject:attrs];
    //开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0 ; i < count; i ++) {
        //创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        //获取indexPath位置cell对应的布局属性
        attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}
//决定cell的布局
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}
//返回indexPath位置cell对应的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    //设置布局属性的frame
    CGFloat width = (collectionViewW - self.edgeInsets.left - [self edgeInsets].right - ([self columCount] - 1) * [self columnInterval]) / [self columCount];
    CGFloat height = [self.delegate waterLayout:self itemWidth:width indexPath:indexPath];
    //找出高度最短的那一列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 0 ; i < [self columCount]; i ++) {
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    CGFloat X = [self edgeInsets].left + destColumn * (width + [self columnInterval]);
    CGFloat Y = minColumnHeight;
    if (Y != [self edgeInsets].top) {
        Y += [self rowInterval];
    }
    attrs.frame = CGRectMake(X, Y, width, height);
    //更新最短那一列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    //记录内容的高度
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    return attrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    if ([UICollectionElementKindSectionFooter isEqualToString:elementKind]){
        attrs.frame=CGRectMake(0,0,self.footerReferenceSize.width,self.footerReferenceSize.height);
    } else {
        attrs.frame=CGRectMake(0,0,self.headerReferenceSize.width,self.headerReferenceSize.height);
    }
    return attrs;
}

- (CGSize)collectionViewContentSize
{
    CGFloat h = self.contentHeight + [self edgeInsets].bottom;
    if (h <= CGViewGetHeight(self.collectionView)){
        h = CGViewGetHeight(self.collectionView) + 1;
    }
    
    return CGSizeMake(0, h);
}
@end
