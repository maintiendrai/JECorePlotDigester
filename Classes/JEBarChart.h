//
//  JEBarChart.h
//  JECorePlotDigester
//
//  Created by Diana on 8/6/15.
//  Copyright (c) 2015 evideo. All rights reserved.
//

#import "PlotItem.h"

@interface JEBarChart : PlotItem<CPTPlotSpaceDelegate,
                                      CPTPlotDataSource,
                                      CPTBarPlotDelegate>

/*
 *  plotData传递的必须是数字的数组
 *  self.plotData = @[@20.0, @30.0, @60.0];
 */

@property (nonatomic, strong) NSArray *plotData;
@property (nonatomic, strong) NSArray* plotData1;
@property (nonatomic, strong) CPTColor* plotColor;
@property (nonatomic, strong) CPTColor* plotColor1;
@property (nonatomic, assign) int plotCount;

@end
