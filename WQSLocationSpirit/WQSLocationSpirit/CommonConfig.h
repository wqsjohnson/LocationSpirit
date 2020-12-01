//
//  CommonConfig.h
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/1.
//

#ifndef CommonConfig_h
#define CommonConfig_h
#import "UIDevice+MC.h"

//状态栏高度配置
#define kStatusGAP                      ([UIDevice isIphoneX] ? 44. : 20.)
//导航栏内容视图高度
#define kNavigationBarContentHeight     (44.)
//导航栏高度 (状态栏高度 + 导航栏内容视图高度)
#define kNavigationBarHeight            (kStatusGAP + kNavigationBarContentHeight)
#define UIDeviceScreenSize   [[UIScreen mainScreen] bounds].size
#define UIDeviceScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define UIDeviceScreenHeight [[UIScreen mainScreen] bounds].size.height

#endif /* CommonConfig_h */
