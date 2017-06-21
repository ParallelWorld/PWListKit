# PWListKit

## 简介
iOS开发中最常用的系统控件是列表，大部分的页面都是在跟列表打交道。但是iOS控件中的UITableView和UICollectionview的代理和数据源有很多模板代码，实际开发中要写很多重复性的代码。所以写该开源项目来解决这个问题，使得列表开发时更舒心。

## 结构图
// TODO 此处缺个类结构图

## 特性
### 未实现的功能

### 已经实现的功能
- 封装列表的部分数据源和代理方法，使得添加数据更方便。
- 实现数据驱动UI。修改数据后，调用单一方法即可实现列表差量刷新。
- cell、header和footer可自动算高和自动重用。
- 空页面和错误页面可自定义。

## 如何加入到项目中
使用git地址，目前没有加入到pod的中心仓库中。
```
pod 'PWListKit', :git => 'https://github.com/parallelWorld/PWListKit.git'
```

## 参考链接
- https://github.com/forkingdog
- https://github.com/NianJi/NJEasyTable
- https://github.com/rickytan/RTComponentTableView
- https://xcoder.tips/a-componentized-uitableivew/
- https://github.com/parallelWorld/IGListKit
