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
    
    self.navigationItem.rightBarButtonItems =
    @[[[UIBarButtonItem alloc] initWithTitle:@"add" style:UIBarButtonItemStyleDone target:self action:@selector(add)],
      [[UIBarButtonItem alloc] initWithTitle:@"move" style:UIBarButtonItemStyleDone target:self action:@selector(move)],
      [[UIBarButtonItem alloc] initWithTitle:@"delete" style:UIBarButtonItemStyleDone target:self action:@selector(delete)],
      [[UIBarButtonItem alloc] initWithTitle:@"modify" style:UIBarButtonItemStyleDone target:self action:@selector(modify)]];
}

- (void)modify {
    [self.tableAdapter reloadTableWithBlock:^{
        PWTableSection *section = [self.tableAdapter sectionAtIndex:0];
        [section removeRowAtIndex:0];
        
        [self.tableAdapter moveSectionFrom:0 to:1];

    }];
}
- (void)move {
    [self.tableAdapter reloadTableWithBlock:^{
        [self.tableAdapter moveSectionFrom:0 to:1];
    }];
}

- (void)delete {
    [self.tableAdapter reloadTableWithBlock:^{
        [self.tableAdapter removeSectionAtIndex:0];
    }];
}

- (void)add {
    
    static int count = 0;
    [self.tableAdapter reloadTableWithBlock:^{
        [self.tableAdapter addSection:^(PWTableSection * _Nonnull section) {
            
            section.tag = [NSString stringWithFormat:@"third%@", @(count++)];

            for (int i = 0; i<2; i++) {
                [section addRow:^(PWTableRow * _Nonnull row) {
                    row.clazz = [LabelTableCell class];
                    row.data = @{@"title": [NSString stringWithFormat:@"%zi-%zi", row.indexPath.section, row.indexPath.row]};
                }];
            }
            
        }];
        [self.tableAdapter removeSectionAtIndex:2];
        
    }];
    
    
}

- (void)loadData {
    
    [self.tableAdapter addSection:^(PWTableSection *section) {
        
        section.tag = @"first";
        
        for (NSUInteger sectionIndex = 0; sectionIndex < 2; sectionIndex++) {
//            [section configureHeader:^(PWTableHeaderFooter *header) {
//                header.clazz = [TableHeaderView class];
//                header.data = @{@"title": [NSString stringWithFormat:@"section%@-Header", @(sectionIndex)]};
//            }];
            
            [section addRow:^(PWTableRow * _Nonnull row) {
                row.clazz = [LabelTableCell class];
                row.data = @{@"title": [NSString stringWithFormat:@"%zi-%zi", row.indexPath.section, row.indexPath.row]};
            }];
            
        
            
//            [section configureFooter:^(PWTableHeaderFooter *footer) {
//                footer.clazz = [TableFooterView class];
//                footer.data = @{@"title": [NSString stringWithFormat:@"section%@-Footer", @(sectionIndex)]};
//            }];
        }
    }];
    
    
    [self.tableAdapter addSection:^(PWTableSection *section) {
        
        section.tag = @"second";

        for (NSUInteger sectionIndex = 0; sectionIndex < 2; sectionIndex++) {
//            [section configureHeader:^(PWTableHeaderFooter *header) {
//                header.clazz = [TableHeaderView class];
//                header.data = @{@"title": [NSString stringWithFormat:@"section%@-Header", @(sectionIndex)]};
//            }];
            
            [section addRow:^(PWTableRow * _Nonnull row) {
                row.clazz = [LabelTableCell class];
                row.data = @{@"title": [NSString stringWithFormat:@"%zi-%zi", row.indexPath.section, row.indexPath.row]};
            }];
//            
//            [section configureFooter:^(PWTableHeaderFooter *footer) {
//                footer.clazz = [TableFooterView class];
//                footer.data = @{@"title": [NSString stringWithFormat:@"section%@-Footer", @(sectionIndex)]};
//            }];
        }
    }];

    [self.tableAdapter reloadTableView];
}


#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    return _tableView;
}

- (PWTableAdapter *)tableAdapter {
    return self.tableView.adapter;
}


@end
