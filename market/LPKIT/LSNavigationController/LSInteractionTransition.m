/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The interaction controller for the Swipe demo.  Tracks a UIScreenEdgePanGestureRecognizer
 from a specified screen edge and derives the completion percentage for the
 transition.
 */

#import "LSInteractionTransition.h"
#import "LSNavigationController.h"
@interface LSInteractionTransition ()
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, weak) LSNavigationController* navigationController;
@property (nonatomic, weak) UIView* temoView;
@property (nonatomic, strong) LSStack* leftStack;
@property (nonatomic, weak) UIView* leftView;
@property (nonatomic, weak) UIView* rightView;
@property (nonatomic, weak) UIView* maskView;
@end

@implementation LSInteractionTransition
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.leftStack = [[LSStack alloc] init];
    }
    return self;
}
- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    UIView* containerView = transitionContext.containerView;
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    CGRect frame = toViewController.view.frame;
    frame.origin.x = -Screen_Width/2;
    toViewController.view.frame = frame;
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];


    self.navigationController = (LSNavigationController*)fromViewController.navigationController;
    
    self.rightView = fromViewController.view;
    self.leftView = toViewController.view;
    
    //蒙版view
    UIView* maskView = [[UIView alloc] init];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.frame = CGRectMake(0, 0, Screen_Width, self.navigationController.view.frame.size.height);
    [self.leftView addSubview:maskView];
    maskView.alpha = 0.5;
    self.maskView = maskView;
}

- (void)updateWithPercent:(CGFloat)percent
{
 
    self.navigationController.navigationBar.hidden = YES;
    CGFloat scale = fabs(percent);
    self.rightView.transform = CGAffineTransformMakeTranslation(scale * Screen_Width, 0);
    self.leftView.transform = CGAffineTransformMakeTranslation(scale * Screen_Width / 2, 0);
    [self.transitionContext updateInteractiveTransition:percent];
    self.maskView.alpha = 0.5 - percent / 2;
}

- (void)finishBy:(BOOL)finished
{
    if (!finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.rightView.transform = CGAffineTransformIdentity;
            self.leftView.transform = CGAffineTransformIdentity;
            self.maskView.alpha = 0.5;
        }
            completion:^(BOOL finished) {
                [self.transitionContext cancelInteractiveTransition];
                [self.transitionContext updateInteractiveTransition:0];
                [self.transitionContext completeTransition:NO];
                [self.maskView removeFromSuperview];
            }];
    }
    else { //完成
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        [UIView animateWithDuration:0.3 animations:^{
            self.rightView.transform = CGAffineTransformMakeTranslation(width, 0);
            self.leftView.transform = CGAffineTransformMakeTranslation(width / 2, 0);
            self.maskView.alpha = 0;
        }
            completion:^(BOOL finished) {
                [self.maskView removeFromSuperview];
                [self.transitionContext updateInteractiveTransition:1];
                [self.transitionContext finishInteractiveTransition];
                [self.transitionContext completeTransition:YES];
                self.leftView.transform = CGAffineTransformIdentity;
                CGRect frame = self.leftView.frame;
                frame.origin.x = 0;
                self.leftView.frame = frame;
            }];
    }
}
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
}
@end

#pragma mark - 栈
@interface LSStack ()

@property (nonatomic, strong) NSMutableArray *views;

@end


@implementation LSStack

-(NSMutableArray *)views
{
    if (_views==nil) {
        _views=[NSMutableArray array];
    }
    return _views;
}
-(void)pop
{
    if (![self isEmpty]) {
        [self.views removeLastObject];
    }
}
-(void)push:(id)obj
{
    if (obj) {
        [self.views addObject:obj];
    }
}
-(id)getTop
{
    if (![self isEmpty]) {
        return self.views.lastObject;
    }else {
        
        return nil;
    }
    
}

-(BOOL)isEmpty
{
    if (self.views.count) {
        return NO;
    }else{
        return YES;
    }
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com