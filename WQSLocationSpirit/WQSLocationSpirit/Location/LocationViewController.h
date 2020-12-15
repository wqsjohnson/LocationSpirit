//
//  LocationViewController.h
//  WQSLocationSpirit
//  定位控制器
//  Created by xtkj20180621 on 2020/12/14.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LocationViewControllerTypeSysMap,//系统地图
    LocationViewControllerTypeAMap,//高德地图
} LocationViewControllerType;
NS_ASSUME_NONNULL_BEGIN

@interface LocationViewController : UIViewController
@property (nonatomic, assign) LocationViewControllerType type;
@end

NS_ASSUME_NONNULL_END
