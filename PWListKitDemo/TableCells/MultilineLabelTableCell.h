//
//  MultilineLabelTableCell.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/2.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWListKit.h"

@interface MultilineLabelTableCell : UITableViewCell <PWTableCellConfigureProtocol>

@property (nonatomic) UILabel *multilineLabel;

@end
