//
//  RWPBarChart.m
//  ChartRWP
//
//  Created by ocean on 2018/12/17.
//  Copyright © 2018 handytool. All rights reserved.
//

#import "RWPBarChart.h"

@interface RWPBarChart () {
    int xUnitCount;
    int yUnitCount;
    CGFloat xAxisLabelHeight;
    CGFloat yAxisLabelWidth;
    CGFloat yLabelRightPadding;
    CGFloat xLabelTopPadding;
    CGSize xAxisMaxLabelSize;
    CGSize yAxisMaxLabelSize;
    CGFloat pixelPerXUnit;
    CGFloat pixelPerYUnit;
}
@property (assign, nonatomic) CGFloat barWidth;
@property (strong, nonatomic) NSMutableArray<CALayer *> *shapeLayers;
@property (strong, nonatomic) CAShapeLayer *highlightLayer;
@end

@implementation RWPBarChart

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    for (CALayer *layer in self.shapeLayers) {
        [layer setFrame:self.bounds];
    }
    [self render];
}

- (void)setChartData:(RWPChartData *)chartData {
    _chartData = chartData;
    [self render];
}

- (void)render {
    if (self.shapeLayers) {
        for (CALayer *layer in self.shapeLayers) {
            [layer removeFromSuperlayer];
        }
        [self.shapeLayers removeAllObjects];
    }
    xUnitCount = [self.chartData xUnits];
    yUnitCount = [self.chartData yUnits];
    xAxisLabelHeight = 30;
    xLabelTopPadding = 10;
    yAxisLabelWidth = 50;
    yLabelRightPadding = 10;
    self.barWidth = 10;
    [self caculateMaxLabelSize];
    [self renderXAxis];
    [self renderYAxis];
    [self renderGrid];
    [self renderBars];
}

- (void)caculateMaxLabelSize {
    for (int i = 0; i <= xUnitCount; ++i) {
        NSString *labelText = [NSString stringWithFormat:@"+%.1f", i * self.chartData.valuePerXUnit];
        CGRect textSize = [labelText boundingRectWithSize:CGSizeMake(100000, 100000) options:0 attributes:@{NSFontAttributeName: self.labelFont } context:nil];
        xAxisMaxLabelSize.width = MAX(textSize.size.width, xAxisMaxLabelSize.width);
        xAxisMaxLabelSize.height = MAX(textSize.size.height, xAxisMaxLabelSize.height);
    }
    xAxisLabelHeight = xAxisMaxLabelSize.height + xLabelTopPadding;
    
    for (int i = 0; i <= yUnitCount; ++i) {
        NSString *labelText = [NSString stringWithFormat:@"+%.1f", i * self.chartData.valuePerYUnit];
        CGRect textSize = [labelText boundingRectWithSize:CGSizeMake(100000, 100000) options:0 attributes:@{NSFontAttributeName: self.labelFont } context:nil];
        yAxisMaxLabelSize.width = MAX(textSize.size.width, xAxisMaxLabelSize.width);
        yAxisMaxLabelSize.height = MAX(textSize.size.height, xAxisMaxLabelSize.height);
    }
    
    yAxisLabelWidth = yAxisMaxLabelSize.width + yLabelRightPadding;
    
    const CGFloat width = self.frame.size.width - yAxisLabelWidth;
    const CGFloat height = self.frame.size.height - xAxisLabelHeight;
    pixelPerXUnit = width / xUnitCount;
    pixelPerYUnit = height / yUnitCount;
}

