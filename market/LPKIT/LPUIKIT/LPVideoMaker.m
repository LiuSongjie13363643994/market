//
//  LPVideoMaker.m
//  MrMood
//
//  Created by Lipeng on 16/9/20.
//  Copyright © 2016年 Lipeng. All rights reserved.
//

#import "LPVideoMaker.h"
#import <AVFoundation/AVFoundation.h>

@interface LPVideoMaker()
@property(nonatomic,assign) BOOL ismaking;
@property(nonatomic,assign) BOOL capturing;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) NSMutableArray *array;
@end

@implementation LPVideoMaker
LP_SingleInstanceImpl(LPVideoMaker)

- (void)start
{
    if (nil!=_view && !_ismaking) {
        _ismaking=YES;
        _capturing=YES;
        _array=[NSMutableArray array];
        
        NSInvocationOperation *operation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(addImageData) object:nil];
        NSOperationQueue *queue=[[NSOperationQueue alloc] init];
        [queue addOperation:operation];
        
        [NSThread sleepForTimeInterval:0.1];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *moviePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",@"test"]];
        CGSize size = CGViewGetSize(_view);
        size=CGSizeMake(size.width*[UIScreen mainScreen].scale, size.height*[UIScreen mainScreen].scale);
        size=CGSizeMake(1080, 1920);
        NSError *error = nil;
        
        unlink([moviePath UTF8String]);
        AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:moviePath]
                                                               fileType:AVFileTypeQuickTimeMovie
                                                                  error:&error];
        NSParameterAssert(videoWriter);
        if(error){
            NSLog(@"error = %@", [error localizedDescription]);
        }
        NSDictionary *settings=@{AVVideoCodecKey:AVVideoCodecH264,
                                 AVVideoWidthKey:@(size.width),
                                 AVVideoHeightKey:@(size.height)};
        AVAssetWriterInput *writerInput=[AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:settings];
        
        NSDictionary *pixel=@{(NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32ARGB)};
        AVAssetWriterInputPixelBufferAdaptor *adaptor=[AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:pixel];
        NSParameterAssert(writerInput);
        NSParameterAssert([videoWriter canAddInput:writerInput]);
        
        if ([videoWriter canAddInput:writerInput]){
            NSLog(@"ok");
        } else {
            NSLog(@"……");
        }
        
        [videoWriter addInput:writerInput];
        
        [videoWriter startWriting];
        [videoWriter startSessionAtSourceTime:kCMTimeZero];
        
        dispatch_queue_t dispatchQueue=dispatch_queue_create("mediaInputQueue", NULL);
        int __block frame = 0;
        __weak typeof(self) wself=self;
        [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
            NSLog(@"wrierInput is->>>>>>>>>%i",[writerInput isReadyForMoreMediaData]);
            while ([writerInput isReadyForMoreMediaData]){
                NSLog(@"imageArr->%d,isVieo ---->%i",(int)[wself.array count],wself.ismaking);
                if (0==wself.array.count && !wself.capturing){
                    [writerInput markAsFinished];
                    [videoWriter finishWritingWithCompletionHandler:^{
                        wself.ismaking=NO;
                        NSLog(@"%@",moviePath);
                    }];
                    break;
                }
                if (0==wself.array.count && wself.capturing) {
                }
                else
                {
                    CVPixelBufferRef buffer = NULL;
                    buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:[wself.array[0] CGImage] size:size];
                    if (++frame%10 == 0) {
                        [wself.array removeObjectAtIndex:0];
                    }
                    if (buffer)
                    {
                        if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame, 120)]){
                            NSLog(@"FAIL");
                        } else {
                            NSLog(@"doing……");
                            CFRelease(buffer);
                        }
                    }
                }
            }
        }];
    }
}
- (void)stop
{
    if (_capturing){
        [_timer invalidate];
        _timer=nil;
        _capturing=NO;
    }
}
- (void)test
{
    UIGraphicsBeginImageContextWithOptions(CGViewGetSize(_view),NO,[UIScreen mainScreen].scale);
    [_view drawViewHierarchyInRect:CGViewGetBounds(_view) afterScreenUpdates:YES];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    [_array addObject:image];
    UIGraphicsEndImageContext();
}
- (void)onTimer:(id)timer
{
    [self performSelectorOnMainThread:@selector(test) withObject:nil waitUntilDone:YES];
}
- (void)addImageData
{
    _timer=[[NSTimer alloc] initWithFireDate:[NSDate new] interval:0.04 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
}
- (CVPixelBufferRef )pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options, &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, 4*size.width, rgbColorSpace, kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}
@end
