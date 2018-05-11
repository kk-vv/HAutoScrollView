//
//  H1ViewController.m
//  HAutoScroll
//
//  Created by JuanFelix on 16/7/30.
//  Copyright © 2016年 JuanFelix. All rights reserved.
//

#import "H1ViewController.h"
#import "HAutoScrollView.h"

@interface H1ViewController ()<HAutoScrollViewDelegate,HAutoScrollViewDataSource>
{
    NSArray * arrImages;
    int count;
    HAutoScrollView * autoScroll;
}

@end

@implementation H1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrImages = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpeg",@"7.jpeg",@"8.jpeg",@"9.jpeg",@"10.jpeg"];
    count = 5;

    autoScroll = [[HAutoScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    [autoScroll setDelegate:self];
    [autoScroll setDataSource:self];
    [autoScroll setAutoFlip:true];
//    [autoScroll setFlipInterval:1.0];
    //[self.view addSubview:autoScroll];

    UIScrollView * srollview = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:srollview];
    [srollview setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 2)];
    [srollview addSubview:autoScroll];
    //
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadMoreAction)];
    [self.navigationItem setRightBarButtonItem:item];
}

-(void)loadMoreAction{
    count += 2;
    if (count >= 10) {
        count = 1 ;
    }
    [autoScroll reloadData];
}

#pragma mark - HAutoScroll Delegate & DataSouce
-(NSInteger)numberOfPagesInHAutoScrollView:(HAutoScrollView *)asView{
    return count;
}

-(UIView *)pageAtIndex:(NSInteger)index autoScrollView:(HAutoScrollView *)asView{
    UIImageView * image = [[UIImageView alloc] init];
    [image setContentMode:UIViewContentModeScaleAspectFill];
    [image setImage:[UIImage imageNamed:[arrImages objectAtIndex:index]]];
    return  image;
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
