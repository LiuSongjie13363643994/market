//
//  ViewStateObject.m
//  JamGo
//
//  Created by Lipeng on 2017/6/23.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "ViewStateObject.h"

@implementation ViewStateObject
+ (ViewStateObject *)initWithState:(ViewState)state object:(NSObject *)object
{
    ViewStateObject *ob=[[ViewStateObject alloc] init];
    ob.state=state;
    ob.object=object;
    return ob;
}
@end
