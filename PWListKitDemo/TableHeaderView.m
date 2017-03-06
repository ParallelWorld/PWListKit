//
//  TableHeaderView.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "TableHeaderView.h"
#import "Masonry.h"

@implementation TableHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    self.contentView.backgroundColor = [UIColor redColor];
    
    self.middleTitleLabel = [UILabel new];
    self.middleTitleLabel.numberOfLines = 0;
    
    [self.contentView addSubview:self.middleTitleLabel];
    [self.middleTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(20);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    return self;
}

- (void)populateData:(NSDictionary *)data {
    self.middleTitleLabel.text = data[@"title"];
}

@end
