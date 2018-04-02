//
//  HttpProxy.m
//  JamGo
//
//  Created by Lipeng on 2017/6/19.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "HttpProxy.h"
#import "TransClient.h"

#define URL(path) [NSString stringWithFormat:@"%@/%@",k_host,path]

static NSString *k_host;
static http_user_id_block user_id_block;

@interface HttpProxy()
@property(nonatomic,strong) LPHttpClient *httpClient;
@property(nonatomic,strong) NSString *deviceId;
@property(nonatomic,strong) NSString *appVersion;
@end

@implementation HttpProxy

+ (void)setHost:(NSString *)host
{
    k_host=[host copy];
}
+ (void)setUserIdBlock:(http_user_id_block)block
{
    user_id_block=[block copy];
}
- (instancetype)init
{
    if (self=[super init]) {
        _httpClient=[[LPHttpClient alloc] init];
    }
    return self;
}
//207F1928-0AC6-459A-9344-F6AD8EE60A13
- (NSString *)deviceId
{
    if (nil==_deviceId) {
        _deviceId=[LPKit uuid];
    }
    return _deviceId;
}
- (NSString *)appVersion
{
    if (nil==_appVersion) {
        _appVersion=[[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"CFBundleShortVersionString"];
    }
    return _appVersion;
}
- (TransClient *)transClient
{
    CLLocation *location=[LPLocationManager shared].location;
    TransClient *client=[[TransClient alloc] init];
    client.user_id=user_id_block();
    client.os=1;
#if DEBUG
    client.app_id=5;
#else
    client.app_id=5;
#endif
    client.device_id=self.deviceId;
    client.channel=@"app_store";
    client.app_version=self.appVersion;
    client.latitude=location.coordinate.latitude;
    client.longitude=location.coordinate.longitude;
    if (0!=location.coordinate.latitude && 0!=location.coordinate.longitude){
        client.location=[NSString stringWithFormat:@"%@,%@",@(location.coordinate.longitude),@(location.coordinate.latitude)];
    }
    client.course=location.course;
    return client;
}
- (NSData *)equipRequest:(NSObject *)data
{
    TransClient *tclient=self.transClient;
    id client=(0==tclient.user_id)?[tclient mj_keyValuesWithIgnoredKeys:@[@"user_id"]]:tclient.mj_keyValues;
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:@{@"client":client}];
    if (nil!=data) {
        dic[@"data"]=data.mj_keyValues;
    }
    return [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
}

- (void)post:(NSString *)path data:(id)data class:(Class)class1 block:(http_resp_block)block
{
    [_httpClient HTTP_POST:URL(path) data:[self equipRequest:data] block:^(HTTPErrorCode statusCode, NSData *data) {
        TransResp *resp=nil;
        if (nil!=data) {
            id dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([dic isKindOfClass:NSDictionary.class]) {
                resp=[TransResp mj_objectWithKeyValues:dic];
                if (nil!=class1){
                    resp.data=[class1 mj_objectWithKeyValues:resp.data];
                }
            }
            if (nil==resp) {
                resp=[[TransResp alloc] init];
                resp.resp_code=1;
                resp.resp_msg=@"服务器繁忙，请稍后再试！";
            }
        } else {
            resp=[[TransResp alloc] init];
            resp.resp_code=-1;
            resp.resp_msg=@"网络不给力，请稍后再试！";
        }
        _filter_block(resp);
        block(resp);
    }];
}
- (void)post:(NSString *)path data:(id)data arrayClass:(Class)class1 block:(http_resp_block)block
{
    [_httpClient HTTP_POST:URL(path) data:[self equipRequest:data] block:^(HTTPErrorCode statusCode, NSData *data) {
        TransResp *resp=nil;
        if (nil!=data) {
            id dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([dic isKindOfClass:NSDictionary.class]) {
                resp=[TransResp mj_objectWithKeyValues:dic];
                resp.data=[class1 mj_objectArrayWithKeyValuesArray:resp.data];
            }
            if (nil==resp) {
                resp=[[TransResp alloc] init];
                resp.resp_code=1;
                resp.resp_msg=@"服务器繁忙，请稍后再试！";
            }
        } else {
            resp=[[TransResp alloc] init];
            resp.resp_code=-1;
            resp.resp_msg=@"网络不给力，请稍后再试！";
        }
        _filter_block(resp);
        block(resp);
    }];
}
@end
