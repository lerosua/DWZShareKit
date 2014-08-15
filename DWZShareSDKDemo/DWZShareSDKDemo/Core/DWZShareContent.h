//
//  DWZShareContent.h
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-22.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWZShareContent : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,strong) UIImage *image;
//要分享的大图 不要超过10M
@property (nonatomic,strong) UIImage *shareImage;

- (instancetype) initWitContent:(NSString *)pContent title:(NSString *)pTitle image:(UIImage *)pImage url:(NSString *)pUrl;
@end
