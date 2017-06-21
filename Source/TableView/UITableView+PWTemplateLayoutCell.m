//
//  UITableView+PWTemplateLayoutCell.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/1.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "UITableView+PWTemplateLayoutCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import <objc/runtime.h>


@implementation UITableView (PWTemplateLayoutCell)

#pragma mark - Public method

- (CGFloat)pw_heightForCellWithIdentifier:(NSString *)identifier cacheByIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(id))configuration {
    return [self fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:configuration];
}

- (CGFloat)pw_heightForHeaderWithIdentifier:(NSString *)identifier cacheBySection:(NSUInteger)section configuration:(void (^)(id header))configuration {
    return [self pw_heightForHeaderFooterWithIdentifier:identifier cacheByIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] configuration:configuration];
}

- (CGFloat)pw_heightForFooterWithIdentifier:(NSString *)identifier cacheBySection:(NSUInteger)section configuration:(void (^)(id footer))configuration {
    return [self pw_heightForHeaderFooterWithIdentifier:identifier cacheByIndexPath:[NSIndexPath indexPathForRow:1 inSection:section] configuration:configuration];
}

- (void)pw_invalidateHeightForCellAtIndexPath:(NSIndexPath *)indexPath {
    [self.fd_indexPathHeightCache invalidateHeightAtIndexPath:indexPath];
}

- (void)pw_invalidateHeightForHeaderAtSection:(NSUInteger)section {
    [self.pw_headerFooterHeightCache invalidateHeightAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
}

- (void)pw_invalidateHeightForFooterAtSection:(NSUInteger)section {
    [self.pw_headerFooterHeightCache invalidateHeightAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section]];
}

#pragma mark - Private method

/// indexPath中row为0表示header，1表示footer。
- (CGFloat)pw_heightForHeaderFooterWithIdentifier:(NSString *)identifier cacheByIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(id))configuration {
    if (!identifier) {
        return 0;
    }
    
    if ([self.pw_headerFooterHeightCache existsHeightAtIndexPath:indexPath]) {
        return [self.pw_headerFooterHeightCache heightForIndexPath:indexPath];
    }
    
    CGFloat height = [self pw_heightForHeaderWithIdentifier:identifier configuration:configuration];
    [self.pw_headerFooterHeightCache cacheHeight:height byIndexPath:indexPath];
    
    return height;
}

- (CGFloat)pw_heightForHeaderWithIdentifier:(NSString *)identifier configuration:(void (^)(id))configuration {
    if (!identifier) {
        return 0;
    }
    
    UITableViewHeaderFooterView *templateHeaderFooter = [self pw_templateHeaderFooterForReuseIdentifier:identifier];
    
    [templateHeaderFooter prepareForReuse];
    
    if (configuration) {
        configuration(templateHeaderFooter);
    }
    
    CGFloat contentViewWidth = CGRectGetWidth(self.frame);
    
    CGSize fittingSize = CGSizeZero;
    
    if (contentViewWidth > 0) {
        // Add a hard width constraint to make dynamic content views (like labels) expand vertically instead
        // of growing horizontally, in a flow-layout manner.
        NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:templateHeaderFooter.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
        [templateHeaderFooter.contentView addConstraint:widthFenceConstraint];
        // Auto layout engine does its math
        fittingSize = [templateHeaderFooter.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        [templateHeaderFooter.contentView removeConstraint:widthFenceConstraint];
    }
    
    return fittingSize.height;
}

- (__kindof UITableViewHeaderFooterView *)pw_templateHeaderFooterForReuseIdentifier:(NSString *)identifier {
    NSAssert(identifier.length > 0, @"identifier不能为空");
    
    NSMutableDictionary *templateHeaderFootersByIdentifiers = objc_getAssociatedObject(self, _cmd);
    if (!templateHeaderFootersByIdentifiers) {
        templateHeaderFootersByIdentifiers = [NSMutableDictionary new];
        objc_setAssociatedObject(self, _cmd, templateHeaderFootersByIdentifiers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    UITableViewHeaderFooterView *templateHeaderFooter = templateHeaderFootersByIdentifiers[identifier];
    
    if (!templateHeaderFooter) {
        templateHeaderFooter = [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        templateHeaderFooter.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        templateHeaderFootersByIdentifiers[identifier] = templateHeaderFooter;
    }
    
    return templateHeaderFooter;
}

- (FDIndexPathHeightCache *)pw_headerFooterHeightCache {
    FDIndexPathHeightCache *cache = objc_getAssociatedObject(self, _cmd);
    if (!cache) {
        cache = [FDIndexPathHeightCache new];
        objc_setAssociatedObject(self, _cmd, cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cache;
}

@end
