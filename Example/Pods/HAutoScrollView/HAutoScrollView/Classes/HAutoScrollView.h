//
//  HAutoScroll.h
//  HAutoScroll
//
//  Created by JuanFelix on 16/7/19.
//  Copyright © 2016年 JuanFelix. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HAutoScrollView;
//DataSource
@protocol HAutoScrollViewDataSource <NSObject>

@required
-(NSInteger)numberOfPagesInHAutoScrollView:(HAutoScrollView *)asView;
-(UIView *)pageAtIndex:(NSInteger)index
        autoScrollView:(HAutoScrollView *)asView;
@end

//Delegate
@protocol HAutoScrollViewDelegate <NSObject>

@optional
-(void)autoScrollView:(HAutoScrollView *)asView
 didSelectAtPageIndex:(NSInteger)pIndex;

@end
/**
 *  HAutoScrollView
 */
@interface HAutoScrollView : UIView

@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UIPageControl * pageControl;
@property (nonatomic,assign) BOOL autoFlip;//Default false;
@property (nonatomic,assign) NSTimeInterval flipInterval;//Default 2.0s

@property (nonatomic,assign, setter=setDelegate:) id<HAutoScrollViewDelegate> delegate;
@property (nonatomic,assign, setter=setDataSource:) id<HAutoScrollViewDataSource> dataSource;

-(void)reloadData;
-(void)stopTimer;

@end
