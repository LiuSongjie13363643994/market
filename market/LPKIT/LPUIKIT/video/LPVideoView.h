//
//  LPVideoView.h
//  DU365
//
//  Created by Lipeng on 16/6/29.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//视频视图
@interface LPVideoView : UIView
//是否自动播放
@property(nonatomic,assign) BOOL autoPlay;
//视频地址
@property(nonatomic,strong) NSURL *videoURL;
//音量
@property(nonatomic,assign) CGFloat volume;

//播放回调
@property(nonatomic,copy) void (^play_block)(BOOL result);
//秒数
@property(nonatomic,copy) void (^duration_block)(CGFloat seconds);
//缓冲
@property(nonatomic,copy) void (^cached_block)(CGFloat seconds);
//播放
@property(nonatomic,copy) void (^played_block)(CGFloat seconds);
//结束
@property(nonatomic,copy) void (^didend_block)(void);

//播放
- (void)play;
//暂停
- (void)pause;
//恢复
- (void)resume;
//停止
- (void)stop;
//重头播放
- (void)replay;
//
- (void)seekToTime:(NSInteger)seconds;

- (void)playWithPlayerItem:(AVPlayerItem *)item;

- (CGFloat)rate;
@end
