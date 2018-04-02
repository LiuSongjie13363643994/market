//
//  CheckView.m
//  market
//
//  Created by Lipeng on 2017/8/26.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "CheckStateView.h"

@implementation CheckStateView
- (instancetype)initWithFrame:(CGRect)frame
{
    UIImage *img=[UIImage imageNamed:@"ic-yes"];
    if (self=[super initWithFrame:CGRectMake(0,0,img.size.width,img.size.height)]) {
        self.image=img;
        self.cornerRadius=img.size.width/2;
    }
    return self;
}

- (void)setState:(NSInteger)state
{
    self.hidden=(kCheckState_NA==state);
    self.backgroundColor=(kCheckState_YES==state)?kColore13f3c:kColordddddd;
}
@end
