//
//  UIView+ViewState.m
//  JamGo
//
//  Created by Lipeng on 2017/6/23.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "UIView+ViewState.h"

#import "UIView+ViewState.h"
#import <objc/runtime.h>

static char kViewStateViewKey;
static char kViewStateKey;

@implementation UIView(ViewState)

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (UIView *)loadingView
{
    UIActivityIndicatorView *aiv=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGViewTransX1ToMidOfView(aiv,self);
    CGViewTransY1ToMidOfView(aiv,self);
    [aiv startAnimating];
    return aiv;
}

- (UIView *)emptyView:(NSString *)text
{
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0,100,CGViewGetWidth(self),0)];
    UIImageView *iv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-empty"]];
    [v addSubview:iv];
    CGViewTransX1ToMidOfView(iv,v);
    UILabel *la=LPAddClearBGSubView(v,UILabel,CGRectMake(0,CGViewGetY2(iv)+20,CGViewGetWidth(v),18));
    [la setFont:LPFont(18) color:LPColor(0x66,0x66,0x66,1) alignment:NSTextAlignmentCenter];
    la.text=text;
    return v;
}

- (void)setStateObject:(ViewStateObject *)stateObject
{
    objc_setAssociatedObject(self,&kViewStateKey,stateObject,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIView *v=objc_getAssociatedObject(self,&kViewStateViewKey);
    [v removeFromSuperview];
    objc_setAssociatedObject(self,&kViewStateViewKey,nil,OBJC_ASSOCIATION_ASSIGN);
    v=nil;
    switch (stateObject.state) {
        case ViewState_Loading:{
            v=[self loadingView];
        }break;
        case ViewState_Empty:{
            v=[self emptyView:(NSString *)stateObject.object];
        }break;
        case ViewState_Done:
        default:{
        }break;
    }
    if (nil!=v) {
        [self insertSubview:v atIndex:0];
        objc_setAssociatedObject(self,&kViewStateViewKey,v,OBJC_ASSOCIATION_ASSIGN);
    }
}
- (ViewStateObject *)stateObject
{
    return objc_getAssociatedObject(self,&kViewStateKey);
}
@end
