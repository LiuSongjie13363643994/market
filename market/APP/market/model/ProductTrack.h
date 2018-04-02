//
//  ProductTrack.h
//  market
//
//  Created by Lipeng on 2017/8/22.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductTrack : NSObject
@property(nonatomic,assign) NSInteger apply_counts;
@property(nonatomic,assign) NSInteger loan_counts;
@property(nonatomic,strong) NSDate *date;
@end
