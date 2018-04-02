//
//  LPDBValues.m
//
//
//  Created by Lipeng on 15-6-24.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import "LPDBValues.h"

@interface LPDBValues()
@property(nonatomic, strong) NSMutableDictionary *rawdata;
@end

@implementation LPDBValues
- (id)init
{
    self = [super init];
    if (self) {
        _rawdata=[NSMutableDictionary dictionary];
    }
    return self;
}

- (void)put:(NSString *)key value:(id)value
{
    _rawdata[key]=value;
}

- (NSArray *)allKeys
{
    return [_rawdata allKeys];
}

- (id)valueForKey:(NSString *)key
{
    return _rawdata[key];
}
@end
