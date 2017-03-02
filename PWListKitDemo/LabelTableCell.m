//
//  LabelTableCell.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/2.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "LabelTableCell.h"

@implementation LabelTableCell

- (void)configureWithData:(id)data {
    self.textLabel.text = data[@"title"];
}

+ (CGFloat)cellHeight {
    return 50;
}

@end
