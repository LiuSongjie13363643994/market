//
//  LPHttpClient.h
//  DU365
//
//  Created by Lipeng on 16/6/25.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger){
    kHTTPErrorCode_0=0,
    kHTTPErrorCode_200=200,
    kHTTPErrorCode_206=206,
}HTTPErrorCode;

typedef void (^http_complition_block)(HTTPErrorCode statusCode, NSData *data);

@interface LPHttpClient : NSObject
//
- (void)HTTP_GET:(NSString *)url block:(http_complition_block)block;
//
- (void)HTTP_PUT:(NSString *)url data:(NSData *)data block:(http_complition_block)block;
//
- (void)HTTP_POST:(NSString *)url data:(NSData *)data block:(http_complition_block)block;
//
- (void)HTTP_DELETE:(NSString *)url data:(NSData *)data block:(http_complition_block)block;
//- (void)HTTP_POST:(NSString *)url data:(NSData *)data syncBlock:(http_complition_block)block;
//
//- (void)HTTP_GET:(NSString *)url syncBlock:(http_complition_block)block;

@property(nonatomic, copy) NSDictionary *(^header_block)(void);

@end
