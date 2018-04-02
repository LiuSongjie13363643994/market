//
//  NSURLSessionManager.h
//  DU365
//
//  Created by Lipeng on 16/7/21.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURLSession+LP.h"

@interface NSURLSessionManager : NSObject
LP_SingleInstanceDec(NSURLSessionManager)
- (NSURLSession *)session;
@end
