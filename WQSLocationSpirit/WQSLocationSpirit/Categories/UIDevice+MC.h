//
//  UIDevice+MC.h
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (MC)
+ (BOOL)isDevicePad;

+ (BOOL)requiresPhoneOS;

@property (class, nonatomic, readonly) CGSize currentModelSize;

///是否为刘海屏
+ (BOOL)isIphoneX;
+ (BOOL)isIphoneXr;
+ (BOOL)isIphoneXsMax;
+ (BOOL)isIphoneX_XS_11Pro;
//如果是3.5寸屏
+ (BOOL)isScreen35;
+ (BOOL)isPhone;
+ (BOOL)isPhone35;
+ (BOOL)isPhoneRetina35;
+ (BOOL)isPhoneRetina4;
+ (BOOL)isPad;
+ (BOOL)isPadRetina;
+ (BOOL)isScreenSize:(CGSize)size;
+ (BOOL)is66s78Plus;
+ (BOOL)is12All;

- (NSString*)machine;
- (NSString*)getDeviceType;
- (BOOL)DeviceBeforIphone4sAndTouch;

// copied from YYCategories
- (int64_t)diskSpaceFree;
@end

NS_ASSUME_NONNULL_END
