//
//  PWTableAdapter+UITableView.m
//  PWListKit
//
//  Created by Huang Wei on 2017/6/13.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWTableAdapter+UITableView.h"
#import "PWTableAdapterInternal.h"
#import "PWTableSection.h"
#import "PWTableRow.h"
#import "PWTableHeaderFooter.h"
#import "UITableView+PWTemplateLayoutCell.h"

@implementation PWTableAdapter (UITableView)

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellForRow:[self rowAtIndexPath:indexPath]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rootNode childAtIndex:section].children.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.rootNode.children.count;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForRow:[self rowAtIndexPath:indexPath]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self heightForHeaderFooter:[self sectionAtIndex:section].header];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self heightForHeaderFooter:[self sectionAtIndex:section].footer];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self viewForHeaderFooter:[self sectionAtIndex:section].header];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self viewForHeaderFooter:[self sectionAtIndex:section].footer];
}

#pragma mark - Private method

- (void)registerCellClassIfNeeded:(PWTableRow *)row {
    if (!row) return;
    
    Class clazz = row.clazz;
    NSString *className = NSStringFromClass(clazz);
    
    if ([self.registeredCellClasses containsObject:clazz]) {
        return;
    }
    
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
    if (nibPath) {
        [self.tableView registerNib:[UINib nibWithNibName:className bundle:nil] forCellReuseIdentifier:row.reuseIdentifier];
    } else {
        [self.tableView registerClass:clazz forCellReuseIdentifier:row.reuseIdentifier];
    }
    
    [self.registeredCellClasses addObject:clazz];
}

- (void)registerHeaderFooterClassIfNeeded:(PWTableHeaderFooter *)headerFooter {
    if (!headerFooter) return;
    
    Class clazz = headerFooter.clazz;
    NSString *className = NSStringFromClass(clazz);
    
    if ([self.registeredHeaderFooterClasses containsObject:clazz]) {
        return;
    }
    
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
    if (nibPath) {
        [self.tableView registerNib:[UINib nibWithNibName:className bundle:nil] forHeaderFooterViewReuseIdentifier:headerFooter.reuseIdentifier];
    } else {
        [self.tableView registerClass:clazz forHeaderFooterViewReuseIdentifier:headerFooter.reuseIdentifier];
    }
    
    [self.registeredHeaderFooterClasses addObject:clazz];
}

- (UITableViewCell *)cellForRow:(PWTableRow *)row {
    [self registerCellClassIfNeeded:row];
    
    UITableViewCell<PWTableCellConfigureProtocol> *cell = [self.tableView dequeueReusableCellWithIdentifier:row.reuseIdentifier forIndexPath:row.indexPath];
    
    [cell updateWithRow:row];
    
    return cell;
}

- (UIView *)viewForHeaderFooter:(PWTableHeaderFooter *)headerFooter {
    [self registerHeaderFooterClassIfNeeded:headerFooter];
    
    UITableViewHeaderFooterView<PWTableHeaderFooterConfigureProtocol> *headerFooterView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooter.reuseIdentifier];
    
    [headerFooterView updateWithHeaderFooter:headerFooter];
    
    return headerFooterView;
}

- (CGFloat)heightForHeaderFooter:(PWTableHeaderFooter *)headerFooter {
    [self registerHeaderFooterClassIfNeeded:headerFooter];
    
    if (headerFooter.height > 0) return headerFooter.height;
    
    return [self.tableView pw_heightForHeaderWithIdentifier:headerFooter.reuseIdentifier cacheBySection:headerFooter.section.section configuration:^(UITableViewHeaderFooterView<PWTableHeaderFooterConfigureProtocol> *view) {
        [view updateWithHeaderFooter:headerFooter];
    }];
}

- (CGFloat)heightForRow:(PWTableRow *)row {
    [self registerCellClassIfNeeded:row];
    
    if (row.height > 0) return row.height;
    
    return [self.tableView pw_heightForCellWithIdentifier:row.reuseIdentifier cacheByIndexPath:row.indexPath configuration:^(UITableViewCell<PWTableCellConfigureProtocol> *cell) {
        [cell updateWithRow:row];
    }];
}

@end
