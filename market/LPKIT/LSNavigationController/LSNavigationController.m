//
//  LSNavigationController.h
//  LSNavigationBarTransition
//
//  Created by ls on 16/1/16.
//  Copyright © 2016年 song. All rights reserved.
//
#import "LSInteractionTransition.h"
#import "LSNavigationController.h"
#import <objc/runtime.h>
//最大移动比例可以pop
#define LSRightScale 0.4
//边缘手势比例
#define LSScreenEdgeScale 0.3

static BOOL forbidLS=NO;

@interface LSNavigationController()<UIGestureRecognizerDelegate,UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>
//交互动画
@property (nonatomic, strong) LSInteractionTransition *interactionAnimation;
@end

@implementation LSNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.interactivePopGestureRecognizer.enabled=NO;
    self.navigationBarHidden=YES;
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.view addGestureRecognizer:pan];
    pan.delegate = self;
}
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController*)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactionAnimation;
}
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController*)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController*)fromVC toViewController:(UIViewController*)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        return nil;
    }
    return self.interactionAnimation;
}
- (void)handleGesture:(UIPanGestureRecognizer*)recognizer
{
    CGFloat x = [recognizer translationInView:recognizer.view].x;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat scale = x / width;
    switch (recognizer.state) {
    case UIGestureRecognizerStateBegan: {
        self.interactionAnimation = [[LSInteractionTransition alloc] init];
        [self popViewControllerAnimated:YES];
    } break;
    case UIGestureRecognizerStateChanged: {
        
        if (x < 0) {
            [self.interactionAnimation updateWithPercent:0];
            return;
        }
        [self.interactionAnimation updateWithPercent:scale];
        break;
    }

    case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateCancelled:
    case UIGestureRecognizerStateFailed: {
        CGFloat velocityX = [recognizer velocityInView:recognizer.view].x;
        if (velocityX > 800) {
            [self.interactionAnimation finishBy:YES];
            self.interactionAnimation = nil;
            return;
        }
        [self.interactionAnimation finishBy:scale > LSRightScale];
        self.interactionAnimation = nil;
        break;
    }
    default:
        break;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{
    if (forbidLS){
        return NO;
    }
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        UIPanGestureRecognizer *pan=(UIPanGestureRecognizer *)gestureRecognizer;
        CGFloat x=[pan translationInView:gestureRecognizer.view].x;
        if (x<=0) {
            return NO;
        }
    }
    return self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
}
+ (void)setForbidLS:(BOOL)forbid
{
    forbidLS=forbid;
}
@end
