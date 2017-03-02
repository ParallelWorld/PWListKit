//
//  TableDifferentCellHeightViewController.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/2.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "TableDifferentCellHeightViewController.h"
#import "MultilineLabelTableCell.h"



@interface TableDifferentCellHeightViewController ()
@property (nonatomic) UITableView *tableView;

@property (nonatomic) PWTableAdapter *tableAdapter;
@end

@implementation TableDifferentCellHeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self loadData];
}

- (void)loadData {
    
    NSArray *data = [self data];

    
    [self.tableAdapter addSection:^(PWTableSection * _Nonnull section) {
        
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [section addItem:^(__kindof PWTableItem *item) {
                item.cellClass = [MultilineLabelTableCell class];
                item.data = @{@"largeText": obj};
            }];
        }];
    }];
    
    [self.tableAdapter reloadTableView];
}

- (NSArray *)data {
    NSMutableArray *mArray = [NSMutableArray new];
    NSString *s = @"";
    for (int i = 0; i < 100; i++) {
        s = [s stringByAppendingString:@(i).stringValue];
        [mArray addObject:s];
    }
    return mArray;
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
    }
    return _tableAdapter;
}


@end
