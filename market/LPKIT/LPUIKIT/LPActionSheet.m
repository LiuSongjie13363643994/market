//
//  LPActionSheet.m
//  MDT
//
//  Created by Lipeng on 15/11/24.
//  Copyright (c) 2015年 West. All rights reserved.
//

#import "LPActionSheet.h"

@interface LPActionSheet()<UIActionSheetDelegate>

@property(nonatomic, copy) lp_actionsheet_block block;
@end

@implementation LPActionSheet

- (void)dealloc
{
    _block = nil;
}

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle
{
    return [super initWithTitle:title
                       delegate:self
              cancelButtonTitle:cancelButtonTitle
         destructiveButtonTitle:nil
              otherButtonTitles:nil, nil];
}

#pragma mark
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _block(buttonIndex);
}

//
+ (id)actionSheetWithTitle:(NSString *)title
           completionBlock:(lp_actionsheet_block)block
         cancelButtonTitle:(NSString *)cancelButtonTitle
         otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    LPActionSheet *sheet = [[self alloc] initWithTitle:title cancelButtonTitle:cancelButtonTitle];
    id eachObject;
    va_list argumentList;
    if (nil != otherButtonTitles) {
        [sheet addButtonWithTitle:otherButtonTitles];
        va_start(argumentList, otherButtonTitles);
        while ((eachObject = va_arg(argumentList, id))) {
            [sheet addButtonWithTitle:eachObject];
        }
        va_end(argumentList);
    }
    sheet.block = block;
    return sheet;
}

//
+ (id)sheetWithTitle:(NSString *)title
        buttonTitles:(NSArray *)titles
     completionBlock:(lp_actionsheet_block)block
{
    LPActionSheet *sheet = [[self alloc] initWithTitle:title cancelButtonTitle:nil];
    for (NSString *title in titles) {
        [sheet addButtonWithTitle:title];
    }
    [sheet addButtonWithTitle:@"取消"];
    sheet.cancelButtonIndex = titles.count;
    sheet.block = block;
    return sheet;
}
@end
