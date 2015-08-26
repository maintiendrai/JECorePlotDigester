//
//  ViewController.m
//  JECorePlotDigester
//
//  Created by Diana on 8/5/15.
//  Copyright (c) 2015 evideo. All rights reserved.
//

#import "ViewController.h"
#import "CurvedScatterPlot.h"
#import "JESimplePieChart.h"
#import "JEBarChart.h"
#import "JECurvedPlotView.h"
#import "JEControlChart.h"

@interface ViewController ()

@property (nonatomic, strong) PlotItem *pieChartDetailItem;
@property (nonatomic, strong) PlotItem *barChartDetailItem;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self testBarChart];
    [self testControlChart];
//    [self testSimplePiechart];

}

//controlchart
- (void)testControlChart {

    JEControlChart *plotItem = [[JEControlChart alloc]init];
    NSMutableArray *contentArray = [NSMutableArray array];
    
    int count = 12;
    for ( int j = 0; j < count+1; j++ ) {
        [contentArray addObject:@(0)];
    }
    [contentArray replaceObjectAtIndex:3 withObject:@(60)];
    [contentArray replaceObjectAtIndex:10 withObject:@(90)];
    
    plotItem.plotData = contentArray;
    plotItem.numberOfPoints = 28;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 320, 120)];
    [self.view addSubview:view];
    
    self.pieChartDetailItem = plotItem;
    [self.pieChartDetailItem renderInView:view withTheme:nil animated:YES];
}

//JESimplePie Chart
- (void)testSimplePiechart {
    PlotItem *plotItem = [[JESimplePieChart alloc]init];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 400)];
    [self.view addSubview:view];
    
    self.pieChartDetailItem = plotItem;
    [self.pieChartDetailItem renderInView:view withTheme:nil animated:YES];
}

//JEBarChart
- (void)testBarChart {
    PlotItem *plotItem  = [[JEBarChart alloc]init];
    UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, 320, 200)];
    [self.view addSubview:barView];
    [_barChartDetailItem renderInView:barView withTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme] animated:YES];

    self.pieChartDetailItem = plotItem;
    [self.pieChartDetailItem renderInView:barView withTheme:nil animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
