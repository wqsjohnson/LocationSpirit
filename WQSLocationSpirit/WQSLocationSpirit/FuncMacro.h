//
//  FuncMacro.h
//  PrivateDoctor
//
//  Created by sqc on 15/7/6.
//  Copyright (c) 2015年 mingyou. All rights reserved.
//

#ifndef PrivateDoctor_FuncMacro_h
#define PrivateDoctor_FuncMacro_h
#import <objc/runtime.h>

#pragma mark --关联方法宏定义
/*
 用法
 @property(nonatomic,assign)NSInteger pageCount;//基本类型属性
 @property(nonatomic,assign)NSArray *dataArray;//对象类型属性
 
 ////基本类型使用方法
 SYNTHESIZE_CATEGORY_VALUE_PROPERTY(NSInteger, pageCount, setPageCount:);
 //对象类型使用方法
 SYNTHESIZE_CATEGORY_OBJ_PROPERTY(dataArray, setDataArray:);
 
 */

//基本类型
#define SYNTHESIZE_CATEGORY_VALUE_PROPERTY(valueType, propertyGetter, propertySetter)\
- (valueType) propertyGetter {\
valueType ret = {0};\
[objc_getAssociatedObject(self, @selector( propertyGetter )) getValue:&ret];\
return ret;\
}\
- (void) propertySetter (valueType)value{\
NSValue *valueObj = [NSValue valueWithBytes:&value objCType:@encode(valueType)];\
objc_setAssociatedObject(self, @selector( propertyGetter ), valueObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#endif
