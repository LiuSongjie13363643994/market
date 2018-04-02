//
//  LPImagePicker.m
//  Beauty
//
//  Created by Lipeng on 2017/6/3.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "LPImagePicker.h"

@interface LPImagePicker()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic, weak) UIViewController *viewController;
@property(nonatomic, copy) void (^block)(UIImage *image);
@property(nonatomic, assign) BOOL allowsEditing;
@end

@implementation LPImagePicker
LP_SingleInstanceImpl(LPImagePicker)

- (void)pick:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing block:(void (^)(UIImage *image))block
{
    _block = block;
    _viewController = viewController;
    _allowsEditing = allowsEditing;
    __weak typeof(self) wself = self;
    [[LPActionSheet sheetWithTitle:nil buttonTitles:@[@"拍照",@"从相册选"] completionBlock:^(NSUInteger buttonIndex) {
        if (2!=buttonIndex){
            if (0==buttonIndex){
                [[LPAuthProxy shared] authCamera:^(BOOL ready) {
                    if (ready){
                        [wself showImagePickerController:UIImagePickerControllerSourceTypeCamera];
                    }
                }];
            } else {
                [[LPAuthProxy shared] authAlbum:^(BOOL ready) {
                    if (ready){
                        [wself showImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
                    }
                }];
            }
        }
    } ] showInView:_viewController.view];
}

- (void)showImagePickerController:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.allowsEditing = _allowsEditing;
    ipc.delegate = self;
    ipc.view.backgroundColor = LPColor(0xff,0xff,0xff,1);
    ipc.sourceType=sourceType;
    [_viewController presentViewController:ipc animated:YES completion:^{}];
}

#pragma mark
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    _block(_allowsEditing ? info[UIImagePickerControllerEditedImage] : info[UIImagePickerControllerOriginalImage]);
    _block = nil;
}
@end
