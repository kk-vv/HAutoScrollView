//
//  HAutoScroll.m
//  HAutoScroll
//
//  Created by JuanFelix on 16/7/19.
//  Copyright © 2016年 JuanFelix. All rights reserved.
//

#import "HAutoScrollView.h"
#define HBASE_VIEW_TAG   900100
#define PAGE_SELCOLOR    [UIColor cyanColor]
#define PAGE_UNSELCOLOR  [UIColor whiteColor]

@interface HAutoScrollView ()<UIScrollViewDelegate>
{
    NSInteger totalPage;
    NSInteger currentPage;
    NSMutableArray * arrThriViews;
    NSTimer * flipTimer;
    BOOL dealloc;
}

@end

@implementation HAutoScrollView

-(instancetype)init{
    if (self = [super init]) {
        _scrollView = [UIScrollView new];
        [self initScrollViewStyle];
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self initScrollViewStyle];
        [self refreshScrollViewContentSize];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self refreshScrollViewContentSize];
    [self loadData];
}

-(void)refreshScrollViewContentSize{
    CGRect frame = self.frame;
    _scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _scrollView.contentSize = CGSizeMake(frame.size.width * 3, frame.size.height);
    _scrollView.contentOffset = CGPointMake(frame.size.width, 0);
    [_pageControl setCenter:CGPointMake(frame.size.width / 2.0, frame.size.height - 20)];
}

-(void)initScrollViewStyle{
    
    totalPage = 0;
    currentPage = 0;
    
    arrThriViews = [NSMutableArray array];
    
    [_scrollView setDelegate:self];
    [_scrollView setPagingEnabled:true];
    [_scrollView setShowsVerticalScrollIndicator:false];
    [_scrollView setShowsHorizontalScrollIndicator:false];
    [_scrollView setBounces:false];
    [self addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] init];
    [_pageControl setPageIndicatorTintColor:PAGE_UNSELCOLOR];
    [_pageControl setCurrentPageIndicatorTintColor:PAGE_SELCOLOR];
    [self addSubview:_pageControl];
    _pageControl.numberOfPages = 0;
    
    _autoFlip     = false;
    _flipInterval = 2.0;
    flipTimer     = nil;
    dealloc       = false;
}


#pragma mark - ReloadData

-(void)setDataSource:(id<HAutoScrollViewDataSource>)dataSource{
    _dataSource = dataSource;
    [self reloadData];
}

-(void)reloadData{
    if (dealloc) {
        return;
    }
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfPagesInHAutoScrollView:)]) {
        totalPage = [_dataSource numberOfPagesInHAutoScrollView:self];
        currentPage = 0;
        _pageControl.numberOfPages = totalPage;
        _pageControl.currentPage = currentPage;
        [self loadData];
        
        [self setAutoFlip:_autoFlip];
    }
}

-(void)loadData{
    if (dealloc) {
        return;
    }
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfPagesInHAutoScrollView:)]) {
        totalPage = [_dataSource numberOfPagesInHAutoScrollView:self];
        _pageControl.numberOfPages = totalPage;
        _pageControl.currentPage = currentPage;
        [_scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ((obj.tag - HBASE_VIEW_TAG) >= 0) {
                [obj removeFromSuperview];
            }
        }];
        if (!arrThriViews) {
            arrThriViews = [NSMutableArray array];
        }
        [arrThriViews removeAllObjects];
        if (totalPage > 0) {
            NSInteger pre = (currentPage - 1 + totalPage) % totalPage;
            NSInteger next = (currentPage + 1) % totalPage;
            [arrThriViews addObject:[_dataSource pageAtIndex:pre autoScrollView:self]];//Left （n:Last Page， n - 1 Pre Page)
            [arrThriViews addObject:[_dataSource pageAtIndex:currentPage autoScrollView:self]];//Center (1:FirstPage n Current Page)
            [arrThriViews addObject:[_dataSource pageAtIndex:next autoScrollView:self]];//Right  （2:SecondPage n + 1:Next Page)
            for (int i = 0; i < 3; i++) {
                UIView * aView = [arrThriViews objectAtIndex:i];
                [aView setFrame:CGRectOffset(_scrollView.frame, _scrollView.frame.size.width * i, 0)];
                [aView setTag:HBASE_VIEW_TAG + i];
                [aView setClipsToBounds:true];
                [aView setUserInteractionEnabled:true];
                [aView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)]];
                [_scrollView addSubview:aView];
            }
            [self refreshScrollViewContentSize];
            if (totalPage > 1) {
                [_scrollView setScrollEnabled:true];
                [_pageControl setHidden:false];
            }else{
                [_scrollView setScrollEnabled:false];
                [_pageControl setHidden:true];
            }
        }
    }
}

