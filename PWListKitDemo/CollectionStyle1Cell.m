//
//  CollectionStyle1Cell.m
//  Demo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "CollectionStyle1Cell.h"
#import "Masonry.h"

@implementation CollectionStyle1Cell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.titleLabel = [UILabel new];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    self.backgroundColor = [UIColor redColor];
    return self;
}

- (void)configureWithData:(NSString *)data {
    self.titleLabel.text = data;
}

@end
