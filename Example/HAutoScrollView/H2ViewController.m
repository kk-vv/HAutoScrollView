//
//  H2ViewController.m
//  HAutoScroll
//
//  Created by JuanFelix on 16/7/30.
//  Copyright © 2016年 JuanFelix. All rights reserved.
//

#import "H2ViewController.h"
#import "HAutoScrollView.h"

@interface H2ViewController ()<HAutoScrollViewDelegate,HAutoScrollViewDataSource>
{
    NSMutableArray * arrColors;
    UIActivityIndicatorView * activityHUD;
    HAutoScrollView * autoScroll;
}

@end

@implementation H2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrColors = [NSMutableArray array];
    autoScroll = [[HAutoScrollView alloc] init];
    [autoScroll setTranslatesAutoresizingMaskIntoConstraints:false];
    [autoScroll setBackgroundColor:[UIColor purpleColor]];
    [autoScroll setDataSource:self];
    [autoScroll setDelegate:self];
    autoScroll.pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
    autoScroll.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    [self.view addSubview:autoScroll];
    
    NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:autoScroll attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:autoScroll attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:autoScroll attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:20];
    NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:autoScroll attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0];
    [self.view addConstraints:@[left,right,top,height]];
    
    activityHUD = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityHUD setCenter:self.view.center];
    [self.view addSubview:activityHUD];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [activityHUD startAnimating];
    [self performSelector:@selector(laodData) withObject:nil afterDelay:2.0];
}

-(void)laodData{
    [activityHUD stopAnimating];
    for (int i = 0; i < 10; i ++) {
        CGFloat r = arc4random() % 256 / 256.0;
        CGFloat g = arc4random() % 256 / 256.0;
        CGFloat b = arc4random() % 256 / 256.0;
        [arrColors addObject:[UIColor colorWithRed:r green:g blue:b alpha:1.0]];
    }
    [autoScroll reloadData];
}


#pragma mark - HAutoScroll Delegate & DataSouce
-(NSInteger)numberOfPagesInHAutoScrollView:(HAutoScrollView *)asView{
    return arrColors.count;
}

-(UIView *)pageAtIndex:(NSInteger)index autoScrollView:(HAutoScrollView *)asView{
    UILabel * view = [[UILabel alloc] init];
    [view setBackgroundColor:arrColors[index]];
    [view setFont:[UIFont systemFontOfSize:30]];
    [view setTextColor:[UIColor whiteColor]];
    [view setText:[NSString stringWithFormat:@"%ld",index + 1]];
    [view setTextAlignment:NSTextAlignmentCenter];
    return  view;
}

-(void)autoScrollView:(HAutoScrollView *)asView didSelectAtPageIndex:(NSInteger)pIndex{
    NSLog(@"%@ Page Index:%ld",self,pIndex);
}

-(void)dealloc{
    NSLog(@"%@ Dealloc",self);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
