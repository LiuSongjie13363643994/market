//
//  AuthService.h
//  market
//
//  Created by Lipeng on 2017/8/26.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "IService.h"
#import "Product.h"
#import "GradeLevel.h"

@interface AuthService : IService
LP_SingleInstanceDec(AuthService)
- (void)grade:(void (^)(BOOL result,GradeLevel* grade,NSString *msg))block;
- (void)uploadABAdressbook:(rm_result_block)block;
@end
