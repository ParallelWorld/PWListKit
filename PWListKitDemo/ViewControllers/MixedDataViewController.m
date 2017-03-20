//
//  MixedDataViewController.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/2.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "MixedDataViewController.h"
#import "TableHeaderView.h"
#import "LabelTableCell.h"
#import "CarouselTableCell.h"
#import "TableFooterView.h"

@interface MixedDataViewController ()

@property (nonatomic) UITableView *tableView;

@property (nonatomic) PWTableAdapter *tableAdapter;

@end

@implementation MixedDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self loadData];
}

- (void)loadData {
    
    [self.tableAdapter addSection:^(PWTableSection *section) {
        
        for (NSUInteger sectionIndex = 0; sectionIndex < 10; sectionIndex++) {
            [section setHeader:^(PWTableHeaderFooter *header) {
                header.headerFooterClass = [TableHeaderView class];
                header.data = @{@"title": [NSString stringWithFormat:@"section%@-Header", @(sectionIndex)]};
            }];
            
            [section addItem:^(PWTableRow *row) {
                row.cellClass = [LabelTableCell class];
                row.data = @{@"title": @"LabelTableCell"};
            }];
            
            
            [section addItem:^(PWTableRow *row) {
                row.cellClass = [CarouselTableCell class];
                NSMutableArray *mArray = [NSMutableArray new];
                for (int k = 0; k < 10; k++) {
                    [mArray addObject:@(k).stringValue];
                }
                row.data = mArray.copy;
            }];
            
            [section setFooter:^(PWTableHeaderFooter *footer) {
                footer.headerFooterClass = [TableFooterView class];
                footer.data = @{@"title": [NSString stringWithFormat:@"section%@-Footer", @(sectionIndex)]};
            }];
        }
    }];
    
    [self.tableAdapter reloadTableView];
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
