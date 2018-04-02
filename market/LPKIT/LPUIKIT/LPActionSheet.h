//
//  LPActionSheet.h
//  MDT
//
//  Created by Lipeng on 15/11/24.
//  Copyright (c) 2015年 West. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPActionSheet;

typedef void (^lp_actionsheet_block)(NSUInteger buttonIndex);

@interface LPActionSheet : UIActionSheet
+ (id)sheetWithTitle:(NSString *)title
        buttonTitles:(NSArray *)titles
     completionBlock:(lp_actionsheet_block)block;
@end
