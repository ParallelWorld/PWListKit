//
//  BaseViewController.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/2.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "BaseViewController.h"
#import "Masonry.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSStringFromClass(self.class);
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
