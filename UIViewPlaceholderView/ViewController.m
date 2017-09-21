//
//  ViewController.m
//  UIViewPlaceholderView
//
//  Created by 蔡强 on 2017/9/21.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(90, 90, 200, 30)];
    [self.view addSubview:button];
    [button setTitle:@"去下一页" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    
    @weakify(self);
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        SecondViewController *secondVC = [[SecondViewController alloc] init];
        [self.navigationController pushViewController:secondVC animated:YES];
    }];
}


@end
