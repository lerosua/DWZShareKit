//
//  DWZSocialView.m
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-21.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import "DWZSocialView.h"
#import "DWZShareButton.h"

@implementation DWZSocialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self customInitView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void) customInitView
{
    DWZShareButton *sinaButton = [[DWZShareButton alloc] initWithFrame:CGRectMake(30, 0, 61, 82)];
    sinaButton.nameLabel.text = @"新浪微博";
    [sinaButton.logoImageView setImage:[UIImage imageNamed:@"SinaWeiboIcon"]];
    DWZShareButton *tencentButton = [[DWZShareButton alloc] initWithFrame:CGRectMake(121, 0, 61, 82)];
    tencentButton.nameLabel.text = @"腾讯微博";
    [tencentButton.logoImageView setImage:[UIImage imageNamed:@"TencentWeiboIcon"]];
    DWZShareButton *qZoneButton = [[DWZShareButton alloc] initWithFrame:CGRectMake(212, 0, 61, 82)];
    qZoneButton.nameLabel.text = @"QQ空间";
    [qZoneButton.logoImageView setImage:[UIImage imageNamed:@"qqZoneIcon"]];
    DWZShareButton *wechatButton = [[DWZShareButton alloc] initWithFrame:CGRectMake(121, 0, 61, 82)];
    wechatButton.nameLabel.text = @"微信好友";
    [wechatButton.logoImageView setImage:[UIImage imageNamed:@"wechatIcon"]];

    
    [self addSubview:sinaButton];
    [self addSubview:tencentButton];
    [self addSubview:qZoneButton];
    [self addSubview:wechatButton];
    
    self.backgroundColor = [UIColor clearColor];

}
@end
