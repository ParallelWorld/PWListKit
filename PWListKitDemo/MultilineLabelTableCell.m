//
//  MultilineLabelTableCell.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/2.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "MultilineLabelTableCell.h"
#import "Masonry.h"

@implementation MultilineLabelTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.multilineLabel = [UILabel new];
    self.multilineLabel.numberOfLines = 0;
    [self.contentView addSubview:self.multilineLabel];
    
    [self.multilineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    return self;
}

- (void)configureWithData:(id)data {
    self.multilineLabel.text = data[@"largeText"];
}

@end
