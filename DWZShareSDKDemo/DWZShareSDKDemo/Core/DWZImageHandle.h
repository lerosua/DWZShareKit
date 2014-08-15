//
//  DWZImageHandle.h
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-8-15.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TMO_UIKIT_DEVICE_WIDTH [UIScreen mainScreen].currentMode.size.width
#define TMO_UIKIT_DEVICE_HEIGHT [UIScreen mainScreen].currentMode.size.height
#define TMO_UIKIT_DEVICE_IS_RETINA (TMO_UIKIT_DEVICE_WIDTH == 640.0 || TMO_UIKIT_DEVICE_WIDTH == 1536.0)

@interface DWZImageHandle : NSObject

/**
 *  返回一张纯色的图片，大小为1px*1px
 *
 *  @param color 指定颜色UIColor对象
 *
 *  @return 返回UIImage对象
 */
+ (UIImage*)imageWithPureColor:(UIColor*)color;

/**
 *  返回一张被指定颜色覆盖的图片，图片必须为png格式
 *
 *  @param color 指定颜色UIColor对象
 *
 *  @return 处理后的UIImage对象
 */
+ (UIImage *)hanleImage:(UIImage *)image CoverWithColor:(UIColor *)color;

@end
