//
//  DWZImageHandle.m
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-8-15.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import "DWZImageHandle.h"

@implementation DWZImageHandle

+ (UIImage*)imageWithPureColor:(UIColor*)color{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context  = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)hanleImage:(UIImage *)image CoverWithColor:(UIColor *)color
{
    CGSize originSize;

    originSize = image.size;
    UIGraphicsBeginImageContext(originSize);
    
    CGRect contextRect;
    contextRect.origin.x = 0.0f;
    contextRect.origin.y = 0.0f;
    contextRect.size = originSize;
    // Retrieve source image and begin image context
    CGSize itemImageSize = originSize;
    CGPoint itemImagePosition;
    itemImagePosition.x = ceilf((contextRect.size.width - itemImageSize.width) / 2);
    itemImagePosition.y = ceilf((contextRect.size.height - itemImageSize.height) );
    
    UIGraphicsBeginImageContext(contextRect.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    // Setup shadow
    // Setup transparency layer and clip to mask
    CGContextBeginTransparencyLayer(c, NULL);
    CGContextScaleCTM(c, 1.0, -1.0);
    CGContextClipToMask(c, CGRectMake(itemImagePosition.x, -itemImagePosition.y, itemImageSize.width, -itemImageSize.height), [image CGImage]);
    // Fill and end the transparency layer
    
    
    const CGFloat* colors = CGColorGetComponents( color.CGColor );
    CGContextSetRGBFillColor(c, colors[0], colors[1], colors[2], .75);
    
    contextRect.size.height = -contextRect.size.height;
    contextRect.size.height -= 15;
    CGContextFillRect(c, contextRect);
    CGContextEndTransparencyLayer(c);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;

}
@end
