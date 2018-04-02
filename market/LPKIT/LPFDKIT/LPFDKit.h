//
//  LPFDKit.h
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#ifndef HR_LPFDKit_h
#define HR_LPFDKit_h

#define IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define LP_SingleInstanceDec(class)  +(class *)shared;
#define LP_SingleInstanceImpl(class) +(class *)shared{\
                                            static id instance=nil;\
                                            static dispatch_once_t onceToken;\
                                            dispatch_once(&onceToken, ^{\
                                                instance=[[class alloc] init];\
                                            });\
                                            return instance;\
                                        };

#define LP_AddObserver(NAME,OBSERVER,SELECTOR) [[NSNotificationCenter defaultCenter] addObserver:OBSERVER selector:SELECTOR name:NAME object:nil]
#define LP_RemoveObserver(OBSERVER) [[NSNotificationCenter defaultCenter] removeObserver:OBSERVER]
#define LP_PostNotification(NAME,OBJECT,USERINFO) [[NSNotificationCenter defaultCenter] postNotificationName:NAME object:OBJECT userInfo:USERINFO]


#define LP_WriteUserDefault(KEY,OBJECT) {[[NSUserDefaults standardUserDefaults] setObject:OBJECT forKey:KEY];\
                                         [[NSUserDefaults standardUserDefaults] synchronize];\
                                        }
#define LP_RemoveUserDefault(KEY) {[[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY];\
                                    [[NSUserDefaults standardUserDefaults] synchronize];\
                                    }
#define LP_ReadUserDefault(KEY)   [[NSUserDefaults standardUserDefaults] objectForKey:KEY]

#import "LPNotifyBus.h"
#import "NSAttributedString+LP.h"
#import "NSString+LP.h"
#import "NSNumber+LP.h"
#import "NSDate+LP.h"
#import "NSMutableArray+LP.h"
#import "LPURLProtocol.h"
#import "LPLocationManager.h"
#import "LPFileManager.h"
#import "LPAuthProxy.h"
#import "NSData+LP.h"
#import "LPEventBus.h"
#endif
