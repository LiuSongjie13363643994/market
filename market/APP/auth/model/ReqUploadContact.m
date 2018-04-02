//
//  ReqUploadContact.m
//  market
//
//  Created by Lipeng on 2017/8/27.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "ReqUploadContact.h"

@implementation ReqUploadContact
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"contacts":ABContact.class};
}
@end
