//
//  DWZShareButton.m
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-21.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import "DWZShareButton.h"

@implementation DWZShareButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 51, 51)];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 51, 61, 21)];
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.logoImageView];
        [self addSubview:self.nameLabel];
        
        self.backgroundColor = [UIColor clearColor];
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

@end
