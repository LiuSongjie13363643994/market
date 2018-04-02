//
//  Cheat.h
//  market
//
//  Created by Lipeng on 2017/8/20.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cheat : NSObject
@property(nonatomic,assign) NSInteger cheat_id;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *tip;
@property(nonatomic,copy) NSString *cheat_url;
@property(nonatomic,copy) NSString *color;
@end
