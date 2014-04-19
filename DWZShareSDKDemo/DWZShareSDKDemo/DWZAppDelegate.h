//
//  DWZAppDelegate.h
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-17.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GESinaWeiboSDKAppKey            @"2336231021"
#define GETencentWeiboSDKAppKey         @"801495844"
#define GEQZoneSDKAppKey                @"101057351"

#define GESinaWeiboSDKAppSecret            @"c2c8d9720b33346a6c3ab297391e1eb7"
#define GETencentWeiboSDKAppSecret         @"9325b2a9ba96904e83038a09e2c8132a"
#define GEQZoneSDKAppSecret                @"9ed02b5f1e56c99b40114a81318b479f"

#define GESinaWeiboSDKAppUri            @"https://openapi.baidu.com/social/oauth/2.0/receiver"
#define GETencentWeiboSDKAppUr          @"http://sns.whalecloud.com/app/TOA5iO"
#define GEQZoneSDKAppUr                 @"http://app.5253.com/"

@interface DWZAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
