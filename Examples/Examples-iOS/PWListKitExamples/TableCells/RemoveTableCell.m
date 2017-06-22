//
//  RemoveTableCell.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/2.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "RemoveTableCell.h"

@implementation RemoveTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.textLabel.text = @"点我删除cell";
    return self;
}

- (void)updateWithRow:(PWTableRow *)row {
    
}

+ (CGFloat)cellHeight {
    return 44;
}

@end
