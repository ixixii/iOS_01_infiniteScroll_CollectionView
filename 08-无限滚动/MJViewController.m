//
//  MJViewController.m
//  08-无限滚动
//
//  Created by apple on 14-5-31.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJViewController.h"
// 快速Frame
#import "UIView+Frame.h"

#import "MJNewsCell.h"
#import "MJNews.h"
#import "MJExtension.h"

// 只有一组，但是该组 有5000*8 个
#define TotalItems (5000 * self.newses.count)
// 第一次出现的时候，didAppear时，就出现在中间，左边对齐
#define MiddleItem (NSUInteger)(TotalItems * 0.5)

@interface MJViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageCtrl;
@property (strong, nonatomic) NSArray *newses;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation MJViewController
#pragma mark - 懒加载
- (NSArray *)newses
{
    if (!_newses) {
        self.newses = [MJNews objectArrayWithFilename:@"newses.plist"];
        // 总页数
        self.pageCtrl.numberOfPages = self.newses.count;
    }
    return _newses;
}
#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 注册cell【UICollectionViewCell不让代码创建】
    [self.collectionView registerNib:[UINib nibWithNibName:@"MJNewsCell" bundle:nil] forCellWithReuseIdentifier:@"news"];
    
    // 添加定时器
    [self addTimer];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:MiddleItem inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}
#pragma mark - 时钟方法
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(schedule) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}
// 定时器方法
- (void)schedule
{
    // 得到当前显示的item
    NSIndexPath *visiablePath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    
    NSUInteger visiableItem = visiablePath.item;
    if ((visiablePath.item % self.newses.count)  == 0) { // 第0张图片
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:MiddleItem inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        visiableItem = MiddleItem;
    }
    
    // 滚动到下一个item
    NSUInteger nextItem = visiableItem + 1;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}
#pragma mark - 数据源和代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return TotalItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"news";
    // 直接取
    MJNewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    // UICollectionViewCell没有根据id进行创建方法，只能 从xib加载
    //    UICollectionViewFlowLayout *layout 中 可以指定cell的高度
    
    cell.news = self.newses[indexPath.item % self.newses.count];
    
    return cell;
}
// 重要，监听代理 停止滚动的事件
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *visiablePath = [[collectionView indexPathsForVisibleItems] firstObject];
    self.pageCtrl.currentPage = visiablePath.item % self.newses.count;
}

#pragma mark - scrollView代理
// 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}
// 停止拖拽
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self addTimer];
}
@end
