//
//  UIDevice+MC.m
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/1.
//

#import "UIDevice+MC.h"
#include "sys/sysctl.h"

@implementation UIDevice (MC)
+ (BOOL)isDevicePad
{
    
    NSString * deviceType = [UIDevice currentDevice].model;
    
    if ( [deviceType rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].length > 0 ) {
        return YES;
    }
    return NO;
}

+ (CGSize)currentModelSize {
    UIScreen *screen = UIScreen.mainScreen;
    if (self.isDevicePad) {
        CGSize size = screen.bounds.size;
        CGFloat scale = screen.scale;
        return CGSizeMake(size.width * scale, size.height * scale);
    }
    return screen.currentMode.size;
}

+ (BOOL)requiresPhoneOS
{
    return [[[NSBundle mainBundle].infoDictionary objectForKey:@"LSRequiresIPhoneOS"] boolValue];
}

+ (BOOL)isPhone
{
    if ([self isPhone35] || [self isPhoneRetina35] || [self isPhoneRetina4])  {
        return YES;
    }
    return NO;
}

+ (BOOL)isIphoneX
{
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {//判断是否是手机
        return NO;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            return YES;
        }
    }
    return  [self isScreenSize:CGSizeMake(1125, 2436)]  /* iPhone X & iPhone XS */ ||
            [self isScreenSize:CGSizeMake(828, 1792)]   /* iPhone XR */ ||
            [self isScreenSize:CGSizeMake(1242, 2688)]  /* iPhone XS Max */;
}

+ (BOOL)isIphoneX_XS_11Pro {
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {//判断是否是手机
        return NO;
    }
    return [self isScreenSize:CGSizeMake(1125, 2436)];  /* iPhone X & iPhone XS & iphone11 Pro*/
}

+ (BOOL)isIphoneXr {
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {//判断是否是手机
        return NO;
    }
    return [self isScreenSize:CGSizeMake(828, 1792)]; /* iPhone XR or 11 */
}

+ (BOOL)isIphoneXsMax {
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {//判断是否是手机
        return NO;
    }
    return [self isScreenSize:CGSizeMake(1242, 2688)]  /* iPhone XS Max or 11 Pro Max*/;
}

+ (BOOL)isScreen35
{
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        return YES;
    }
    return NO;
}

+ (BOOL)isPhone35
{
    if ([self isDevicePad]) {
        if ([self requiresPhoneOS] && [self isPad]) {
            return YES;
        }
        return NO;
    }  else {
        return [self isScreenSize:CGSizeMake(320, 480)];
    }
}

+ (BOOL)isPhoneRetina35
{
    if ( [self isDevicePad] ) {
        if ( [self requiresPhoneOS] && [self isPadRetina] ) {
            return YES;
        }
        return NO;
    } else {
        return [self isScreenSize:CGSizeMake(640, 960)];
    }
}

+ (BOOL)isPhoneRetina4
{
    if ( [self isDevicePad])  {
        return NO;
    } else {
        return [self isScreenSize:CGSizeMake(640, 1136)];
    }
}

+ (BOOL)isPad
{
    return [self isScreenSize:CGSizeMake(768, 1024)];
}

+ (BOOL)isPadRetina
{
    return [self isScreenSize:CGSizeMake(1536, 2048)];
}

+ (BOOL)isScreenSize:(CGSize)size
{
    if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {
        CGSize size2 = CGSizeMake( size.height, size.width );
        CGSize screenSize = [UIScreen mainScreen].currentMode.size;
        
        if (CGSizeEqualToSize(size, screenSize) || CGSizeEqualToSize(size2, screenSize)) {
            return YES;
        }
    }
    return NO;
}

//////////////////
+ (float)floatVersion {
    return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue];
}

+ (BOOL)is66s78Plus {
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {//判断是否是手机
        return NO;
    }
    return [self isScreenSize:CGSizeMake(1242, 2208)];
}

