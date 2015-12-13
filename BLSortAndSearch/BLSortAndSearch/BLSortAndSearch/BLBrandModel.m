//
//  BLBrandModel.m
//  BLSortAndSearch
//
//  Created by 班磊 on 15/12/11.
//  Copyright © 2015年 bennyban. All rights reserved.
//

#import "BLBrandModel.h"

@interface BLBrandModel ()

@end

@implementation BLBrandModel

- (id)init
{
    self = [super init];
    if (self) {
        _brand_name = @"";
        _Value      = @"";
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)itemDic
{
    self = [super init];
    if (self) {
        _brand_name = itemDic[@"brand_name"];
        _brand_id   = [itemDic[@"brand_id"] integerValue];
    }
    return self;
}

- (void)dealloc
{
    _brand_name = nil;
    _Value      = nil;
}


@end
