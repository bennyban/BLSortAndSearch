//
//  BLBrandModel.h
//  BLSortAndSearch
//
//  Created by 班磊 on 15/12/11.
//  Copyright © 2015年 bennyban. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLBrandModel : NSObject

@property (nonatomic, assign) NSInteger brand_id;
@property (nonatomic, strong) NSString *brand_name;
@property (nonatomic, strong) NSString *Value;    /**< 索引数据标识符 */
@property (nonatomic, assign) NSInteger section;  /**< 索引分组，用来判断此数据属于哪个分组 */

/*!
 *  @brief  初始化数据
 *
 *  @param itemDic 将初始化的字典
 */
- (id)initWithDictionary:(NSDictionary *)itemDic;

@end
