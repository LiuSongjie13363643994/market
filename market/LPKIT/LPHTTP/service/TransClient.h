//
//  TransClient.h
//  JamGo
//
//  Created by Lipeng on 2017/6/19.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransClient : NSObject
@property(nonatomic,assign) NSInteger app_id;
@property(nonatomic,strong) NSString *app_version;
@property(nonatomic,strong) NSString *device_id;
@property(nonatomic,assign) NSInteger os;
@property(nonatomic,strong) NSString *os_version;
@property(nonatomic,assign) NSInteger user_id;
@property(nonatomic,strong) NSString *channel;
@property(nonatomic,strong) NSString *location;
@property(nonatomic,assign) double latitude;
@property(nonatomic,assign) double longitude;
@property(nonatomic,assign) double course;
@end
