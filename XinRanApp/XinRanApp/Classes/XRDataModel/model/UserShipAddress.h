//
//  UserShipAddress.h
//  XRDataModel
//
//  Created by libj on 15/4/28.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"


@interface UserShipAddress : BaseModel
{
    
}
@property (nonatomic,strong) NSString *shipAddressId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *areaId;
@property (nonatomic,strong) NSString *detailAddress;
@property (nonatomic,strong) NSString *phone;

@end
