//
//  UIScrollView+PlaceholderView.m
//  UIScrollViewPlaceholderView
//
//  Created by 蔡强 on 2017/9/17.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import "UIView+PlaceholderView.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <objc/runtime.h>

@interface UIView ()

/** 占位图 */
@property (nonatomic, strong) UIView *cq_placeholderView;

@end

@implementation UIView (PlaceholderView)

static void *strKey = &strKey;

- (UIView *)cq_placeholderView {
    return objc_getAssociatedObject(self, &strKey);
}

- (void)setCq_placeholderView:(UIView *)cq_placeholderView {
    objc_setAssociatedObject(self, &strKey, cq_placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 展示UIView及其子类的占位图
 
 @param type 占位图类型
 @param reloadBlock 重新加载回调的block
 */
- (void)cq_showPlaceholderViewWithType:(CQPlaceholderViewType)type reloadBlock:(void (^)())reloadBlock {
    // 如果是UIScrollView及其子类，占位图展示期间禁止scroll
    BOOL originalScrollEnabled = NO; // 用来记录原本的scrollEnabled
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        // 先记录原本的scrollEnabled
        originalScrollEnabled = scrollView.scrollEnabled;
        // 再将scrollEnabled设为NO
        scrollView.scrollEnabled = NO;
    }
    
    //------- 占位图 -------//
    if (self.cq_placeholderView) {
        [self.cq_placeholderView removeFromSuperview];
        self.cq_placeholderView = nil;
    }
    self.cq_placeholderView = [[UIView alloc] init];
    [self addSubview:self.cq_placeholderView];
    self.cq_placeholderView.backgroundColor = [UIColor whiteColor];
    [self.cq_placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(self);
    }];
    
    //------- 图标 -------//
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.cq_placeholderView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView.superview);
        make.centerY.mas_equalTo(imageView.superview).mas_offset(-80);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    //------- 描述 -------//
    UILabel *descLabel = [[UILabel alloc] init];
    [self.cq_placeholderView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(descLabel.superview);
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(15);
    }];
    
    //------- 重新加载button -------//
    UIButton *reloadButton = [[UIButton alloc] init];
    [self.cq_placeholderView addSubview:reloadButton];
    [reloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
    reloadButton.layer.borderWidth = 1;
    reloadButton.layer.borderColor = [UIColor blackColor].CGColor;
    [[reloadButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        // 执行block回调
        if (reloadBlock) {
            reloadBlock();
        }
        // 从父视图移除
        [self.cq_placeholderView removeFromSuperview];
        self.cq_placeholderView = nil;
        // 复原UIScrollView的scrollEnabled
        if ([self isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)self;
            scrollView.scrollEnabled = originalScrollEnabled;
        }
    }];
    [reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(reloadButton.superview);
        make.top.mas_equalTo(descLabel.mas_bottom).mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    
    //------- 根据type设置不同UI -------//
    switch (type) {
        case CQPlaceholderViewTypeNoNetwork: // 网络不好
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"无网" ofType:@"png"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
            descLabel.text = @"网络异常";
        }
            break;
            
        case CQPlaceholderViewTypeNoGoods: // 没商品
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"无商品" ofType:@"png"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
            descLabel.text = @"一个商品都没有";
        }
            break;
            
        case CQPlaceholderViewTypeNoComment: // 没评论
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"沙发" ofType:@"png"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
            descLabel.text = @"抢沙发！";
        }
            break;
            
        default:
            break;
    }
}

/** 移除占位图 */
- (void)cq_removePlaceholderView {
    if (self.cq_placeholderView) {
        [self.cq_placeholderView removeFromSuperview];
        self.cq_placeholderView = nil;
    }
}

@end
