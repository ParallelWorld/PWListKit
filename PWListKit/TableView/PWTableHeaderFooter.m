//
//  PWTableHeaderFooter.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWTableHeaderFooter.h"
#import "PWListConstant.h"


@implementation PWTableHeaderFooter

- (instancetype)init {
    self = [super init];
    _height = PWTableViewAutomaticDimension;
    return self;
}

- (NSString *)headerFooterIdentifier {
    NSAssert(self.headerFooterClass, @"cellClass不能为空");
    return NSStringFromClass(self.headerFooterClass);
}

@end
