//
//  PPShareMenu.h
//  ppablum
//
//  Created by Lipeng on 2018/1/2.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPShareType.h"

typedef void (^share_block)(NSInteger platformtype, NSString *platformname);

@interface PPShareMenu : UIView
+ (void)show:(share_block)block;
@end
