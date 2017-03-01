//
//  PWTableHeaderFooter.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"
#import <UIKit/UIKit.h>


@interface PWTableHeaderFooter : PWListNode

@property (nonatomic, readonly) NSString *headerFooterIdentifier;

@property (nonatomic) Class headerFooterClass;

@property (nonatomic) id data;

@property (nonatomic) CGFloat height;

@end
