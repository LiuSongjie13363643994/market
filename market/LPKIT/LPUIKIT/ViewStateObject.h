//
//  ViewStateObject.h
//  JamGo
//
//  Created by Lipeng on 2017/6/23.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ViewState){
    ViewState_Loading,
    ViewState_Done,
    ViewState_Empty
};

@interface ViewStateObject : NSObject
@property(nonatomic,assign) ViewState state;
@property(nonatomic,strong) NSObject *object;
+ (ViewStateObject *)initWithState:(ViewState)state object:(NSObject *)object;
@end
