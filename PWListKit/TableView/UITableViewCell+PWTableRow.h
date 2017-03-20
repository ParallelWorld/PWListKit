//
//  UITableViewCell+PWTableRow.h
//  PWListKitDemo
//
//  Created by 黄魏 on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWTableRow;

@interface UITableViewCell (PWTableRow)

@property (nonatomic) PWTableRow *row;

@end
