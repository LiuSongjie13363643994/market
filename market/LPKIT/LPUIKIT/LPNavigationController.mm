//
//  LPNavigationController.m
//  
//
//  Created by Lipeng on 16/4/5.
//
//

#import "LPNavigationController.h"
#import <QuartzCore/QuartzCore.h>

@interface LPNavigationController ()
@property(nonatomic, strong) CALayer *animationLayer;
@end

@implementation LPNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
}

-(void)loadLayerWithImage
{
    UIGraphicsBeginImageContext(self.visibleViewController.view.bounds.size);
    [self.visibleViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    [self.animationLayer setContents: (id)viewImage.CGImage];
    [self.animationLayer setHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.animationLayer = [CALayer layer] ;
    CGRect layerFrame = self.view.frame;
    //    layerFrame.size.height = self.view.frame.size.height-self.navigationBar.frame.size.height;
    //    layerFrame.origin.y = self.navigationBar.frame.size.height+20;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        layerFrame.origin.y = 0.f;
    } else {
        layerFrame.origin.y = 20.f;
    }
    self.animationLayer.frame = layerFrame;
    self.animationLayer.masksToBounds = YES;
    [self.animationLayer setContentsGravity:kCAGravityBottomLeft];
    [self.view.layer insertSublayer:self.animationLayer atIndex:0];
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    id<CAAction> action = (id)[NSNull null];
    return action;
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGRect layerFrame = self.view.bounds;

//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
//        layerFrame.origin.y = 0.f;
//    } else {
//        layerFrame.origin.y = 20.f;
//    }
    
    self.animationLayer.frame = layerFrame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.animationLayer removeFromSuperlayer];
    [self.view.layer insertSublayer:self.animationLayer atIndex:0];
    if (animated)
    {
        [self loadLayerWithImage];
        UIView * toView = [viewController view];
        
        CABasicAnimation *Animation  = [CABasicAnimation animationWithKeyPath:@"transform"];
        //        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        //        rotationAndPerspectiveTransform.m34 = 1.0 / -1000;
        //        rotationAndPerspectiveTransform = CATransform3DMakeTranslation(self.view.frame.size.width, 0, 0);
        [Animation setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(self.view.bounds.size.width, 0, 0)]];
        [Animation setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)]];
        [Animation setDuration:0.3];
        Animation.removedOnCompletion = NO;
        Animation.fillMode = kCAFillModeBoth;
        
        [toView.layer addAnimation:Animation forKey:@"fromRight"];
        
        CABasicAnimation *Animation1  = [CABasicAnimation animationWithKeyPath:@"transform"];
        //        CATransform3D rotationAndPerspectiveTransform1 = CATransform3DIdentity;
        //        rotationAndPerspectiveTransform1.m34 = 1.0 / -1000;
        //        rotationAndPerspectiveTransform1 = CATransform3DMakeScale(1.0, 1.0, 1.0);
        [Animation1 setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [Animation1 setDuration:0.3];
        Animation1.removedOnCompletion = NO;
        Animation1.fillMode = kCAFillModeBoth;
        [self.animationLayer addAnimation:Animation1 forKey:@"scale"];
    }
    [super pushViewController:viewController animated:NO];
}

-(UIViewController*)popViewControllerAnimated:(BOOL)animated
{
    [self.animationLayer removeFromSuperlayer];
    [self.view.layer insertSublayer:self.animationLayer above:self.view.layer];
    if(animated)
    {
        [self loadLayerWithImage];
        
        UIView * toView = [[self.viewControllers objectAtIndex:[self.viewControllers indexOfObject:self.visibleViewController]-1] view];
        
        CABasicAnimation *Animation  = [CABasicAnimation animationWithKeyPath:@"transform"];
        //        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        //        rotationAndPerspectiveTransform.m34 = 1.0 / -1000;
        //        rotationAndPerspectiveTransform = CATransform3DMakeTranslation(self.view.frame.size.width, 0, 0);
        [Animation setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        [Animation setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(self.view.bounds.size.width, 0, 0)]];
        [Animation setDuration:0.3];
        Animation.removedOnCompletion = NO;
        Animation.fillMode = kCAFillModeBoth;
        [self.animationLayer addAnimation:Animation forKey:@"scale"];
        
        
        CABasicAnimation *Animation1  = [CABasicAnimation animationWithKeyPath:@"transform"];
        //        CATransform3D rotationAndPerspectiveTransform1 = CATransform3DIdentity;
        //        rotationAndPerspectiveTransform1.m34 = 1.0 / -1000;
        //        rotationAndPerspectiveTransform1 = CATransform3DMakeScale(1.0, 1.0, 1.0);
        [Animation1 setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [Animation1 setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        [Animation1 setDuration:0.3];
        Animation1.removedOnCompletion = NO;
        Animation1.fillMode = kCAFillModeBoth;
        [toView.layer addAnimation:Animation1 forKey:@"scale"];
        
    }
    return [super popViewControllerAnimated:NO];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.animationLayer setContents:nil];
    [self.animationLayer removeAllAnimations];
    [self.visibleViewController.view.layer removeAllAnimations];
}


@end
