//
//  WQSAnnotionModel.h
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/2.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WQSAnnotionModel : NSObject<MKAnnotation,MAAnnotation>
@property (nonatomic, copy) NSString *name;
@end

NS_ASSUME_NONNULL_END
