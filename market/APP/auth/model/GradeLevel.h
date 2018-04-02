//
//  GradeLevel.h
//  market
//
//  Created by Lipeng on 2017/8/28.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GradeLevel : NSObject
@property(nonatomic,copy) NSString *level;
@property(nonatomic,strong) NSArray<NSString *> *suggests;
@end
