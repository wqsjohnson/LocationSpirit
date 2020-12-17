//
//  LocationCollectViewController.h
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/17.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationCollectViewController : UIViewController
@property (nonatomic, copy) void(^selectLocationComplete)(CLLocationCoordinate2D locationCoordinate);
@end

NS_ASSUME_NONNULL_END
