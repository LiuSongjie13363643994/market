//
//  UITableView+LP.h
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView(LP)
//初始化显示样式
- (void)initAppearanceStyles:(BOOL)clearSeparator;
//
- (id)cellWithClass:(Class)class1 style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier;
- (void)lp_reloadData;

- (void)scrollBottom:(BOOL)animated;
- (void)scrollToTop:(BOOL)animated;
@property(nonatomic, assign) BOOL clearSeparator;

+ (void)loadSwizzling;
@end

#define LPMakeTableViewCell(TABLEVIEW,CLASS,STYLE,IDENTIFIER) [TABLEVIEW cellWithClass:CLASS.class style:STYLE reuseIdentifier:IDENTIFIER]

#define LPMakeDefaultStyleTableViewCell(TABLEVIEW,CLASS,IDENTIFIER) [TABLEVIEW cellWithClass:CLASS.class style:UITableViewCellStyleDefault reuseIdentifier:IDENTIFIER]

#define LPMakeValue1StyleTableViewCell(TABLEVIEW,CLASS,IDENTIFIER) [TABLEVIEW cellWithClass:CLASS.class style:UITableViewCellStyleValue1 reuseIdentifier:IDENTIFIER]

#define LPMakeSubtitleStyleTableViewCell(TABLEVIEW,CLASS,IDENTIFIER) [TABLEVIEW cellWithClass:CLASS.class style:UITableViewCellStyleSubtitle reuseIdentifier:IDENTIFIER]


