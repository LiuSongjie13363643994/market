//
//  ProductService.h
//  market
//
//  Created by Lipeng on 2017/8/21.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "IService.h"
#import "Product.h"
#import "ProductTrack.h"
#import "Topic.h"

@interface ProductService : IService
LP_SingleInstanceDec(ProductService)

@property(nonatomic,strong,readonly) LPCollection *grooms;
@property(nonatomic,strong,readonly) LPCollection *favs;
- (void)firstGrooms;
- (void)refreshGrooms;

- (LPCollection *)products:(Topic *)topic;

- (void)firstProducts:(LPCollection *)products;
- (void)refreshProducts:(LPCollection *)products;
- (void)moreProducts:(LPCollection *)products;

- (void)getTracks:(Product *)product block:(void (^)(NSArray<ProductTrack *> *tracks))block;
- (void)click:(Product *)product;

- (void)find:(NSString *)title block:(void (^)(BOOL result,Product *product,NSString *msg))block;
- (void)detail:(NSInteger)product_id block:(void (^)(BOOL result,Product *product,NSString *msg))block;
@end
