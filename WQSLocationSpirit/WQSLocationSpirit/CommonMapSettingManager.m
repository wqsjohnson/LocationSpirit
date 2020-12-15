//
//  CommonMapSettingManager.m
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/15.
//

#import "CommonMapSettingManager.h"

@implementation CommonMapSettingManager
+ (instancetype)manager {
    static CommonMapSettingManager *_settingInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _settingInstance = CommonMapSettingManager.new;
        _settingInstance.type = LocationViewControllerTypeSysMap;
    });
    return _settingInstance;
}
@end
