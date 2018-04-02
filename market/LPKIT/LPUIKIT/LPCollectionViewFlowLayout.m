//
//  LPCollectionViewFlowLayout.m
//  Card
//
//  Created by Lipeng on 2017/2/15.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "LPCollectionViewFlowLayout.h"

@implementation LPCollectionViewFlowLayout
- (CGSize)collectionViewContentSize
{
    CGSize size=super.collectionViewContentSize;
    if (UICollectionViewScrollDirectionHorizontal==self.scrollDirection){
        if (size.width<=CGViewGetWidth(self.collectionView)) {
            return CGSizeMake(CGViewGetWidth(self.collectionView)+1, size.height);
        }
    } else if (UICollectionViewScrollDirectionVertical==self.scrollDirection){
        if (size.height<=CGViewGetHeight(self.collectionView)) {
            return CGSizeMake(size.width,CGViewGetHeight(self.collectionView)+1);
        }
    }
    
    return size;
}
@end
