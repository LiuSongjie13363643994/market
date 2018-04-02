//
//  LPFitWidthLabel.m
//  DU365
//
//  Created by Lipeng on 16/6/26.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import "LPFitWidthLabel.h"

@implementation LPFitWidthLabel
- (void)setText:(NSString *)text
{
    super.text=text;
    CGViewChangeWidth(self,[text lpSizeWithFont:self.font].width);
}
@end
