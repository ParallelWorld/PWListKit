//
//  UITableView+PWTemplateLayoutCell.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/1.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <UIKit/UIKit.h>

/// AutoLayout自动算高
@interface UITableView (PWTemplateLayoutCell)

- (CGFloat)pw_heightForCellWithIdentifier:(NSString *)identifier cacheByIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(id cell))configuration;

- (CGFloat)pw_heightForHeaderWithIdentifier:(NSString *)identifier cacheBySection:(NSUInteger)section configuration:(void (^)(id header))configuration;

- (CGFloat)pw_heightForFooterWithIdentifier:(NSString *)identifier cacheBySection:(NSUInteger)section configuration:(void (^)(id footer))configuration;

- (void)pw_invalidateHeightForCellAtIndexPath:(NSIndexPath *)indexPath;

- (void)pw_invalidateHeightForHeaderAtSection:(NSUInteger)section;

- (void)pw_invalidateHeightForFooterAtSection:(NSUInteger)section;

@end
