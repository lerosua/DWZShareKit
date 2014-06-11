//
//  DWZShareContent.m
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-22.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import "DWZShareContent.h"
static int MaxLength = 130;

@implementation DWZShareContent
- (instancetype) initWitContent:(NSString *)pContent title:(NSString *)pTitle image:(UIImage *)pImage url:(NSString *)pUrl
{
    self = [super init];
    if(self){
        NSInteger length = pContent.length > MaxLength ? MaxLength :pContent.length;
        self.content = [pContent substringToIndex:length];
        self.title = pTitle;
        self.image = pImage;
        self.url = pUrl;
    }
    return self;
}
@end
