//
//  PWTableHeaderFooter.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWTableHeaderFooter.h"

@implementation PWTableHeaderFooter

- (NSString *)headerFooterIdentifier {
    NSAssert(self.headerFooterClass, @"cellClass不能为空");
    return NSStringFromClass(self.headerFooterClass);
}

@end
