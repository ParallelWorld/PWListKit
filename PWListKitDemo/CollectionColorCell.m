//
//  CollectionStyle1Cell.m
//  Demo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "CollectionColorCell.h"
#import "Masonry.h"

@implementation CollectionColorCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.titleLabel = [UILabel new];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    self.backgroundColor = [UIColor purpleColor];
    return self;
}

- (void)configureWithData:(NSString *)data {
    self.titleLabel.text = data;
}

+ (CGSize)cellSize {
    return CGSizeMake(100, 100);
}

@end
