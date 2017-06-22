//
//  DemosViewController.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/2.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "DemosViewController.h"
#import "Masonry.h"
#import "ReactiveCocoa.h"
#import "LabelTableCell.h"

@interface DemosViewController () <UITableViewDelegate>

@property (nonatomic) UITableView *tableView;

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
    
    [self.tableView.adapter updateTableViewWithActions:^(PWTableAdapter * _Nonnull adapter) {
        [adapter addSection:^(PWTableSection * _Nonnull s) {
            [[[controllerClassNames.rac_sequence map:^id(NSString *name) {
                PWTableRow *row = [[PWTableRow alloc] initWithCellClass:[LabelTableCell class]];
                row.data = @{@"title": name};
                row.height = 50;
                return row;
            }] array] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [s addRow:obj];
            }];
        }];
    } animation:UITableViewRowAnimationLeft completion:nil];
    
//    [self.tableView.adapter updateTableViewWithActions:nil animation:UITableViewRowAnimationNone completion:^{
//        NSLog(@"tableView refresh complete");
//    }];
}

- (NSArray *)controllerClassNames {
    return @[@"TableDifferentCellHeightViewController",
             @"MixedDataViewController",
             @"EmptyViewController"];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PWTableRow *item = [self.tableView.adapter rowAtIndexPath:indexPath];
    NSString *title = item.data[@"title"];
    Class controllerClass = NSClassFromString(title);
    UIViewController *controller = [controllerClass new];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.adapter.tableDelegate = self;
    }
    return _tableView;
}

@end
