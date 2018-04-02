//
//  LPSIMDBBuilder.m
//  DU365
//
//  Created by Lipeng on 16/7/10.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import "LPSIMDBBuilder.h"

@implementation LPSIMDBRowsObject

@end

@implementation LPSIMDBRowsBuilder
//转对象
- (LPSIMDBRowsObject *)build:(LPDBCursor *)cursor
{
    LPSIMDBRowsObject *object=[[LPSIMDBRowsObject alloc] init];
    object.rows=[cursor integerOfColumn:@"count"];
    return object;
}
//转contentValues
- (LPDBValues *)deconstruct:(id)object
{
    return nil;
}
@end
