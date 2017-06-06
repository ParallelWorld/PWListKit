//
//  TableFooterView.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/2.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "TableFooterView.h"
#import "Masonry.h"


@implementation TableFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    self.contentView.backgroundColor = [UIColor greenColor];
    
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

- (void)updateWithHeaderFooter:(PWTableHeaderFooter *)headerFooter {
    self.middleTitleLabel.text = headerFooter.data[@"title"];
}

@end
