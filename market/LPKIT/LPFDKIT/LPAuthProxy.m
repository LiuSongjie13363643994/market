//
//  LPAuthProxy.m
//  JamGo
//
//  Created by Lipeng on 2017/7/4.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "LPAuthProxy.h"
#import <Photos/Photos.h>

@implementation LPAuthProxy
LP_SingleInstanceImpl(LPAuthProxy)

- (void)authCamera:(void (^)(BOOL ready))block
{
    AVCaptureDevice *device=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(YES);
                    });
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            block(YES);
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            NSString *msg=@"请去-> [设置 - 隐私 - 相机 - 在路上] 打开访问开关";
            [LPAlertView alertViewWithTitle:@"温馨提示" message:msg completionBlock:^(NSUInteger buttonIndex) {
                block(NO);
            } cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        } else if (status == AVAuthorizationStatusRestricted) {
        }
    } else {
        NSString *msg=@"未检测到您的摄像头";
        [LPAlertView alertViewWithTitle:@"温馨提示" message:msg completionBlock:^(NSUInteger buttonIndex) {
            block(NO);
        } cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    }
}

- (void)authAlbum:(void (^)(BOOL ready))block
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (PHAuthorizationStatusNotDetermined == status){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (PHAuthorizationStatusAuthorized==status){
                block(YES);
            } else {
                block(NO);
            }
        }];
    } else if (PHAuthorizationStatusDenied == status){
        NSString *msg=@"请去-> [设置 - 隐私 - 照片 - 点点相册] 打开访问开关";
        [LPAlertView alertViewWithTitle:@"温馨提示" message:msg completionBlock:^(NSUInteger buttonIndex) {
            block(NO);
        } cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    } else if (PHAuthorizationStatusAuthorized == status){
        block(YES);
    } else if(PHAuthorizationStatusRestricted == status){
        NSString *msg=@"您的相册使用受限！";
        [LPAlertView alertViewWithTitle:@"温馨提示" message:msg completionBlock:^(NSUInteger buttonIndex) {
            block(NO);
        } cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    }
}

- (BOOL)isLocationAuthed
{
    CLAuthorizationStatus status=CLLocationManager.authorizationStatus;
    if (!CLLocationManager.locationServicesEnabled){
        return NO;
    } else if (kCLAuthorizationStatusNotDetermined==status){
        return NO;
    } else if (kCLAuthorizationStatusDenied==status){
        return NO;
    } else if (kCLAuthorizationStatusRestricted==status){
        return NO;
    }
    return YES;
}

- (void)authLocation:(void (^)(void))use_block done_block:(void (^)(BOOL ready))done_block
{
    CLAuthorizationStatus status=CLLocationManager.authorizationStatus;
    if (!CLLocationManager.locationServicesEnabled){
        use_block();
    } else if (kCLAuthorizationStatusNotDetermined==status){
        use_block();
    } else if (kCLAuthorizationStatusDenied==status){
        NSString *msg=@"请去-> [设置 - 隐私 - 定位 - 在路上] 打开访问开关";
        [LPAlertView alertViewWithTitle:@"温馨提示" message:msg completionBlock:^(NSUInteger buttonIndex) {
            done_block(NO);
        } cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    } else if (kCLAuthorizationStatusRestricted==status){
        NSString *msg=@"您的相册使用受限！";
        [LPAlertView alertViewWithTitle:@"温馨提示" message:msg completionBlock:^(NSUInteger buttonIndex) {
            done_block(NO);
        } cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    } else {
        done_block(YES);
    }
}

- (BOOL)isABAddressBookAuthed
{
    return NO;
}

- (void)authABAddressBook:(void (^)(BOOL ready))block
{
    block(NO);
}
@end
