//
//  CommonMapSettingManager.h
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/15.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LocationViewControllerTypeSysMap,//系统地图
    LocationViewControllerTypeAMap,//高德地图
} LocationViewControllerType;
NS_ASSUME_NONNULL_BEGIN

@interface CommonMapSettingManager : NSObject
@property (nonatomic, assign) LocationViewControllerType type;
+ (instancetype)manager;
@end

NS_ASSUME_NONNULL_END
