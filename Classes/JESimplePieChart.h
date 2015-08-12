//
//  JESimplePieChart.h
//  JECorePlotDigester
//
//  Created by Diana on 8/6/15.
//  Copyright (c) 2015 evideo. All rights reserved.
//

#import "PlotItem.h"

@interface JESimplePieChart : PlotItem<CPTPlotSpaceDelegate,
                                     CPTPieChartDelegate,
                                     CPTLegendDelegate,
                                     CPTPlotDataSource>

/*
 *  plotData传递的必须是数字的数组
 *  self.plotData = @[@20.0, @30.0, @60.0];
 */
 
@property (nonatomic, readwrite, strong) NSArray *plotData;

@end
