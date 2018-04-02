//
//  UIView+LP.h
//
//
//  Created by Lipeng on 15/11/21.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(LP)
@property(nonatomic, assign) CGFloat cornerRadius;
@property(nonatomic, assign) CGFloat borderWidth;
@property(nonatomic, assign) UIColor *borderColor;

- (UIView *)addSubViewWithClass:(Class)class1 clearBackground:(BOOL)clearBackground atFrame:(CGRect)frame;

- (UITableView *)addTableViewWithClass:(Class)class1 style:(UITableViewStyle)style clearSperator:(BOOL)clearSperator atFrame:(CGRect)frame;

- (CALayer *)drawBottomLine:(UIColor *)color;
- (CALayer *)drawTopLine:(UIColor *)color;
- (CALayer *)drawLineAsLayer:(CGRect)frame color:(UIColor *)color;
- (UIView *)drawLineAsView:(CGRect)frame color:(UIColor *)color;
- (UIView *)drawBottomLineAsView:(UIColor *)color;
- (void)callNumber:(NSString *)number;
- (UITapGestureRecognizer *)addTapGestureWithTarget:(nullable id)target action:(nullable SEL)action;
- (UITapGestureRecognizer *)addTapGestureBlock:(void (^)(UITapGestureRecognizer *gesture))block;
- (void)addLongGestureBlock:(void (^)(UILongPressGestureRecognizer *))block;
- (UIImage *_Nullable)myimage;
- (UIView *_Nullable)findFirstResponder;
- (void)asRoundStlye:(UIColor *)color;
- (void)addMaskLayer:(UIColor *)color;
@end

#define LPAddSubView(view, subViewClass, frame) ((subViewClass *)[view addSubViewWithClass:subViewClass.class clearBackground:NO atFrame:frame])
#define LPAddClearBGSubView(view, subViewClass, frame) ((subViewClass *)[view addSubViewWithClass:subViewClass.class clearBackground:YES atFrame:frame])

#define LPAddPlainTableView(VIEW,TABLEVIEWCLASS,CLEARSPERATOR,FRAME) ((TABLEVIEWCLASS *)[VIEW addTableViewWithClass:TABLEVIEWCLASS.class style:UITableViewStylePlain clearSperator:CLEARSPERATOR atFrame:FRAME])

#define LPAddGroupedTableView(VIEW,TABLEVIEWCLASS,CLEARSPERATOR,FRAME) ((TABLEVIEWCLASS *)[VIEW addTableViewWithClass:TABLEVIEWCLASS.class style:UITableViewStyleGrouped clearSperator:CLEARSPERATOR atFrame:FRAME])

