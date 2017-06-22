//
//  EmptyViewController.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/2.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "EmptyViewController.h"
#import "Masonry.h"
#import "PWListKit.h"
#import "RemoveTableCell.h"


@interface EmptyViewController () <UITableViewDelegate, PWTableAdapterDataSource>

@property (nonatomic) UITableView *tableView;

@property (nonatomic) PWTableAdapter *tableAdapter;

@property (nonatomic) UIView *emptyView;

@end

@implementation EmptyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加cell" style:UIBarButtonItemStylePlain target:self action:@selector(clickAddCellButton)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tableAdapter addSection:^(PWTableSection * _Nonnull section) {
        [section addRow:^(PWTableRow * _Nonnull row) {
            row.cellClass = RemoveTableCell.class;
        }];
    }];
    
    [self.tableAdapter reloadTableView];
}


- (void)clickAddCellButton {
    [self.tableAdapter addSection:^(PWTableSection *section) {
        [section addRow:^(PWTableRow * _Nonnull row) {
            row.cellClass = RemoveTableCell.class;
        }];
    }];
    [self.tableAdapter reloadTableView];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (PWTableAdapter *)tableAdapter {
    if (!_tableAdapter) {
        _tableAdapter = self.tableView.adapter;
        _tableAdapter.tableDelegate = self;
        _tableAdapter.dataSource = self;
    }
    return _tableAdapter;
}

- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = [UIView new];
        _emptyView.backgroundColor = [UIColor lightGrayColor];
        
        UILabel *label = [UILabel new];
        label.text = @"I'm empty view";
        [_emptyView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_emptyView);
        }];
    }
    return _emptyView;
}

#pragma mark - PWTableAdapterDataSource

- (UIView *)emptyViewForTableAdapter:(PWTableAdapter *)adapter {
    return self.emptyView;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PWTableSection *section = [self.tableAdapter sectionAtIndex:indexPath.section];
    [section removeRowAtIndex:indexPath.row];
    [self.tableAdapter reloadTableView];
}

@end
