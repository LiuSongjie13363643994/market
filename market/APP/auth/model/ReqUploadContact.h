//
//  ReqUploadContact.h
//  market
//
//  Created by Lipeng on 2017/8/27.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABContact.h"

@interface ReqUploadContact : NSObject
@property(nonatomic,strong) NSArray<ABContact *> *contacts;
@end
