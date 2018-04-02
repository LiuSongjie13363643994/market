//
//  DBBuilder.h
//
//
//  Created by Lipeng on 15-6-24.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import "LPDBCursor.h"
#import "LPDBValues.h"

@protocol LPDBBuilderDelegate<NSObject>
//转对象
- (id)build:(LPDBCursor *)cursor;
//转contentValues
- (LPDBValues *)deconstruct:(id)object;
@end
