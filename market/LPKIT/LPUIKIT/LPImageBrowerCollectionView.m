//
//  LPImageBrowerCollectionView.m
//  MrMood
//
//  Created by Lipeng on 16/9/14.
//  Copyright © 2016年 Lipeng. All rights reserved.
//

#import "LPImageBrowerCollectionView.h"

static NSString *identifier=@"cell";

@interface LPImageBrowerCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation LPImageBrowerCollectionView
- (id)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    layout.itemSize=frame.size;
    layout.minimumLineSpacing=0.f;
    layout.minimumInteritemSpacing=0.f;
    if (self=[super initWithFrame:frame collectionViewLayout:layout]){
        self.delegate=self;
        self.dataSource=self;
        self.pagingEnabled=YES;
        self.showsHorizontalScrollIndicator=NO;
        self.backgroundColor=[UIColor clearColor];
        [self registerClass:LPImageBrowerCollectionViewCell.class forCellWithReuseIdentifier:identifier];
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (!_receiveGesture){
        if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
            UIPanGestureRecognizer *pan=(UIPanGestureRecognizer *)gestureRecognizer;
            CGFloat x=[pan translationInView:gestureRecognizer.view].x;
            if (x>0 && self.contentOffset.x<=0.f) {
                return NO;
            }
        }
    }
    return YES;
}
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex=currentIndex;
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}
#pragma mark
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index=scrollView.contentOffset.x/CGViewGetWidth(scrollView);
    if (nil!=_reached_block){
        _reached_block(index,scrollView.contentOffset.x/scrollView.contentSize.width);
    }
    _currentIndex=index;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageURLs.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LPImageBrowerCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.URL=_imageURLs[indexPath.row];
    cell.endBySingleTap=_endBySingleTap;
    return cell;
}
@end
