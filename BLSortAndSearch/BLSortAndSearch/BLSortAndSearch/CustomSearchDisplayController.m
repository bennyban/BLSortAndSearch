//
//  CustomSearchDisplayController.m
//  BLSortAndSearch
//
//  Created by 班磊 on 15/12/13.
//  Copyright © 2015年 bennyban. All rights reserved.
//

#import "CustomSearchDisplayController.h"

@implementation CustomSearchDisplayController

-(void)setActive:(BOOL)visible animated:(BOOL)animated
{
    BOOL isHiddenNaviBar = NO; // 默认是隐藏，如果不隐藏请设置为NO
    
    if (isHiddenNaviBar) {
        [super setActive:visible animated:animated];
    } else
    {
        [super setActive:visible animated:NO];
        [self.searchContentsController.navigationController setNavigationBarHidden: NO animated: NO];
    }
}

@end
