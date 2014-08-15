//
//  DWZSocialView.m
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-21.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import "DWZSocialView.h"
#import "DWZShareKit.h"
#import "DWZCustomShareObject.h"
#import "DWZImageHandle.h"

#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width

@interface DWZSocialView(){
    UIControl *backgroundView;
}
@property (nonatomic, strong,readonly) NSArray *array;
@end

@implementation DWZSocialView

- (instancetype) initWithArray:(NSArray *)array withDelegate:(id<DWZSocialDelegate>)pDelegate
{
    self = [self initWithFrame:[UIScreen mainScreen].bounds];
    if(self){
        _array = array;
        _delegate = pDelegate;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
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
    self.backgroundColor = [UIColor clearColor];
    backgroundView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [backgroundView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    backgroundView.backgroundColor = [UIColor colorWithRed:59/255.0
                                                              green:59/255.0
                                                               blue:59/255.0
                                                              alpha:0.5];
    backgroundView.alpha = 0;
    [self addSubview:backgroundView];

}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGFloat width = 270;
    CGFloat height = 210;
    
    if([self.array count]<=3){
        height = height/2 + 20;
    }
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - width) / 2, (SCREEN_HEIGHT - height) / 2, width, height)];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.cornerRadius = 5;
    [self addSubview:containerView];
    int x;
    int y;
    
    int i = 0;
    for (NSNumber *number in self.array) {
        int num = [number integerValue];
        if ((i + 1) % 3) {
            x = (i + 1) % 3;
            y = (i + 1) / 3;
        } else {
            x = 3;
            y = (i + 1) / 3 - 1;
        }

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90 * ( x - 1 ), 75 + 90 * y, 90, 30)];
        label.text = [self shareTypeNameWith: [self.array[i] integerValue]];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor colorWithRed:95/255.0
                                          green:95/255.0
                                           blue:95/255.0
                                          alpha:1.0];
        [containerView addSubview:label];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(5 + 90 * ( x - 1 ), 10 + 90 * y, 80, 80);
        button.tag = num;
        NSString *imageName =[self shareIconNameWith:[self.array[i] integerValue]];

        UIImage *image;
        if(imageName){
            image = [UIImage imageNamed:[self shareIconNameWith:[self.array[i] integerValue]]];
        }
        
        //check app valide
        switch (num) {
            case ShareTypeSinaWeibo:
                if(![DWZShareKit isWeiboInstalled]){
                    button.enabled = NO;
                    image = [DWZImageHandle hanleImage:image CoverWithColor:[UIColor colorWithRed:240/255 green:240/255 blue:240/255 alpha:1.0]];

                }
                break;
                case ShareTypeQQ:
                case ShareTypeQQSpace:
                if(![DWZShareKit isQQInstalled]){
                    button.enabled = NO;
                    image = [DWZImageHandle hanleImage:image CoverWithColor:[UIColor colorWithRed:240/255 green:240/255 blue:240/255 alpha:1.0]];


                }
                break;
                case ShareTypeWeChatSession:
                case ShareTypeWeChatTimeline:
                if(![DWZShareKit isWeChatInstalled]){
                    image = [DWZImageHandle hanleImage:image CoverWithColor:[UIColor colorWithRed:240/255 green:240/255 blue:240/255 alpha:1.0]];
                    button.enabled = NO;
                }
                break;
                case ShareTypeCustom:
                {
                    if(self.customShareObject){
                        label.text = self.customShareObject.name;
                        image = self.customShareObject.icons;
                    }

                }
                break;
            default:
                break;
        }
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:button];
        
        ++i;
        
        
    }
    
}

- (void)shareAction:(UIButton *)button
{
    if(self.delegate){
        [self.delegate socialButton:button clickedAtIndex:button.tag];
    }
    [self dismiss];

}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.35;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:popAnimation forKey:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.15 animations:^{
            backgroundView.alpha = 0.5;
        }];
    });
}

#pragma mark -
- (NSString *) shareTypeNameWith:(ShareType )type
{
    switch (type) {
        case ShareTypeSinaWeibo:
            return  @"新浪微博";
            break;
        case ShareTypeQQ:
            return  @"QQ好友";
            break;
        case ShareTypeQQSpace:
            return  @"QQ空间";
            break;
        case ShareTypeWeChatSession:
            return  @"微信好友";
            break;
        case ShareTypeWeChatTimeline:
            return  @"微信朋友圈";
            break;
            
        default:
            break;
    }
    return nil;
}

- (NSString *) shareIconNameWith:(ShareType)type
{
    switch (type) {
        case ShareTypeSinaWeibo:
            return  @"dwzsharesdk_sinaweibo";
            break;
        case ShareTypeQQ:
            return  @"dwzsharesdk_qq";
            break;
        case ShareTypeQQSpace:
            return  @"dwzsharesdk_qqzone";
            break;
        case ShareTypeWeChatSession:
            return  @"dwzsharesdk_wechat";
            break;
        case ShareTypeWeChatTimeline:
            return  @"dwzsharesdk_wechattimeline";
            break;
            
        default:
            break;
    }
    return nil;
}


@end
