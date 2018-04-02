//
//  AITableViewCell.m
//  market
//
//  Created by Lipeng on 2017/8/18.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "AITableViewCell.h"

@implementation AITableViewCell

- (void)initAppearanceStyles
{
    [super initAppearanceStyles];
    
    self.backgroundColor=kColorffffff;
//    self.separatorInset=UIEdgeInsetsMake(0,LP_X_GAP,0,LP_X_GAP);
}

- (UIColor *)separatorColor
{
    return kColordedede;
}
@end
