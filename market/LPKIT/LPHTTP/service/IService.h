//
//  IService.h
//  JamGo
//
//  Created by Lipeng on 2017/6/22.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpProxy.h"
#import "TransResp.h"

typedef void (^rm_result_block)(BOOL result,NSString *msg);

@interface IService : NSObject
@property(nonatomic,strong,readonly) HttpProxy *httpProxy;
@end
