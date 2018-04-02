//
//  ProductTableViewCell.h
//  market
//
//  Created by Lipeng on 2017/8/18.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "AITableViewCell.h"
#import "Product.h"

@interface ProductTableViewCell : AITableViewCell
@property(nonatomic,strong) Product *product;
+ (CGFloat)height;
@end
