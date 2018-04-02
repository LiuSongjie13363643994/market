//
//  TextTableViewCell.m
//  market
//
//  Created by Lipeng on 2017/8/20.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "TextTableViewCell.h"

@implementation TextTableViewCell

- (void)invokeLayoutSubviews
{
    self.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-next"]];
    [self.textLabel setFont:LPFont(17) color:kColor23232b alignment:NSTextAlignmentLeft];
    [self.detailTextLabel setFont:LPFont(12) color:kColor9d9d9d alignment:NSTextAlignmentRight];
}
- (void)invokeFillSubviews
{
    if (self.accessoryView){
        self.accessoryView.lp_midy();
    }
}

+ (CGFloat)height{
    return 54;
}

@end
