//
//  UICollectionView+B.m
//  Bofo
//
//  Created by Lipeng on 2017/6/12.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "UICollectionView+LP.h"

@implementation UICollectionView(LP)

- (void)lp_reloadData
{
    [UIView performWithoutAnimation:^{
        self.hidden = YES;
        [self reloadData];
        self.hidden = NO;
    }];
}
@end
