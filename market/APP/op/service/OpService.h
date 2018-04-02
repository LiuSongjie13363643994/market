//
//  OpService.h
//  market
//
//  Created by Lipeng on 2017/8/27.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "IService.h"

@interface OpService : IService
LP_SingleInstanceDec(OpService)
@property(nonatomic,strong) NSArray<NSString *> *tips;

@end
