//
//  ViewController.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "ReactiveCocoa.h"

#import "PWListKit.h"
#import "Style1Cell.h"
#import "Style2Cell.h"
#import "Style3Cell.h"
#import "TableHeaderView.h"


@interface ViewController () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) PWTableAdapter *tableAdapter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    self.tableAdapter = [[PWTableAdapter alloc] initWithTableView:self.tableView];
    self.tableAdapter.tableDelegate = self;
    
    
    
    for (int i = 0; i < 10; i++) {
        [self.tableAdapter addSection:^(PWTableSection *section) {
            [section setHeader:^(PWTableHeaderFooter * _Nonnull header) {
                header.headerFooterClass = [TableHeaderView class];
                header.data = @{@"title": @"哈哈"};
            }];
            
            for (int j = 0; j < 3; j++) {
                [section addItem:^(PWTableItem *row) {
                    row.cellClass = [Style1Cell class];
                    row.data = @{@"image": @"star_blue",
                                 @"label": @"今日新闻-xxxxxxxxx",
                                 @"id": @(j)};
                }];
            }
            
            NSMutableString *s = [NSMutableString new];
            for (int j = 0; j < 1; j++) {
                [s appendFormat:@"%@+", @(j)];
                [section addItem:^(PWTableItem *row) {
                    row.cellClass = [Style2Cell class];
                    row.data = @{@"title": @"商品名称",
                                 @"price": @"￥ 34.59",
                                 @"id": s.copy};
                }];
            }
            for (int j = 0; j < 6; j++) {
                [section addItem:^(PWTableItem *row) {
                    row.cellClass = [Style3Cell class];
                    NSMutableArray *mArray = [NSMutableArray new];
                    for (int k = 0; k < 10; k++) {
                        [mArray addObject:@(k).stringValue];
                    }
                    row.data = mArray.copy;
//                    row.cellHeight = 51;
                }];
            }
            
            [section setFooter:^(PWTableHeaderFooter * _Nonnull footer) {
                footer.headerFooterClass = [TableHeaderView class];
                footer.data = @{@"title": ({
                    NSString *value = nil;
                    if (i == 0) value = @"000";
                    else if (i == 1) value = @"11111111111111111";
                    else if (i == 2) value = @"22222222222222222222222222222222222222222222222222222222222222222222222222222222";
                    else if (i == 3) value = @"33";
                    else value = @">=4";
                    value;
                })};
            }];
        }];
    }
    
    [self.tableAdapter reloadTableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", indexPath);
}

@end

