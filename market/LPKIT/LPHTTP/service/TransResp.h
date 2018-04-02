//
//  TransResp.h
//  JamGo
//
//  Created by Lipeng on 2017/6/19.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransResp<T> : NSObject
@property(nonatomic,assign) NSInteger resp_code;
@property(nonatomic,copy) NSString *resp_msg;
@property(nonatomic, copy) NSString *online_txt;
@property(nonatomic,strong) T data;
@end
