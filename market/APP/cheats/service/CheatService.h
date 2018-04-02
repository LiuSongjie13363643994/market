//
//  CheatService.h
//  market
//
//  Created by Lipeng on 2017/8/21.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "IService.h"
#import "Cheat.h"

@interface CheatService : IService
LP_SingleInstanceDec(CheatService)

@property(nonatomic,strong,readonly) LPCollection<Cheat *> *cheats;

- (void)firstCheats;
- (void)refreshCheats;
- (void)moreCheats;

- (void)readCheat:(Cheat *)cheat;
@end
