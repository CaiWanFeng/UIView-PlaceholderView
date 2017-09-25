//
//  SecondViewController.m
//  UIScrollViewPlaceholderView
//
//  Created by 蔡强 on 2017/9/17.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import "SecondViewController.h"
#import "UIView+PlaceholderView.h"
#import <SVProgressHUD.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <Masonry.h>

@interface SecondViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    for (int i = 0; i < 3; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(90, 90 + i * 80, 200, 40)];
        [self.tableView addSubview:button];
        button.tag = 100 + i;
        button.backgroundColor = [UIColor orangeColor];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        switch (i) {
            case 0:
            {
                [button setTitle:@"模拟获取数据" forState:UIControlStateNormal];
            }
                break;
                
            case 1:
            {
                [button setTitle:@"没网" forState:UIControlStateNormal];
            }
                break;
                
            case 2:
            {
                [button setTitle:@"评论数量0" forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
    }
    
    
    [SVProgressHUD setMaximumDismissTimeInterval:1];
}

- (void)buttonClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 100: // 模拟获取数据
        {
            [self getData];
        }
            break;
            
        case 101: // 没网
        {
            [self.view cq_showPlaceholderViewWithType:CQPlaceholderViewTypeNoNetwork reloadBlock:^{
                [SVProgressHUD showSuccessWithStatus:@"重新加载按钮点击"];
                // 直接写self也不会导致内存泄漏
                self.view.backgroundColor = [UIColor redColor];
            }];
        }
            break;
            
        case 102:
        {
            [self.tableView cq_showPlaceholderViewWithType:CQPlaceholderViewTypeNoComment reloadBlock:nil];
            
            // 1秒后调用方法移除占位图
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD showInfoWithStatus:@"调用方法移除占位图"];
                [self.tableView cq_removePlaceholderView];
            });
        }
            break;
            
        default:
            break;
    }
}

// 模拟获取数据
- (void)getData {
    [SVProgressHUD show];
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        // 是否成功获取数据
        BOOL isGetData = arc4random() % 2;
        // 是否数据源为空
        BOOL isEmpty = arc4random() % 2;
        
        if (isGetData) {
            if (isEmpty) {
                // 展示空数据占位图
                [self.tableView cq_showPlaceholderViewWithType:CQPlaceholderViewTypeNoGoods reloadBlock:nil];
                [SVProgressHUD showInfoWithStatus:@"数据源空"];
            } else {
                // 展示数据
                [SVProgressHUD showSuccessWithStatus:@"数据正常展示"];
            }
        } else {
            // 未成功获取数据，展示无网占位图
            [self.tableView cq_showPlaceholderViewWithType:CQPlaceholderViewTypeNoNetwork reloadBlock:^{
                [self getData];
            }];
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }
    });
    
}

- (void)dealloc {
    NSLog(@"页面2已释放");
}

@end
