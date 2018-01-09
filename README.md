# UIView及其子类的占位图

### 用到的三方
1. [Masonry](https://github.com/SnapKit/Masonry)
2. [RAC](https://github.com/ReactiveCocoa/ReactiveCocoa)

### 详情

http://www.jianshu.com/p/dccf16239ede



### 使用方法

**1.导入头文件**

`#import "UIView+PlaceholderView.h"`


**2.需要的时候直接调用方法**

- UIView

```
[self.view cq_showPlaceholderViewWithType:CQPlaceholderViewTypeNoNetwork reloadBlock:^{
    [SVProgressHUD showSuccessWithStatus:@"有网了"];
}];
```

- UITabeleView

```
[self.tableView cq_showPlaceholderViewWithType:CQPlaceholderViewTypeNoNetwork reloadBlock:^{
    [self getData];
}];
```

或其它继承UIView的都可以直接使用。

**3.也可以重新设置占位图的约束**
```
[self.tableView cq_showPlaceholderViewWithType:CQPlaceholderViewTypeNoComment reloadBlock:nil];
// 重新设置占位图约束
[self.tableView.cq_placeholderView mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(self.view);
    make.top.mas_equalTo(self.tableView).mas_offset(50);
    make.bottom.mas_equalTo(self.view).mas_offset(-30);
}];
```
