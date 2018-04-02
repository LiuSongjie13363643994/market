//
//  AppCreditView.h
//  market
//
//  Created by Lipeng on 2017/8/26.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface AppCreditView : UIView
@property(nonatomic,strong) Product *product;

@property(nonatomic,copy) void (^apply_block)(Product *product);
@end
