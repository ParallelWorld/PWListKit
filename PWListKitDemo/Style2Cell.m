//
//  Style2Cell.m
//  Demo
//
//  Created by Huang Wei on 2017/2/27.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "Style2Cell.h"
#import "Masonry.h"


@implementation Style2Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.label1 = [UILabel new];
    self.label2 = [UILabel new];
    
    self.label2.numberOfLines = 0;
    
    [self.contentView addSubview:self.label1];
    [self.contentView addSubview:self.label2];
    
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(0);
    }];
    
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label1);
        make.top.equalTo(self.label1.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    
    return self;
}

- (void)configureWithData:(NSDictionary *)data {
    self.label1.text = data[@"title"];
    self.label2.text = data[@"id"];
}

@end
