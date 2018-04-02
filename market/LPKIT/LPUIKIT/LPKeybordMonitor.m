//
//  LPKeybordMonitor.m
//  DU365
//
//  Created by Lipeng on 16/6/26.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import "LPKeybordMonitor.h"

@interface LPKeybordMonitor()
@property(nonatomic, weak) UIView *responseView;
@property(nonatomic, weak) UIView *adjustedView;
@property(nonatomic, assign) CGPoint keybordXY;
@property(nonatomic, assign) BOOL changed;
@property(nonatomic, assign) CGRect rect;
@end

@implementation LPKeybordMonitor
- (void)dealloc
{
    LP_RemoveObserver(self);
}

- (void)startMointoring
{
    LP_AddObserver(UIKeyboardWillShowNotification,self,@selector(onKeyboardShow:));
    LP_AddObserver(UIKeyboardWillHideNotification,self,@selector(onKeyboardHide:));
}

- (void)stopMointoring
{
    LP_RemoveObserver(self);
}

- (void)onKeyboardShow:(NSNotification *)notify
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSValue *value = notify.userInfo[UIKeyboardFrameEndUserInfoKey];
    _keybordXY = [window convertPoint:[value CGRectValue].origin toWindow:window];
    [self adjust];
}

- (void)onKeyboardHide:(NSNotification *)notify
{
    _changed = NO;
    [UIView animateWithDuration:.2f animations:^(void){
        [_adjustedView setTransform:CGAffineTransformMakeTranslation(0.f, 0.f)];
    } completion:^(BOOL finised){}];
    _responseView = nil;
    _adjustedView = nil;
}

- (void)adjust:(UIView *)adjuster with:(UIView *)responser
{
    BOOL shown = (nil != [self responseView]);
    if (shown && ![_adjustedView isEqual:adjuster]) {
        //键盘出现过，先恢复原来的
        _changed = NO;
        [_adjustedView setTransform:CGAffineTransformMakeTranslation(0.f, 0.f)];
    }
    _responseView = responser;
    _adjustedView = adjuster;
    if (shown) {
        //键盘出现过，直接调整
        [self adjust];
    }
}

- (void)hideKeybord
{
    [_responseView resignFirstResponder];
}

- (void)adjust
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    if (!_changed) {
        if (!_adjusterAllExpand){
            _rect = [_responseView.superview convertRect:_responseView.frame toView:window];
        }else{
            _rect = [_adjustedView.superview convertRect:_adjustedView.frame toView:window];
        }
        _changed = YES;
    }
    if (_rect.origin.y + _rect.size.height > _keybordXY.y) {
        CGFloat offset = _keybordXY.y - (_rect.origin.y + _rect.size.height + (_adjusterAllExpand?0:40.f));
        [UIView animateWithDuration:.2f animations:^(void){
            [_adjustedView setTransform:CGAffineTransformMakeTranslation(0.f, offset)];
        } completion:^(BOOL finised){}];
    }
}
@end
