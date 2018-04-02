//
//  UIImage+LP.h
//  DU365
//
//  Created by xuyuqiang on 16/7/6.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SaveImageBlock)(BOOL result);
@interface UIImage (LP)
//压缩图片
- (UIImage *)clipImageToFitMaxSize:(float)maxSize;
//通过颜色生成一张图片
+ (UIImage *)imageFromColor:(UIColor *)color;
//获取主色调
-(UIColor*)mostColor;
//生成缩略图
-(UIImage *)thumbImage:(CGSize)size;
//区域截图
- (UIImage*)cropImageInRect:(CGRect)rect;
//在底部拼接个图片
- (UIImage *)appendImageAtBottom:(UIImage *)image;
//在右边拼接个图片
- (UIImage *)appendImageAtRight:(UIImage *)image;
- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

- (UIImage *)fixOrientation;

- (UIImage *)scaleToSize:(CGSize)size;

- (UIImage *)cutOnRect:(CGRect)rect;
//保存图片到系统相册
+ (void)saveImageToSystemAlbum:(UIImage *)image;
@end
