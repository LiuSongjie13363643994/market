//
//  LPSIMDBBuilder.h
//  DU365
//
//  Created by Lipeng on 16/7/10.
//  Copyright © 2016年 DU365. All rights reserved.
//

#import <Foundation/Foundation.h>

//查询条数
@interface LPSIMDBRowsObject : NSObject
@property(nonatomic) NSInteger rows;
@end

@interface LPSIMDBRowsBuilder : NSObject<LPDBBuilderDelegate>

@end
