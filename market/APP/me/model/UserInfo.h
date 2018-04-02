//
//  UserInfo.h
//  market
//
//  Created by 刘松杰 on 2018/3/24.
//  Copyright © 2018年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property(nonatomic,assign) int user_id;
@property(nonatomic,copy) NSString *header_url;
@property(nonatomic,copy) NSString *sex;
@property(nonatomic,copy) NSString *nick;
@end
