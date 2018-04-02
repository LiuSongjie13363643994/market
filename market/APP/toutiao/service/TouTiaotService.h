//
//  TouTiaotService.h
//  market
//
//  Created by 刘松杰 on 2018/3/24.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import "IService.h"
#import "TouTiao.h"

@interface TouTiaotService : IService
LP_SingleInstanceDec(TouTiaotService)

@property(nonatomic,strong,readonly) LPCollection *toutiaos;

- (void)firstProducts:(LPCollection *)toutiaos;
- (void)refreshProducts:(LPCollection *)toutiaos;
- (void)moreProducts:(LPCollection *)toutiaos;

@end
