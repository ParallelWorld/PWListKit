PWListKit完成的功能


## 未实现的功能
- 数据发生变化时，能够准确的刷新变化的UI，而不是整体刷新，这个需要diff算法，可参考IGListKit
- cell中的事件可以轻松的传递出来，可考虑把didSelect方法替换掉，跟IGListKit的做法一致
- 所有的model都不可子类化，可参考IGListKit

## 已经实现的功能
- 指定cellClass即可自动注册cell的class或者nib，无需指定注册类型。当有cell的同名nib时，调用是`registerNib`方法，否则调用`registerClass`方法。
- 可重用tableView的cell、header和footer
- cell、header和footer可自动算高
- 方便实现tableView和collectionView，实现数据驱动UI
- 实现emptyView

## 参考链接
- https://github.com/forkingdog
- https://github.com/NianJi/NJEasyTable
- https://github.com/rickytan/RTComponentTableView
- https://xcoder.tips/a-componentized-uitableivew/
- https://github.com/parallelWorld/IGListKit
