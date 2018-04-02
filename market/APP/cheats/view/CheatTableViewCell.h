//
//  CheatTableViewCell.h
//  market
//
//  Created by Lipeng on 2017/8/19.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "AITableViewCell.h"
#import "Cheat.h"

@interface CheatTableViewCell : AITableViewCell
@property(nonatomic,strong) Cheat *cheat;
+ (CGFloat)height;
@end
