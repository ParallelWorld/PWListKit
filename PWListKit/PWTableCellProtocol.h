//
//  PWTableCellProtocol.h
//  Demo
//
//  Created by Huang Wei on 2017/2/27.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PWListConfigureProtocol.h"


@protocol PWTableCellProtocol <PWListConfigureProtocol>

@optional
+ (CGFloat)cellHeight;

@end
