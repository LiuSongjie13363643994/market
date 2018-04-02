//
//  LPURLProtocol.m
//  Beauty
//
//  Created by Lipeng on 2017/6/10.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "LPURLProtocol.h"

static NSString*const FilteredCssKey = @"filteredCssKey";

@interface LPURLProtocol()
@property (nonatomic, strong) NSMutableData   *responseData;
@property (nonatomic, strong) NSURLConnection *connection;
@end

@implementation LPURLProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    TRACE(@"canInitWithRequest %@",request);
    if ([NSURLProtocol propertyForKey:FilteredCssKey inRequest:request]){
        return NO;
    }
    return YES;
}
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    TRACE(@"canonicalRequestForRequest %@",request);
    return request;
}
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}
- (void)startLoading
{
//    [super startLoading];
    TRACE(@"startLoading");
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:FilteredCssKey inRequest:mutableReqeust];
    self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
}
- (void)stopLoading
{
//    [super stopLoading];
    TRACE(@"stopLoading");
    if (self.connection != nil)
    {
        [self.connection cancel];
        self.connection = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[NSMutableData alloc] init];
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}
@end
