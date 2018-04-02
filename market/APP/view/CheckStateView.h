//
//  CheckView.h
//  market
//
//  Created by Lipeng on 2017/8/26.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

enum{
    kCheckState_NA,
    kCheckState_No,
    kCheckState_YES,
};

@interface CheckStateView : UIImageView
@property(nonatomic,assign) NSInteger state;
@end
