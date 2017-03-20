//
//  DemosViewController.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/2.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "DemosViewController.h"
#import "Masonry.h"
#import "PWListKit.h"
#import "LabelTableCell.h"



@interface DemosViewController () <UITableViewDelegate>

@property (nonatomic) UITableView *tableView;

@property (nonatomic) PWTableAdapter *tableAdapter;

@end

@implementation DemosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self loadData];
}

- (void)loadData {
    NSArray *controllerClassNames = [self controllerClassNames];
    
    [self.tableAdapter addSection:^(PWTableSection * _Nonnull section) {
        [controllerClassNames enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL * _Nonnull stop) {
            [section addRow:^(PWTableRow *row) {
                row.cellClass = [LabelTableCell class];
                row.data = @{@"title": name};
            }];
        }];
    }];
    
    [self.tableAdapter reloadTableView];
}

- (NSArray *)controllerClassNames {
    return @[@"TableDifferentCellHeightViewController",
             @"MixedDataViewController",
             @"EmptyViewController"];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PWTableRow *item = [self.tableAdapter itemAtIndexPath:indexPath];
    NSString *title = item.data[@"title"];
    Class controllerClass = NSClassFromString(title);
    UIViewController *controller = [controllerClass new];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
    }
    return _tableView;
}

- (PWTableAdapter *)tableAdapter {
    if (!_tableAdapter) {
        _tableAdapter = [[PWTableAdapter alloc] initWithTableView:self.tableView];
        _tableAdapter.tableDelegate = self;
    }
    return _tableAdapter;
}

@end
