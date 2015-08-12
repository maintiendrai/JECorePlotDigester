//
//  ViewController.m
//  JECorePlotDigester
//
//  Created by Diana on 8/5/15.
//  Copyright (c) 2015 evideo. All rights reserved.
//

#import "ViewController.h"
#import "SNEventGraphView.h"
#import "CurvedScatterPlot.h"
#import "JESimplePieChart.h"
#import "JEBarChart.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    SNEventGraphView *view = [[SNEventGraphView alloc]initWithFrame:CGRectMake(10, 50, 250, 200) data:nil];
//    
//    [self.view addSubview:view];
    
//    PlotItem *plotItem = [[CurvedScatterPlot alloc]init];
    PlotItem *plotItem = [[JESimplePieChart alloc]init];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    [self.view addSubview:view];
    self.detailItem = plotItem;
    [self.detailItem renderInView:view withTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme] animated:YES];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
