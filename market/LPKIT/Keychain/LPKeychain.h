//
//  LPKeychain.h
//  DU365
//
//  Created by xuyuqiang on 16/8/25.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPKeychain : NSObject
- (id)load:(NSString *)service;
- (void)save:(NSString *)service data:(id)data;
- (void)delete:(NSString *)service;
@end
