//
//  PPShareButton.m
//  ppablum
//
//  Created by Lipeng on 2018/1/2.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "PPShareButton.h"

@implementation PPShareButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        self.clipsToBounds = NO;
    }
    return self;
}

- (void)setImage:(UIImage *)image text:(NSString *)text
{
    UIImageView *iv = (UIImageView *)self.lp_av(UIImageView.class, 0, 0, 50, 50).lp_midx();
    iv.image = image;
    
    UILabel *la = (UILabel *)self.lp_av(UILabel.class, 0, 0, -1, LPFontHeight(15)).lp_iny1(0);
    [la setFont:LPFont(15.f) color:kColor717171 alignment:NSTextAlignmentCenter];
    la.clipsToBounds = NO;
    la.text = text;
    _text = text;
}

+ (CGSize)size
{
    return CGSizeMake((LP_Screen_Width - LP_X_2GAP) / 3, 50 + 12 + 10);
}
@end
