//
//  ProductService.m
//  market
//
//  Created by Lipeng on 2017/8/21.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "ProductService.h"
#import "ReqGetTopicProducts.h"
#import "LPMemoryCache.h"

@interface ProductService()
//topic->products
@property(nonatomic,strong) NSMutableDictionary<NSString *,LPCollection *> *productsDic;
@end

@implementation ProductService
LP_SingleInstanceImpl(ProductService)

- (instancetype)init{
    if (self=[super init]) {
        _grooms=[[LPCollection alloc] init];
        _favs=[[LPCollection alloc] init];
        _productsDic=[NSMutableDictionary dictionary];
    }
    return self;
}

- (void)firstGrooms
{
    [self remoteGrooms:kLoading_First];
}
- (void)refreshGrooms
{
    [self remoteGrooms:kLoading_Refresh];
}
- (void)remoteGrooms:(Loading_State)state
{
    rm_fetch_done_block block=[_grooms blockOfState:state];
    if (kLoading_NA!=_grooms.state){
        [_grooms block:block result:NO count:0 echo:0 msg:nil];
        return;
    }
    _grooms.state=state;
    NSInteger session=_grooms.session;
    [self.httpProxy post:product_groom data:nil arrayClass:Product.class block:^(TransResp *resp) {
        if (_grooms.session==session){
            NSArray *as=resp.data;
            if (0==resp.resp_code){
                [_grooms.items removeAllObjects];
                [_grooms.items addObjectsFromArray:as];
            }
            _grooms.state=kLoading_NA;
            [_grooms block:block result:YES count:as.count echo:nil msg:nil];
        }
    }];
}

- (LPCollection *)products:(Topic *)topic
{
    LPCollection *products=_productsDic[topic.code];
    if (nil==products) {
        products=[[LPCollection alloc] init];
        products.object=topic.code;
        _productsDic[topic.code]=products;
    }
    return products;
}
- (void)firstProducts:(LPCollection *)products
{
    [self remoteProducts:products state:kLoading_First];
}
- (void)refreshProducts:(LPCollection *)products
{
    [self remoteProducts:products state:kLoading_Refresh];
}
- (void)moreProducts:(LPCollection *)products
{
    [self remoteProducts:products state:kLoading_More];
}

- (void)remoteProducts:(LPCollection *)products state:(Loading_State)state
{
    rm_fetch_done_block block=[products blockOfState:state];
    if (kLoading_NA!=products.state) {
        [products block:block result:NO count:0 echo:nil msg:nil];
        return;
    }
    ReqGetTopicProducts *request=[[ReqGetTopicProducts alloc] init];
    request.code=products.object;
    request.page_no=(kLoading_More==state)?(products.items.count+49)/50:0;
    request.page_size=50;
    
    NSInteger session=products.session;
    [self.httpProxy post:product_topic data:request arrayClass:Product.class block:^(TransResp *resp) {
        if (session==products.session){
            NSArray *a=nil;
            if (0==resp.resp_code) {
                a=(NSArray *)resp.data;
                if (kLoading_More!=state){
                    [products.items removeAllObjects];
                }
                [products.items addDiffObjectsFromArray:a];
                products.hasmore=(a.count>=50);
            }
            products.state=kLoading_NA;
            [products block:block result:0==resp.resp_code count:a.count echo:products.object msg:nil];
        }
    }];
}

- (void)getTracks:(Product *)product block:(void (^)(NSArray<ProductTrack *> *tracks))block
{
    NSString *key=[NSString stringWithFormat:@"track_%@",@(product.product_id)];
    id mem=LP_GetObjectOnCacheMemory(key);
    if (nil!=mem) {
        block(mem);
    } else {
        [self.httpProxy post:product_get_tracks data:@(product.product_id) arrayClass:ProductTrack.class block:^(TransResp *resp) {
            if (0==resp.resp_code){
                block(resp.data);
                LP_PutObjectInCacheMemory(resp.data,key,LP_MemoryMin(5));
            } else {
                block(nil);
            }
        }];
    }
}
- (void)click:(Product *)product
{
    [self.httpProxy post:product_click data:@(product.product_id) class:nil block:^(TransResp *resp) {}];
}

- (void)find:(NSString *)title block:(void (^)(BOOL result,Product *product,NSString *msg))block
{
    [self.httpProxy post:product_find data:title class:Product.class block:^(TransResp *resp) {
        block(0==resp.resp_code,resp.data,resp.resp_msg);
    }];
}

- (void)detail:(NSInteger)product_id block:(void (^)(BOOL result,Product *product,NSString *msg))block
{
    [self.httpProxy post:product_get_detail data:@(product_id) class:Product.class block:^(TransResp *resp) {
        block(0==resp.resp_code,resp.data,resp.resp_msg);
    }];
}
@end
