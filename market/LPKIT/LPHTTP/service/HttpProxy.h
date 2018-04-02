//
//  HttpProxy.h
//  JamGo
//
//  Created by Lipeng on 2017/6/19.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransResp.h"

typedef void (^http_resp_block)(TransResp *resp);
typedef NSInteger (^http_user_id_block)(void);

@interface HttpProxy : NSObject
+ (void)setHost:(NSString *)host;
+ (void)setUserIdBlock:(http_user_id_block)block;
@property(nonatomic,copy) void (^filter_block)(TransResp *resp);
- (void)post:(NSString *)path data:(id)data class:(Class)class1 block:(http_resp_block)block;
- (void)post:(NSString *)path data:(id)data arrayClass:(Class)class1 block:(http_resp_block)block;
@end
