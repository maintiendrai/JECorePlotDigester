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
#import "JECurvedPlotView.h"

@interface ViewController ()

@property (nonatomic, strong) PlotItem *pieChartDetailItem;
@property (nonatomic, strong) PlotItem *barChartDetailItem;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //饼图 JESimplePieChart:
    PlotItem *plotItem = [[JESimplePieChart alloc]init];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    [self.view addSubview:view];
    
    //柱状图 JEBarChart
    _barChartDetailItem = [[JEBarChart alloc]init];
    UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, 320, 200)];
    [self.view addSubview:barView];
    [_barChartDetailItem renderInView:barView withTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme] animated:YES];
    
    
    //折线图
    SNEventGraphView *curvedPlotView = [[SNEventGraphView alloc]initWithFrame:CGRectMake(10, 400, 250, 200) data:nil];
    [self.view addSubview:curvedPlotView];
    
    
    self.pieChartDetailItem = plotItem;
    [self.pieChartDetailItem renderInView:view withTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme] animated:YES];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
