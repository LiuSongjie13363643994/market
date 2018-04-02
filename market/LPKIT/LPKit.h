//
//  LPKit.h
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

#import "LPFDKit.h"
#import "LPUIKit.h"
#import "LPDBKit.h"
#import "LPHttpClient.h"
#import "IService.h"
#import "LPCollection.h"
#import "MJExtension.h"
#import "LPKeychain.h"
#import "LJContactManager.h"
#import "LJPerson.h"
#import "LPNetworkAide.h"

#ifdef DEBUG
#define TRACE(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define TRACE_ERROR(fmt, ...) NSLog((@"%s [Line %d][Error] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#else

#define TRACE(...) do { } while (0)
#define TRACE_ERROR(...) do { } while (0)
#define NSLog(...) { }

#endif

extern void SwizzleSelector(Class c, SEL orig, SEL new1);

@interface LPKit : NSObject
+ (NSString *)uuid;
+ (void)loadSwizzling;
@end
