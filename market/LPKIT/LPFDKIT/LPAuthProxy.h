//
//  LPAuthProxy.h
//  JamGo
//
//  Created by Lipeng on 2017/7/4.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPAuthProxy : NSObject
LP_SingleInstanceDec(LPAuthProxy)

- (void)authCamera:(void (^)(BOOL ready))block;

- (void)authAlbum:(void (^)(BOOL ready))block;

- (BOOL)isLocationAuthed;

- (void)authLocation:(void (^)(void))use_block done_block:(void (^)(BOOL ready))done_block;

- (BOOL)isABAddressBookAuthed;

- (void)authABAddressBook:(void (^)(BOOL ready))block;

@end
