//
//  LPFileManager.h
//  JamGo
//
//  Created by Lipeng on 2017/6/22.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^file_store_block)(NSString *key);

@interface LPFileManager : NSObject
LP_SingleInstanceDec(LPFileManager)

//- (BOOL)diskFileExistForKey:(NSString *)key;
//- (NSData *)dataForKey:(NSString *)key;
//- (void)storeData:(NSData *)data forKey:(NSString *)key block:(file_store_block)block;
//
//- (void)removeFileAtPath:(NSString *)path;
@end
