#import "PlotItem.h"
typedef UIView PlotGalleryNativeView;

@interface JEControlChart : PlotItem<CPTPlotDataSource>

@property (nonatomic, readwrite, strong) NSArray *plotData;
@property (nonatomic, readwrite, strong) NSArray *plotData1;

@property (nonatomic, assign) NSUInteger numberOfPoints;

@property (nonatomic, strong) PlotGalleryNativeView* hostView;

@end
