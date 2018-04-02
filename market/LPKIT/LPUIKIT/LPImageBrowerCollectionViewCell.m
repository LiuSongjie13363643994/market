//
//  LPImageBrowerCollectionViewCell.m
//  MrMood
//
//  Created by Lipeng on 16/9/14.
//  Copyright © 2016年 Lipeng. All rights reserved.
//

#import "LPImageBrowerCollectionViewCell.h"

@interface LPImageBrowerCollectionViewCell()<UIScrollViewDelegate>
@property(nonatomic) UIScrollView *scrollView;
@property(nonatomic) UIImageView *imageView;
@property(nonatomic,assign) BOOL bySingleTap;
@property(nonatomic) UIActivityIndicatorView *loadingView;
@end

@implementation LPImageBrowerCollectionViewCell
//- (id)initWithFrame:(CGRect)frame
//{
//    if (self=[super initWithFrame:frame]) {
//        _scrollView=LPAddClearBGSubView(self,UIScrollView,CGViewGetBounds(self));
//        _scrollView.showsVerticalScrollIndicator=NO;
//        _scrollView.showsHorizontalScrollIndicator=NO;
//        _scrollView.minimumZoomScale=1.f;
//        _scrollView.maximumZoomScale=2.f;
//        _scrollView.bounces=NO;
//        _scrollView.decelerationRate=0.f;
//        _scrollView.bounds=self.bounds;
//        _scrollView.delegate=self;
//
//        _imageView=LPAddClearBGSubView(_scrollView,UIImageView,CGViewGetBounds(_scrollView));
//        _imageView.contentMode=UIViewContentModeScaleAspectFit;
//        UITapGestureRecognizer *stap=[self addTapGestureWithTarget:self action:@selector(onSingleTap:)];
//        stap.numberOfTapsRequired=1;
//        UITapGestureRecognizer *dtap=[self addTapGestureWithTarget:self action:@selector(onDoubleTap:)];
//        dtap.numberOfTapsRequired=2;
//        [stap requireGestureRecognizerToFail:dtap];
//    }
//    return self;
//}
//- (void)onSingleTap:(UIGestureRecognizer*)tap
//{
//    if (nil!=_imageView.image && _endBySingleTap){
//        _bySingleTap=YES;
//        if (_scrollView.zoomScale>_scrollView.minimumZoomScale){
//            [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
//        } else {
//            [self routerEvent:kRouterEvent_ImageBrowerSingleTaped information:@{kRouterKeyInformation:_URL}];
//        }
//    }
//}
//- (void)onDoubleTap:(UIGestureRecognizer*)tap
//{
//    _bySingleTap=NO;
//    if (nil!=_imageView.image){
//        if (_scrollView.zoomScale<=_scrollView.minimumZoomScale) { // 放大
//            CGPoint location=[tap locationInView:_scrollView];
//            // 放大scrollView.maximumZoomScale倍, 将它的宽高缩小
//            CGFloat width=CGViewGetWidth(_scrollView)/_scrollView.maximumZoomScale;
//            CGFloat height=CGViewGetHeight(_scrollView)/_scrollView.maximumZoomScale;
//            CGRect rect=CGRectMake(location.x*(1-1/_scrollView.maximumZoomScale),location.y*(1-1/_scrollView.maximumZoomScale),width,height);
//            [_scrollView zoomToRect:rect animated:YES];
//        } else {// 缩小
//            [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
//        }
//    }
//}
//
//- (void)setURL:(NSURL *)URL
//{
//    _URL=URL;
//    __weak typeof(self) wself=self;
//    if (nil==_loadingView){
//        _loadingView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        [self addSubview:_loadingView];
//        CGViewTransX1ToMidOfView(_loadingView,self);
//        CGViewTransY1ToMidOfView(_loadingView,self);
//        [_loadingView startAnimating];
//    }
//    _imageView.image=nil;
//    if ([[URL scheme] isEqualToString:@"file"]) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
//            UIImage *image=[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:URL.path];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if ([wself.URL.path isEqualToString:URL.path]){
//                    [wself.loadingView removeFromSuperview];
//                    wself.loadingView=nil;
//                    wself.imageView.image=image;
//                    [wself setupImageviewFrame:wself.imageView.image];
//                }
//            });
//        });
//    } else if ([[URL scheme] isEqualToString:@"http"]){
//        [_imageView sd_setImageWithURL:_URL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if ([wself.URL.path isEqualToString:URL.path]){
//                [wself.loadingView removeFromSuperview];
//                wself.loadingView=nil;
//                wself.imageView.image=image;
//                [wself setupImageviewFrame:wself.imageView.image];
//            }
//        }];
//    }
//}
//
//- (void)setupImageviewFrame:(UIImage *)image
//{
//    if (nil!=image) {
//        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:NO];
//        // 按照图片比例设置imageView的frame
//        CGFloat width=(image.size.width<CGViewGetWidth(_scrollView))?image.size.width:CGViewGetWidth(_scrollView);
//        CGFloat height=image.size.height*width/image.size.width;
//
//        // 长图
//        if (height>CGViewGetHeight(_scrollView)) {
//            _imageView.frame=CGRectMake((CGViewGetWidth(_scrollView)-width)/2.f,0.0,width, height);
//            _scrollView.contentSize=_imageView.bounds.size;
//            _scrollView.contentOffset=CGPointZero;
//        } else {
//            // 居中显示
//            _imageView.frame=CGRectMake((CGViewGetWidth(_scrollView)- width)/2.f,(CGViewGetHeight(_scrollView)-height)/2.f,width,height);
//
//        }
//        // 使得最大缩放时(双击或者放大)图片高度 = 屏幕高度 + 1.0倍图片高度
//        _scrollView.maximumZoomScale=CGViewGetHeight(_scrollView)/height+1.0;
//    }
//}
//
//- (void)transImageview2Center
//{
//    CGFloat offsetX=(CGViewGetWidth(_scrollView)>_scrollView.contentSize.width)?(CGViewGetWidth(_scrollView)-_scrollView.contentSize.width)*0.5:0.0;
//    CGFloat offsetY=(CGViewGetHeight(_scrollView)>_scrollView.contentSize.height)?(CGViewGetHeight(_scrollView)-_scrollView.contentSize.height)*0.5:0.0;
//    _imageView.center=CGPointMake(_scrollView.contentSize.width*0.5+offsetX,_scrollView.contentSize.height*0.5+offsetY);
//}
//#pragma mark
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView
//{
//    [self transImageview2Center];
//}
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return _imageView;
//}
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale
//{
//    if (scale==_scrollView.minimumZoomScale){
//        if (_bySingleTap){
//            [self routerEvent:kRouterEvent_ImageBrowerSingleTaped information:@{kRouterKeyInformation:_URL}];
//        }
//    }
//}
@end