- (void)renderGrid {
    CAShapeLayer *gridLayer = [CAShapeLayer layer];
    gridLayer.lineWidth = 1.0f / [UIScreen mainScreen].scale;
    gridLayer.lineDashPhase = 5;
    gridLayer.lineDashPattern = @[@10, @4];
    gridLayer.fillColor = UIColor.clearColor.CGColor;
    gridLayer.strokeColor = UIColor.redColor.CGColor;
    const CGFloat width = self.frame.size.width - yAxisLabelWidth;
    const CGFloat height = self.frame.size.height - xAxisLabelHeight;
    
    gridLayer.frame = CGRectMake(yAxisLabelWidth, 0, width, height);
    UIBezierPath *gridPath = [UIBezierPath new];
    for (int i = 1; i <= xUnitCount; ++i) {
        [gridPath moveToPoint:CGPointMake(i * pixelPerXUnit, 0)];
        [gridPath addLineToPoint:CGPointMake(i * pixelPerXUnit, height)];
    }
    
    for (int i = 0; i < yUnitCount; ++i) {
        [gridPath moveToPoint:CGPointMake(0, i * pixelPerYUnit)];
        [gridPath addLineToPoint:CGPointMake(width, i * pixelPerYUnit)];
    }
    
    gridLayer.path = gridPath.CGPath;
    [self.shapeLayers addObject:gridLayer];
    [self.layer addSublayer:gridLayer];
}

- (void)renderXAxis {
    if (xUnitCount == 0) {
        return;
    }
    
    const CGFloat width = self.frame.size.width - yAxisLabelWidth;
    const CGFloat height = self.frame.size.height - xAxisLabelHeight;
    const CGFloat pixelPerXUnit = width / xUnitCount;
    
    NSMutableArray *textLabels = [NSMutableArray new];
    for (int i = 1; i <= xUnitCount; ++i) {
        if (i % 3 == 0) {
            CATextLayer *textLayer = [CATextLayer layer];
            NSString *labelText = [NSString stringWithFormat:@"+%.1f", i * self.chartData.valuePerXUnit];
            textLayer.string = labelText;
            textLayer.foregroundColor = UIColor.redColor.CGColor;
            textLayer.fontSize = self.labelFont.pointSize;
            textLayer.alignmentMode = @"center";
            
            textLayer.frame = CGRectMake(pixelPerXUnit * i - xAxisMaxLabelSize.width * 0.5f + yAxisLabelWidth, height + xLabelTopPadding, xAxisMaxLabelSize.width, xAxisMaxLabelSize.height);
            
            [self.shapeLayers addObject:textLayer];
            [self.layer addSublayer:textLayer];
            [textLabels addObject:textLayer];
        }
    }
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = 1.0f / [UIScreen mainScreen].scale;
    lineLayer.fillColor = UIColor.clearColor.CGColor;
    lineLayer.strokeColor = UIColor.redColor.CGColor;
    
    UIBezierPath *linePath = [UIBezierPath new];
    [linePath moveToPoint:CGPointMake(yAxisLabelWidth, self.frame.size.height - xAxisLabelHeight)];
    [linePath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - xAxisLabelHeight)];
    lineLayer.path = linePath.CGPath;
    
    [self.shapeLayers addObject:lineLayer];
    [self.layer addSublayer:lineLayer];
}

- (void)renderYAxis {
    if (yUnitCount == 0) {
        return;
    }
    
    const CGFloat height = self.frame.size.height - xAxisLabelHeight;
    const CGFloat pixelPerYUnit = height / yUnitCount;
    
    NSMutableArray *textLabels = [NSMutableArray new];
    for (int i = 0; i <= yUnitCount; ++i) {
        CATextLayer *textLayer = [CATextLayer layer];
        NSString *labelText = [NSString stringWithFormat:@"+%.1f", i * self.chartData.valuePerYUnit];
        textLayer.string = labelText;
        textLayer.foregroundColor = UIColor.redColor.CGColor;
        textLayer.fontSize = 15;
        textLayer.alignmentMode = @"right";
        
        textLayer.frame = CGRectMake(0, pixelPerYUnit * (yUnitCount - i) - yAxisMaxLabelSize.height * 0.5f, yAxisMaxLabelSize.width, yAxisMaxLabelSize.height);
        
        [self.shapeLayers addObject:textLayer];
        [self.layer addSublayer:textLayer];
        [textLabels addObject:textLayer];
    }
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = 1.0f / [UIScreen mainScreen].scale;
    lineLayer.fillColor = UIColor.clearColor.CGColor;
    lineLayer.strokeColor = UIColor.redColor.CGColor;
    
    UIBezierPath *linePath = [UIBezierPath new];
    [linePath moveToPoint:CGPointMake(yAxisLabelWidth, 0)];
    [linePath addLineToPoint:CGPointMake(yAxisLabelWidth, self.frame.size.height - xAxisLabelHeight)];
    lineLayer.path = linePath.CGPath;
    
    [self.shapeLayers addObject:lineLayer];
    [self.layer addSublayer:lineLayer];
}

