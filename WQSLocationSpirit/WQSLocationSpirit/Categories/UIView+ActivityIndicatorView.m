//
//  UIView+ActivityIndicatorView.m
//  yueedai
//
//  Created by shiqichao on 15/4/22.
//  Copyright (c) 2015年 DC. All rights reserved.
//

#import "UIView+ActivityIndicatorView.h"
#import "FuncMacro.h"
#import "MBProgressHUD.h"
typedef NS_ENUM(NSInteger,HUDState) {
    HUDStateNone,
    HUDStateLoading,
    HUDStateFinished,
};

@interface MBProgressHUD (CKAfterDelay)

@property(nonatomic,assign)HUDState hUDState;

-(void)ck_show:(BOOL)animated afterDelay:(NSTimeInterval)delay;
-(void)ck_hide:(BOOL)animated;
-(void)ck_hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

@end


@implementation MBProgressHUD (CKAfterDelay)

SYNTHESIZE_CATEGORY_VALUE_PROPERTY(HUDState, hUDState, setHUDState:);

-(void)ck_show:(BOOL)animated afterDelay:(NSTimeInterval)delay{
    if (delay > 0) {
        [self performSelector:@selector(ck_showDelayed:)
                   withObject:[NSNumber numberWithBool:animated]
                   afterDelay:delay];
    }else{
        [self show:animated];
    }
}

- (void)ck_showDelayed:(NSNumber *)animated{
    if (self.hUDState == HUDStateFinished) {
        self.hUDState = HUDStateNone;
    }else{
        self.hUDState = HUDStateLoading;
        [self show:[animated boolValue]];
    }
}

-(void)ck_hide:(BOOL)animated{
    self.hUDState = HUDStateFinished;
    [self hide:animated];
}

-(void)ck_hide:(BOOL)animated afterDelay:(NSTimeInterval)delay{
    self.hUDState = HUDStateFinished;
    [self hide:animated afterDelay:delay];
}

@end


@implementation UIView (ActivityIndicatorView)

#pragma mark --提示消息
- (MBProgressHUD *)promptMessage:(NSString *)text
{
    return [self promptMessage:text afterDelay:1.f];
}
- (MBProgressHUD *)promptMessage:(NSString *)text afterDelay:(NSTimeInterval)delay
{
    return [self promptMessage:text
                    afterDelay:delay
                   touchEnable:NO];
}

-(MBProgressHUD *)promptMessage:(NSString *)text
                     afterDelay:(NSTimeInterval)delay
                    touchEnable:(BOOL)enable {
    if (text.length == 0) {
        return nil;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15];
    hud.dimBackground=NO;
    hud.userInteractionEnabled = !enable;
    
    [hud hide:YES afterDelay:delay];
    return hud;
}

#pragma mark --开始加载提示
- (void)showActivityViewWithTitle:(NSString *)text{
    [self showActivityViewWithTitle:text enabled:YES afterDelay:0];
}

- (void)showActivityViewWithTitle:(NSString *)text afterDelay:(NSTimeInterval)delay{
    [self showActivityViewWithTitle:text enabled:YES afterDelay:delay];
}

- (void)showActivityViewWithTitle:(NSString *)text enabled:(BOOL)enabled{
    [self showActivityViewWithTitle:text enabled:enabled afterDelay:0];
}

- (void)showActivityViewWithTitle:(NSString *)text enabled:(BOOL)enabled afterDelay:(NSTimeInterval)delay {
    [self showActivityViewWithTitle:text enabled:enabled afterDelay:delay windowCenter:NO];
}
- (void)showActivityViewWithTitle:(NSString *)text enabled:(BOOL)enabled afterDelay:(NSTimeInterval)delay windowCenter:(BOOL)flag {
    [self.activity hide:YES];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15];
    hud.removeFromSuperViewOnHide = YES;
    hud.backgroundColor = [UIColor clearColor];
    [self addSubview:hud];
    [hud ck_show:YES afterDelay:delay];
    hud.userInteractionEnabled = enabled;
    self.activity=hud;
}

- (void)showActivityViewWithTitle:(NSString *)text windowCenter:(BOOL)flag{
    [self showActivityViewWithTitle:text enabled:YES afterDelay:0 windowCenter:flag];
}

- (void)hiddenActivity{
    [self hiddenActivityWithTitle:nil];
}

//停止加载提示
- (void)hiddenActivityWithTitle:(NSString *)text{
    [self hiddenActivityWithTitle:text afterDelay:1.f];
}

- (void)hiddenActivityWithTitle:(NSString *)text afterDelay:(NSTimeInterval)delay {
    if (text.length > 0) {
        self.activity.mode = MBProgressHUDModeText;
        self.activity.detailsLabelText = text;
        self.activity.detailsLabelFont = [UIFont systemFontOfSize:15];
        self.activity.backgroundColor = [UIColor clearColor];
        [self.activity ck_hide:YES afterDelay:delay];
    }else{
        [self.activity ck_hide:YES];
    }
    self.activity = nil;
}

#pragma mark -
static char activityKey;
-(void)setActivity:(MBProgressHUD *)activity
{
    if (activity) {
        objc_setAssociatedObject(self, &activityKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, &activityKey, activity, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

-(MBProgressHUD *)activity
{
    MBProgressHUD *activity = objc_getAssociatedObject(self, &activityKey);
    return activity;
}
@end
