//
//  JECurvedPlotView.h
//  JECorePlotDigester
//
//  Created by Diana on 8/6/15.
//  Copyright (c) 2015 evideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface JECurvedPlotView : UIView<CPTPlotDataSource,CPTAxisDelegate, CPTBarPlotDelegate>

@property (nonatomic, strong) NSMutableArray        *mar_dataForPlot;
@property (nonatomic, strong) NSMutableDictionary   *mdic_dataFprPlot;
@property (nonatomic, strong) NSDate                *firstTime;
@property (nonatomic, assign) float                 maxCount;
@property (nonatomic, assign) float                 minCount;

- (void)drawGraph;
- (void)addLineWithIdentifier:(NSString *)identifier color:(CPTColor *)lineColor;
- (void)refreshGraphView;
@end