+ (BOOL)is12All {
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {//判断是否是手机
        return NO;
    }
    return  [self isScreenSize:CGSizeMake(1284, 2778)]  /* iPhone 12 Pro MAX */ ||
            [self isScreenSize:CGSizeMake(1170, 2532)]  /* iPhone 12 (Pro) */ ||
            [self isScreenSize:CGSizeMake(1080, 2340)]  /* iPhone 12 mini*/;
}


- (NSString *)machine {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *name = (char *) malloc(size);
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    NSString *machine = [NSString stringWithCString:name encoding:NSASCIIStringEncoding];
    free(name);
    
    return machine;
}

- (NSString *)getDeviceType{
#if TARGET_IPHONE_SIMULATOR
    return @"ios_Simulator";
#else
    NSString* machine = [self machine];
    if (machine.length > 0) {
        if( [machine isEqualToString:@"iPhone1,1"] ) machine = @"iPhone1G";
        else if( [machine isEqualToString:@"iPhone1,2"] ) machine = @"iPhone3G";
        else if( [machine isEqualToString:@"iPhone2,1"] ) machine = @"iPhone3GS";
        else if( [machine isEqualToString:@"iPhone3,1"] ) machine = @"iPhone4";
        else if( [machine isEqualToString:@"iPhone3,2"] ) machine = @"iPhone4";
        else if( [machine isEqualToString:@"iPhone3,3"] ) machine = @"iPhone4";
        else if( [machine isEqualToString:@"iPhone4,1"] ) machine = @"iPhone4S";
        else if( [machine isEqualToString:@"iPhone5,1"] ) machine = @"iPhone5";
        else if( [machine isEqualToString:@"iPhone5,2"] ) machine = @"iPhone5";
        else if( [machine isEqualToString:@"iPhone5,3"] ) machine = @"iPhone5C";
        else if( [machine isEqualToString:@"iPhone5,4"] ) machine = @"iPhone5C";
        else if( [machine isEqualToString:@"iPhone6,1"] ) machine = @"iPhone5S";
        else if( [machine isEqualToString:@"iPhone6,2"] ) machine = @"iPhone5S";
        else if( [machine isEqualToString:@"iPhone7,2"] ) machine = @"iPhone6";
        else if( [machine isEqualToString:@"iPhone7,1"] ) machine = @"iP6 Plus";
        else if( [machine isEqualToString:@"iPhone8,1"] ) machine = @"iPhone6s";
        else if( [machine isEqualToString:@"iPhone8,2"] ) machine = @"iP6s Plus";
        else if( [machine isEqualToString:@"iPhone8,4"] ) machine = @"iPhone SE";
        else if( [machine isEqualToString:@"iPhone9,1"] ) machine = @"iPhone7";
        else if( [machine isEqualToString:@"iPhone9,3"] ) machine = @"iPhone7";
        else if( [machine isEqualToString:@"iPhone9,2"] ) machine = @"iP7 Pluss";
        else if( [machine isEqualToString:@"iPhone9,4"] ) machine = @"iP7 Plus";
        else if( [machine isEqualToString:@"iPhone10,1"] ) machine = @"iPhone8"; // @"国行(A1863)、日行(A1906)iPhone 8";
        else if( [machine isEqualToString:@"iPhone10,4"] ) machine = @"iPhone8"; // @"美版(Global/A1905)iPhone 8";
        else if( [machine isEqualToString:@"iPhone10,2"] ) machine = @"iP8 Plus"; // @"国行(A1864)、日行(A1898)iPhone 8 Plus";
        else if( [machine isEqualToString:@"iPhone10,5"] ) machine = @"iP8 Plus"; // @"美版(Global/A1897)iPhone 8 Plus";
        else if( [machine isEqualToString:@"iPhone10,3"] ) machine = @"iPhoneX"; // @"国行(A1865)、日行(A1902)iPhone X";
        else if( [machine isEqualToString:@"iPhone10,6"] ) machine = @"iPhoneX"; // @"美版(Global/A1901)iPhone X";
        else if( [machine isEqualToString:@"iPhone11,8"] ) machine = @"iPhone XR"; // @"(A1984/A2105/A2106/A2108)iPhone XR";
        else if( [machine isEqualToString:@"iPhone11,2"] ) machine = @"iPhone XS"; // @"(A1920/A2097/A2098/A2100)iPhone XS";
        else if( [machine isEqualToString:@"iPhone11,6"] ) machine = @"iPhone XS Max"; // @"(A1921/A2101/A2102/A2104)iPhone XS Max";
        else if( [machine isEqualToString:@"iPhone12,1"] ) machine = @"iPhone 11"; // @"(A2111/A2221/A2223)iPhone 11";
        else if( [machine isEqualToString:@"iPhone12,3"] ) machine = @"iPhone 11 Pro"; // @"(A2160/A2215/A2217)iPhone 11 Pro";
        else if( [machine isEqualToString:@"iPhone12,5"] ) machine = @"iPhone 11 Pro Max"; // @"(A2161/A2220/A2218)iPhone 11 Pro Max";
        else if( [machine isEqualToString:@"iPhone12,8"] ) machine = @"iPhone SE2"; // @"(A2275/A2296/A2298)iPhone SE2";
        else if( [machine isEqualToString:@"iPhone13,1"] ) machine = @"iPhone 12 mini"; // @"(A2176)iPhone 12 mini";
        else if( [machine isEqualToString:@"iPhone13,2"] ) machine = @"iPhone 12"; // @"(A2172)iPhone 12";
        else if( [machine isEqualToString:@"iPhone13,3"] ) machine = @"iPhone 12 Pro"; // @"(A2341)iPhone 12 Pro";
        else if( [machine isEqualToString:@"iPhone13,4"] ) machine = @"iPhone 12 Pro Max"; // @"(A2342)iPhone 12 Pro Max";
        else if( [machine isEqualToString:@"iPod1,1"] ) machine = @"iTouch1";
        else if( [machine isEqualToString:@"iPod2,1"] ) machine = @"iTouch2";
        else if( [machine isEqualToString:@"iPod3,1"] ) machine = @"iTouch3";
        else if( [machine isEqualToString:@"iPod4,1"] ) machine = @"iTouch4";
        else if( [machine isEqualToString:@"iPod5,1"] ) machine = @"iTouch5";
        else if( [machine isEqualToString:@"iPod7,1"] ) machine = @"iTouch6";
        else if( [machine isEqualToString:@"iPod9,1"] ) machine = @"iTouch7";
        else if( [machine isEqualToString:@"iPad1,1"] ) machine = @"iPad1";
        else if( [machine isEqualToString:@"iPad2,1"] ) machine = @"iPad2";
        else if( [machine isEqualToString:@"iPad2,2"] ) machine = @"iPad2";
        else if( [machine isEqualToString:@"iPad2,3"] ) machine = @"iPad2";
        else if( [machine isEqualToString:@"iPad2,4"] ) machine = @"iPad2";
        else if( [machine isEqualToString:@"iPad2,5"] ) machine = @"iPad mini1";
        else if( [machine isEqualToString:@"iPad2,6"] ) machine = @"iPad mini1";
        else if( [machine isEqualToString:@"iPad2,7"] ) machine = @"iPad mini1";
        else if( [machine isEqualToString:@"iPad3,1"] ) machine = @"iPad3";
        else if( [machine isEqualToString:@"iPad3,2"] ) machine = @"iPad3";
        else if( [machine isEqualToString:@"iPad3,3"] ) machine = @"iPad3";
        else if( [machine isEqualToString:@"iPad3,4"] ) machine = @"iPad4";
        else if( [machine isEqualToString:@"iPad3,5"] ) machine = @"iPad4";
        else if( [machine isEqualToString:@"iPad3,6"] ) machine = @"iPad4";
        else if( [machine isEqualToString:@"iPad4,1"] ) machine = @"iPad Air";
        else if( [machine isEqualToString:@"iPad4,4"] ) machine = @"iPad mini2";
        else if( [machine isEqualToString:@"iPad4,5"] ) machine = @"iPad mini2";
        else if( [machine isEqualToString:@"iPad4,6"] ) machine = @"iPad mini2";
        else if( [machine isEqualToString:@"iPad4,7"] ) machine = @"iPad mini3";
        else if( [machine isEqualToString:@"iPad4,8"] ) machine = @"iPad mini3";
        else if( [machine isEqualToString:@"iPad4,9"] ) machine = @"iPad mini3";
        else if( [machine isEqualToString:@"iPad5,1"] ) machine = @"iPad mini4";
        else if( [machine isEqualToString:@"iPad5,2"] ) machine = @"iPad mini4";
        else if( [machine isEqualToString:@"iPad5,3"] ) machine = @"iPad Air2";
        else if( [machine isEqualToString:@"iPad5,4"] ) machine = @"iPad Air2";
        else if( [machine isEqualToString:@"iPad6,3"] ) machine = @"iPad Pro (9.7-inch)";
        else if( [machine isEqualToString:@"iPad6,4"] ) machine = @"iPad Pro (9.7-inch)";
        else if( [machine isEqualToString:@"iPad6,7"] ) machine = @"iPad Pro (12.9-inch)";
        else if( [machine isEqualToString:@"iPad6,8"] ) machine = @"iPad Pro (12.9-inch)";
        else if( [machine isEqualToString:@"iPad7,3"] ) machine = @"iPad Pro(10.5-inch)";
        else if( [machine isEqualToString:@"iPad7,4"] ) machine = @"iPad Pro(10.5-inch)";
        else if( [machine isEqualToString:@"iPad8,1"] ) machine = @"iPad Pro(11-inch)";
        else if( [machine isEqualToString:@"iPad8,2"] ) machine = @"iPad Pro(11-inch)";
        else if( [machine isEqualToString:@"iPad8,3"] ) machine = @"iPad Pro(11-inch)";
        else if( [machine isEqualToString:@"iPad8,4"] ) machine = @"iPad Pro(11-inch)";
        else if( [machine isEqualToString:@"iPad7,1"] ) machine = @"iPad Pro2 (12.9-inch)";
        else if( [machine isEqualToString:@"iPad7,2"] ) machine = @"iPad Pro2 (12.9-inch)";
        else if( [machine isEqualToString:@"iPad8,9"] ) machine = @"iPad Pro2";
        else if( [machine isEqualToString:@"iPad8,10"] ) machine = @"iPad Pro2";
        else if( [machine isEqualToString:@"iPad8,5"] ) machine = @"iPad Pro3";
        else if( [machine isEqualToString:@"iPad8,6"] ) machine = @"iPad Pro3";
        else if( [machine isEqualToString:@"iPad8,7"] ) machine = @"iPad Pro3";
        else if( [machine isEqualToString:@"iPad8,8"] ) machine = @"iPad Pro3";
        else if( [machine isEqualToString:@"iPad8,11"] ) machine = @"iPad Pro4";
        else if( [machine isEqualToString:@"iPad8,12"] ) machine = @"iPad Pro4";
        else if( [machine isEqualToString:@"iPad11,1"] ) machine = @"iPad mini5";
        else if( [machine isEqualToString:@"iPad11,2"] ) machine = @"iPad mini5";
        
        else machine = @"iPhone6";
    }
    return machine;
    
#endif
}

- (BOOL)DeviceBeforIphone4sAndTouch
{
    NSString *deviceType = [self getDeviceType];
    if([deviceType isEqualToString:@"iPhone1G"] ||
       [deviceType isEqualToString:@"iPhone3G"] ||
       [deviceType isEqualToString:@"iPhone3GS"] ||
       [deviceType isEqualToString:@"iPhone4"] ||
       [deviceType isEqualToString:@"iPhone4S"] ||
       [deviceType rangeOfString:@"iTouch"].length > 0)
    {
        return YES;
    }
    return NO;
}

- (int64_t)diskSpaceFree {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

@end
