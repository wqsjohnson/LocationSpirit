//
//  MaAnnotationView.h
//  WQSLocationSpirit
//
//  Created by xtkj20180621 on 2020/12/25.
//

#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MaAnnotationView : MAAnnotationView
@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

NS_ASSUME_NONNULL_END
