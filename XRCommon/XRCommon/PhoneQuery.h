//
//  PhoneQuery.h
//  XinRanApp
//
//  Created by tianbo on 15-1-28.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneQuery : NSObject


+ (void)query:(NSString*)phonenumber finished:(void(^)(NSString *addr))finished;
@end
