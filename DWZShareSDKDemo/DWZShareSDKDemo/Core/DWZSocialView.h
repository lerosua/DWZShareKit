//
//  DWZSocialView.h
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-21.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWZSocialDelegate <NSObject>

- (void) socialButton:(UIButton *)sender clickedAtIndex:(NSInteger) index;

@end

@interface DWZSocialView : UIView

@property (nonatomic,weak) id<DWZSocialDelegate> delegate;

- (instancetype) initWithArray:(NSArray *)array;
- (void)show;
- (void)dismiss;
@end
