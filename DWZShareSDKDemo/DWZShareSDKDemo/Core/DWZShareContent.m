//
//  DWZShareContent.m
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-22.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import "DWZShareContent.h"

@implementation DWZShareContent
- (instancetype) initWitContent:(NSString *)pContent title:(NSString *)pTitle image:(UIImage *)pImage url:(NSString *)pUrl
{
    self = [super init];
    if(self){
        NSInteger length = pContent.length > 180 ? 180 :pContent.length;
        self.content = [pContent substringToIndex:length];
        self.title = pTitle;
        self.image = pImage;
        self.url = pUrl;
    }
    return self;
}
@end
