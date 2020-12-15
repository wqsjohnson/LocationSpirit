//
//  SearchPlaceModel.h
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchPlaceModel : NSObject
///名称
@property (nonatomic, copy) NSString *name;
///纬度（垂直方向）
@property (nonatomic, assign) float latitude;
///经度（水平方向）
@property (nonatomic, assign) float longitude;
@end

NS_ASSUME_NONNULL_END
