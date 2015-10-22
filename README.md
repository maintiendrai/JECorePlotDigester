JECorePlotDigester
=============

基于CorePlot，简单的环形饼图、柱状图、折线图 的实现，操作简单。 JECorePlotDigester is an encapsulation for BarChart、SimplePieChart、 CurvedPlotChat base on CorePlot


## prepare

install CorePlot 1.6

pod 'CorePlot', '~> 1.6'


## CocoaPods

[![Dependency Status](https://www.versioneye.com/objective-c/JECorePlotDigester/0.1.8/badge.svg?style=flat)](https://www.versioneye.com/objective-c/JECorePlotDigester/0.1.18)
[![Reference Status](https://www.versioneye.com/objective-c/JECorePlotDigester/reference_badge.svg?style=flat)](https://www.versioneye.com/objective-c/JECorePlotDigester/references)

JECorePlotDigester can be installed using [CocoaPods](http://cocoapods.org/).

pod 'JECorePlotDigester', :head

### Usage:

0. Import header file

```
#import "JEBarChart.h"
#import "JESimplePieChart.h"
#import "JECurvedPlotView.h"
#import "JEControlChart.h"
```

1. JEControlChart.

``` 
Objective-C
- (void)testControlChart {

    JEControlChart *plotItem = [[JEControlChart alloc]init];
    NSMutableArray *contentArray = [NSMutableArray array];
    
    int count = 31;
    for ( int j = 0; j < count+1; j++ ) {
        [contentArray addObject:@(0)];
    }
    
    plotItem.plotData = contentArray;
    plotItem.numberOfPoints = 31;
    
    plotItem.plotData1 = contentArray;
    plotItem.numberOfPoints = 31;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 320, 150)];
    [self.view addSubview:view];
    
    self.pieChartDetailItem = plotItem;
    [self.pieChartDetailItem renderInView:view withTheme:nil animated:YES];
}
```

2. JESimplePie Chart

``` 
Objective-C
- (void)testSimplePiechart {
    PlotItem *plotItem = [[JESimplePieChart alloc]init];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 400)];
    [self.view addSubview:view];
    
    ((JESimplePieChart*)plotItem).plotData = @[@20.0, @30.0, @60.0];
    
    self.pieChartDetailItem = plotItem;
    [self.pieChartDetailItem renderInView:view withTheme:nil animated:YES];
}
```

2. JEBarChart

``` 
Objective-C
- (void)testBarChart {
    PlotItem *plotItem  = [[JEBarChart alloc]init];
    UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, 320, 200)];
    [self.view addSubview:barView];
    [_barChartDetailItem renderInView:barView withTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme] animated:YES];

    self.pieChartDetailItem = plotItem;
    [self.pieChartDetailItem renderInView:barView withTheme:nil animated:YES];

}
```

### License

此SDK采用MIT许可.

###Contact

若您在使用此SDK过程中，遇到任何问题，可以邮件联系我，我的邮箱地址: maintiendrai@gmail.com

