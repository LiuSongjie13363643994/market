//
//  LPHttpClient.m
//  DU365
//
//  Created by Lipeng on 16/6/25.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import "LPHttpClient.h"
#import "NSURLSessionManager.h"


@implementation LPHttpClient

- (NSMutableURLRequest *)requestWithURL:(NSURL *)URL
                                 Method:(NSString *)method
                                   body:(NSData *)body
                               compress:(BOOL)compress
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = method;
    request.timeoutInterval = 20;
    request.HTTPBody = body;
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    request.HTTPShouldHandleCookies = NO;
    [request setValue:@"Accept-Encoding" forHTTPHeaderField:@"gzip"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    if (_header_block){
        NSDictionary *dic = _header_block();
        if (nil != dic) {
            for (NSString *key in dic.allKeys) {
                [request addValue:[NSString stringWithFormat:@"%@", dic[key]] forHTTPHeaderField:key];
            }
        }
    }
    return request;
}

- (void)asynWithURL:(NSURL *)URL
             method:(NSString *)method
               body:(NSData *)body
           compress:(BOOL)compress
              block:(http_complition_block)block
{
    NSURLSession *session = [[NSURLSessionManager shared] session];
    NSMutableURLRequest *request = [self requestWithURL:URL Method:method body:body compress:compress];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            session.numberOfTasking--;
            NSHTTPURLResponse *rsp=(NSHTTPURLResponse *)response;
            TRACE(@"[URL:%@]:[method:%@]:[status:%d][data:%s]", URL.absoluteString,method, (int)rsp.statusCode, (char *)data.bytes);
            block(rsp.statusCode, data);
        });
    }];
    session.numberOfTasking++;
    [task resume];
}

//- (void)syncWithURL:(NSURL *)URL
//             method:(NSString *)method
//               body:(NSData *)body
//           compress:(BOOL)compress
//              block:(http_complition_block)block
//{
//    NSURLSession *session = [[NSURLSessionManager shared] session];
//    NSMutableURLRequest *request = [self requestWithURL:URL Method:method body:body compress:compress];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            NSHTTPURLResponse *rsp = (NSHTTPURLResponse *)response;
//            TRACE(@"[URL:%@]:[method:%@]:[status:%d][data:%s]", URL.absoluteString,method, (int)rsp.statusCode, (char *)data.bytes);
//            block(rsp.statusCode, data);
//    }];
//    [task resume];
//}

//- (void)HTTP_POST:(NSString *)url data:(NSData *)data syncBlock:(http_complition_block)block
//{
//    [self syncWithURL:[NSURL URLWithString:url] method:@"POST" body:data compress:NO block:block];
//}
//
//- (void)HTTP_GET:(NSString *)url syncBlock:(http_complition_block)block
//{
//    [self syncWithURL:[NSURL URLWithString:url] method:@"GET" body:nil compress:NO block:block];
//}

//GET
- (void)HTTP_GET:(NSString *)url block:(http_complition_block)block
{
    [self asynWithURL:[NSURL URLWithString:url] method:@"GET" body:nil compress:NO block:block];
}
//PUT
- (void)HTTP_PUT:(NSString *)url data:(NSData *)data block:(http_complition_block)block
{
    [self asynWithURL:[NSURL URLWithString:url] method:@"PUT" body:data compress:NO block:block];
}
//POST
- (void)HTTP_POST:(NSString *)url data:(NSData *)data block:(http_complition_block)block
{
    [self asynWithURL:[NSURL URLWithString:url] method:@"POST" body:data compress:NO block:block];
}
//DELETE
- (void)HTTP_DELETE:(NSString *)url data:(NSData *)data block:(http_complition_block)block
{
    [self asynWithURL:[NSURL URLWithString:url] method:@"DELETE" body:data compress:NO block:block];
}

@end
