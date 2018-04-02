//
//  AuthService.m
//  market
//
//  Created by Lipeng on 2017/8/26.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "AuthService.h"
#import "ReqGrade.h"
#import "ReqUploadContact.h"


@implementation AuthService
LP_SingleInstanceImpl(AuthService)

- (void)grade:(void (^)(BOOL result,GradeLevel* grade,NSString *msg))block
{
    ReqGrade *grade=[[ReqGrade alloc] init];
    grade.abbook=[LPAuthProxy shared].isABAddressBookAuthed;
    grade.location=[LPAuthProxy shared].isLocationAuthed;
 
    void (^grade_block)(void)=^{
        [self.httpProxy post:credit_grade data:grade class:GradeLevel.class block:^(TransResp *resp) {
            block(0==resp.resp_code,resp.data,resp.resp_msg);
        }];
    };
    
    if (![LPAuthProxy shared].isABAddressBookAuthed){
        grade_block();
    } else {
        [self uploadABAdressbook:^(BOOL result, NSString *msg) {
            if (!result){
                block(NO,nil,msg);
            } else {
                grade_block();
            }
        }];
    }
}

- (void)uploadABAdressbook:(rm_result_block)block
{
    NSMutableArray *pbs=[NSMutableArray array];
    
    [[LJContactManager sharedInstance] accessSectionContactsComplection:^(BOOL succeed, NSArray<LJSectionPerson *> *contacts, NSArray<NSString *> *keys) {
        for (LJSectionPerson *section in contacts){
            NSLog(@"key=%@",section.key);
            for (LJPerson *person in section.persons){
                for (LJPhone *phone in person.phones){
                    NSLog(@"%@:%@",person.fullName,phone.phone);
                    
                    ABContact *ab=[[ABContact alloc] init];
                    ab.name=person.fullName;
                    ab.phone=phone.phone;
                    if (nil==LP_ReadUserDefault([self keyOfAb:ab])){
                        [pbs addObject:ab];
                    }
                }
            }
        }
        if (0==pbs.count){
            block(YES,nil);
        } else {
            ReqUploadContact *request=[[ReqUploadContact alloc] init];
            request.contacts=pbs;
            [self.httpProxy post:credit_upload_abs data:request class:nil block:^(TransResp *resp) {
                if (0==resp.resp_code){
                    for (ABContact *ab in pbs){
                        LP_WriteUserDefault([self keyOfAb:ab],@(1));
                    }
                }
                block(0==resp.resp_code,resp.resp_msg);
            }];
        }
    }];
}

- (NSString *)keyOfAb:(ABContact *)ab
{
    return [NSString stringWithFormat:@"kABContact_%@_key",ab.phone];
}
@end
