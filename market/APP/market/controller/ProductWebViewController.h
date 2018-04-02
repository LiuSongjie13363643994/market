//
//  ProductWebViewController.h
//  market
//
//  Created by Lipeng on 2017/8/18.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "AIWebViewController.h"
#import "Product.h"

@interface ProductWebViewController : AIWebViewController
@property(nonatomic,strong) Product *product;
@property(nonatomic,assign) NSInteger product_id;
@end
