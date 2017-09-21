# UIView及其子类的占位图

### 用到的三方
1. [Masonry](https://github.com/SnapKit/Masonry)
2. [RAC](https://github.com/ReactiveCocoa/ReactiveCocoa)

### 详情

敬请期待



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
