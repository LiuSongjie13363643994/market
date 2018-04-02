//
//  LPVideoView.m
//  DU365
//
//  Created by Lipeng on 16/6/29.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import "LPVideoView.h"
#import <objc/runtime.h>

@interface LPTestVideoEndObject : NSObject
@property(nonatomic,strong) AVPlayerItem *item;
@end

@implementation LPTestVideoEndObject
@end

@interface LPVideoView()
//
@property(nonatomic,strong) AVPlayerLayer *playerLayer;
//
@property(nonatomic,strong) AVPlayerItem *playerItem;
//
@property(nonatomic,strong) AVURLAsset *asset;

@property(nonatomic,strong) AVPlayer *player;

@property(nonatomic,strong) id timeObserver;
@end

@implementation LPVideoView

- (void)dealloc
{
    LP_RemoveObserver(self);
    if (nil != _player) {
        [_player removeTimeObserver:_timeObserver];
        [_player removeObserver:self forKeyPath:@"status"];
    }
    if (nil != _playerItem) {
        [_playerItem removeObserver:self forKeyPath:@"duration"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    }
    [self removeObserver:self forKeyPath:@"frame"];
    
    self.play_block = nil;
    self.duration_block = nil;
    self.cached_block = nil;
    self.played_block = nil;
    self.didend_block = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        LP_AddObserver(AVPlayerItemDidPlayToEndTimeNotification, self, @selector(onDidEnd:));
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)onDidEnd:(NSNotification *)notify
{
    self.didend_block();
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([@"status" isEqualToString:keyPath]) {
        if (AVPlayerStatusReadyToPlay == _player.status) {
            [_player play];
            self.play_block(YES);
        }else{
            self.play_block(NO);
        }
    } else if ([@"duration" isEqualToString:keyPath]){
        if (AVPlayerStatusReadyToPlay==_player.status) {
            self.duration_block((CGFloat)CMTimeGetSeconds(_playerItem.duration));
        }
    } else if ([@"loadedTimeRanges" isEqualToString:keyPath]){
        if (AVPlayerStatusReadyToPlay==_player.status) {
            self.cached_block([self cachedDuration]);
        }
    } else if ([@"frame" isEqualToString:keyPath]){
        _playerLayer.frame=CGRectMake(0.f,0.f,CGViewGetWidth(self),CGViewGetHeight(self));
    }
}
//已经缓冲的秒数
- (CGFloat)cachedDuration
{
    NSArray *ranges = [_playerItem loadedTimeRanges];
    CMTimeRange timeRange = [ranges.firstObject CMTimeRangeValue];
    CGFloat startSeconds = CMTimeGetSeconds(timeRange.start);
    CGFloat durationSeconds = CMTimeGetSeconds(timeRange.duration);
    return (CGFloat)(startSeconds + durationSeconds);
}

//- (void)setVideoURL:(NSURL *)videoURL
//{
//    _videoURL=videoURL;
//}

- (void)praper4Playing
{
    __weak typeof(self) wself = self;
    if (nil != _player){
        [_player removeTimeObserver:_timeObserver];
        [_player removeObserver:self forKeyPath:@"status"];
        self.player = nil;
        self.timeObserver = nil;
    }
    _player = [[AVPlayer alloc] init];
    _player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
    [_player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    _timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)
                                                        queue:NULL
                                                   usingBlock:^(CMTime time) {
                                                       wself.played_block((CGFloat)CMTimeGetSeconds(time));
                                                   }];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = self.bounds;
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    _playerLayer.autoreverses = YES;
    [self.layer addSublayer:_playerLayer];
}

- (void)play
{
    [self praper4Playing];
    //创建视频资源
    _asset = [AVURLAsset URLAssetWithURL:_videoURL options:nil];
    //创建播放项
    _playerItem = [AVPlayerItem playerItemWithAsset:_asset];
    [_playerItem addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:NULL];
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.player replaceCurrentItemWithPlayerItem:_playerItem];
}

- (void)playWithPlayerItem:(AVPlayerItem *)item
{
    [self praper4Playing];
    if (nil != _playerItem){
        [_playerItem removeObserver:self forKeyPath:@"duration"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    }
    _playerItem = item;
    [_playerItem addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:NULL];
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.player replaceCurrentItemWithPlayerItem:_playerItem];
}

- (void)pause
{
    if (self.player.rate > 0.f) {
        [self.player pause];
    }
}

- (void)resume
{
    if (0 == self.player.rate) {
        [self.player play];
    }
}

- (void)stop
{
    if (self.player.rate > 0.f) {
        [self.player pause];
    }
    if (nil != _player){
        [_player removeTimeObserver:_timeObserver];
        [_player removeObserver:self forKeyPath:@"status"];
        self.player = nil;
        self.timeObserver = nil;
    }
    if (nil != _playerLayer) {
        [_playerLayer removeFromSuperlayer];
        self.playerLayer = nil;
    }
    if (nil != _playerItem){
        [_playerItem removeObserver:self forKeyPath:@"duration"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        _playerItem = nil;
    }

}

- (void)replay
{
    [self.player seekToTime:CMTimeMake(0, 1)];
    if (0.f == self.player.rate){
        [_player play];
    }
}

- (void)seekToTime:(NSInteger)seconds
{
    [self.player seekToTime:CMTimeMake(seconds, 1)];
}

- (CGFloat)rate
{
    return self.player.rate;
}

- (CGFloat)volume
{
    return self.player.volume;
}

- (void)setVolume:(CGFloat)volume
{
    self.player.volume = volume;
}
@end
