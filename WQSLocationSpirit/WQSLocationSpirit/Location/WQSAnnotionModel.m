//
//  WQSAnnotionModel.m
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/2.
//

#import "WQSAnnotionModel.h"
@interface WQSAnnotionModel()
@property (nonatomic, assign) CLLocationCoordinate2D myCoordinate;
@end

@implementation WQSAnnotionModel
- (NSString *)title {
    return self.name;
}

- (NSString *)subtitle {
    return nil;
}

- (CLLocationCoordinate2D)coordinate {
    return _myCoordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _myCoordinate = newCoordinate;
}
@end
