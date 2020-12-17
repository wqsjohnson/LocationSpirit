//
//  SearchViewController.h
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/1.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SearchPlaceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewController : UIViewController
@property (nonatomic, copy) void(^selectLocationComplete)(SearchPlaceModel *placeModel);
@end

NS_ASSUME_NONNULL_END