-(void)tapGestureAction{
    if ([_delegate respondsToSelector:@selector(autoScrollView:didSelectAtPageIndex:)]) {
        [_delegate autoScrollView:self didSelectAtPageIndex:currentPage];
    }
}

#pragma mark - auto flip
-(void)setAutoFlip:(BOOL)autoFlip{
    _autoFlip = autoFlip;
    if (totalPage > 1) {
        if (autoFlip) {
            if (!flipTimer) {
                flipTimer = [NSTimer scheduledTimerWithTimeInterval:_flipInterval target:self selector:@selector(autoFlipAction) userInfo:nil repeats:true];
                [[NSRunLoop currentRunLoop] addTimer:flipTimer forMode:NSRunLoopCommonModes];
                
            }else{
                [flipTimer setFireDate:[NSDate date]];
            }
        }else{
            [self stopTimer];
        }
    }
}

-(void)setFlipInterval:(NSTimeInterval)flipInterval{
    _flipInterval = flipInterval;
    [self stopTimer];
    [self setAutoFlip:true];
}

-(void)autoFlipAction{
    if (totalPage > 1) {
        /*
         * 这么写没动画
         currentPage = (currentPage + 1 ) % totalPage;
        [self reloadData];
         */
        float offsetX=_scrollView.contentOffset.x+_scrollView.frame.size.width;
        int index = (offsetX / _scrollView.frame.size.width + 0.5);
        [_scrollView setContentOffset:CGPointMake(index * _scrollView.frame.size.width, 0) animated:YES];
    }
}

-(void)pauseTimer{
    if (flipTimer) {
        [flipTimer setFireDate:[NSDate distantFuture]];
    }
}

-(void)resumeTimer{
    if (flipTimer) {
        [flipTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_flipInterval]];
    }
}

-(void)stopTimer{
    if (flipTimer) {
        [flipTimer invalidate];
        flipTimer = nil;
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_autoFlip) {
        if (totalPage > 1) {
            CGFloat offsetX = scrollView.contentOffset.x;
            if (offsetX >= scrollView.frame.size.width * 2) {
                currentPage = (currentPage + 1) % totalPage;
                [self loadData];
            }else if (offsetX <= 0){
                currentPage = (currentPage - 1 + totalPage ) % totalPage;
                [self loadData];
            }
            //Resume Timer
            if (_autoFlip) {
                [self resumeTimer];
            }
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (!_autoFlip) {
        if (totalPage > 1) {
            CGFloat offsetX = scrollView.contentOffset.x;
            if (offsetX >= scrollView.frame.size.width * 2) {
                currentPage = (currentPage + 1) % totalPage;
                [self loadData];
            }else if (offsetX <= 0){
                currentPage = (currentPage - 1 + totalPage ) % totalPage;
                [self loadData];
            }
            //Resume Timer
            if (_autoFlip) {
                [self resumeTimer];
            }
        }
    }
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //Stop Timer
    if (_autoFlip) {
        [self pauseTimer];
    }
}
//PUSH 到下一层的时候有点奇葩
-(void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
    //NSLog(@"3 willMoveToWindow %p", newWindow);
    if (newWindow == nil) {
        dealloc = true;
        [self stopTimer];
    } else {
        dealloc = false;
        [self setAutoFlip:_autoFlip];
    }
}

//- (void)didMoveToWindow {
//    [super didMoveToWindow];
//    //NSLog(@"4 didMoveToWindow %p", self.window);
//}
//
//- (void)willMoveToSuperview:(UIView *)newSuperview {
//    [super willMoveToSuperview:newSuperview];
//    //NSLog(@"1 willMoveToSuperview %p", newSuperview);
//}
//
//- (void)didMoveToSuperview {
//    [super didMoveToSuperview];
//    //NSLog(@"2 didMoveToSuperview %p", self.superview);
//}
//
//- (void)removeFromSuperview {
//    [super removeFromSuperview];
//    //NSLog(@"5 removeFromSuperview %p", self.superview);
//    dealloc = true;
//    [self stopTimer];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