- (void)renderBars {
    CGFloat height = self.frame.size.height - xAxisLabelHeight;
    for (RWPChartDataItem *item in self.chartData.items) {
        CAShapeLayer *barLayer = [CAShapeLayer layer];
        barLayer.lineWidth = 10;
        barLayer.fillColor = UIColor.clearColor.CGColor;
        barLayer.strokeColor = UIColor.redColor.CGColor;
        float xunit = item.x / self.chartData.valuePerXUnit + 1;
        float yunit = item.y / self.chartData.valuePerYUnit;
        
        UIBezierPath *barPath = [UIBezierPath new];
        [barPath moveToPoint:CGPointMake(xunit * pixelPerXUnit + yAxisLabelWidth, height)];
        [barPath addLineToPoint:CGPointMake(xunit * pixelPerXUnit + yAxisLabelWidth, height - yunit * pixelPerYUnit)];
        barLayer.path = barPath.CGPath;
        
        [self.shapeLayers addObject:barLayer];
        [self.layer addSublayer:barLayer];
    }
}

- (void)renderHighlight:(RWPChartDataItem *)dataItem {
    if (dataItem) {
        self.highlightLayer.frame = self.bounds;
        [self.highlightLayer.superlayer setZPosition:10000];
        
        CGRect itemRect = [self rectForDataItem:dataItem];
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:itemRect];
        
        [path moveToPoint:CGPointMake(itemRect.origin.x + itemRect.size.width * 0.5f, 0)];
        [path addLineToPoint:CGPointMake(itemRect.origin.x + itemRect.size.width * 0.5f, itemRect.origin.y)];
        
        self.highlightLayer.path = path.CGPath;
    } else {
        self.highlightLayer.path = nil;
    }
}

- (CGRect)rectForDataItem:(RWPChartDataItem *)item {
    CGFloat height = self.frame.size.height - xAxisLabelHeight;
    float xunit = item.x / self.chartData.valuePerXUnit + 1;
    float yunit = item.y / self.chartData.valuePerYUnit;
    
    CGRect rect;
    rect.origin.x = xunit * pixelPerXUnit + yAxisLabelWidth - self.barWidth * 0.5f;
    rect.origin.y = height - yunit * pixelPerYUnit;
    rect.size.width = self.barWidth;
    rect.size.height = yunit * pixelPerYUnit;
    return rect;
}

- (RWPChartDataItem *)checkTouchingBar:(CGPoint)touchPoint {
    for (RWPChartDataItem *item in self.chartData.items) {
        CGRect rect = [self rectForDataItem:item];
        if (CGRectContainsPoint(rect, touchPoint)) {
            return item;
        }
    }
    return nil;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint pt = [[touches anyObject] locationInView:self];
    RWPChartDataItem *selectedItem = [self checkTouchingBar:pt];
    [self renderHighlight:selectedItem];
}

- (NSMutableArray<CAShapeLayer *> *)shapeLayers {
    if (_shapeLayers == nil) {
        _shapeLayers = [NSMutableArray new];
    }
    return _shapeLayers;
}

- (CAShapeLayer *)highlightLayer {
    if (_highlightLayer == nil) {
        _highlightLayer = [CAShapeLayer layer];
        _highlightLayer.lineWidth = 1;
        _highlightLayer.strokeColor = UIColor.redColor.CGColor;
        _highlightLayer.fillColor = UIColor.redColor.CGColor;
        [self.layer addSublayer:_highlightLayer];
    }
    return _highlightLayer;
}

- (UIFont *)labelFont {
    if (_labelFont == nil) {
        _labelFont = [UIFont systemFontOfSize:15];
    }
    return _labelFont;
}
@end
