//
//  Style1Cell.m
//  Demo
//
//  Created by Huang Wei on 2017/2/27.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "Style1Cell.h"

@implementation Style1Cell

- (void)configureWithData:(id)data {
    self.leftImageView.image = [UIImage imageNamed:data[@"image"]];
    self.rightLabel.text = data[@"label"];
}

@end
