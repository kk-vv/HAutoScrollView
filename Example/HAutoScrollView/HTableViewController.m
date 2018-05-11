//
//  HTableViewController.m
//  HAutoScrollView_Example
//
//  Created by screson on 2018/5/11.
//  Copyright © 2018年 LiangJun.Hu. All rights reserved.
//

#import "HTableViewController.h"
#import "HAutoScrollView.h"

@interface HTableViewController () <HAutoScrollViewDelegate,HAutoScrollViewDataSource>
{
    NSArray * arrImages;
    HAutoScrollView * autoScroll;
}

@end

@implementation HTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    arrImages = @[@"4.jpg",@"5.jpg",@"6.jpeg",@"7.jpeg",@"8.jpeg",@"9.jpeg",@"10.jpeg"];
    
    autoScroll = [[HAutoScrollView alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 300)];
    [autoScroll setDelegate:self];
    [autoScroll setDataSource:self];
    [autoScroll setAutoFlip:true];

    [self.view addSubview:autoScroll];
}

#pragma mark - HAutoScroll Delegate & DataSouce
-(NSInteger)numberOfPagesInHAutoScrollView:(HAutoScrollView *)asView{
    return arrImages.count;
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




@end
