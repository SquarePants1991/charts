//
//  RWPPieChart.m
//  ChartRWP
//
//  Created by ocean on 2018/12/17.
//  Copyright © 2018 handytool. All rights reserved.
//

#import "RWPPieChart.h"

@interface RWPPieChart ()
@property (strong, nonatomic) NSMutableArray<CAShapeLayer *> *shapeLayers;
@end

@implementation RWPPieChart

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
    float totalY = [self.chartData totalYValue];
    float currentAngle = -M_PI_2;
    CGPoint center = CGPointMake(self.bounds.size.width * 0.5f, self.bounds.size.height * 0.5f);
    float radius = (self.bounds.size.height > self.bounds.size.width ? self.bounds.size.width : self.bounds.size.height) * 0.5f;
    for (RWPChartDataItem *dataItem in self.chartData.items) {
        float segmentAngle = -dataItem.y / totalY * M_PI * 2.0f;
        [self renderSegment:currentAngle to:currentAngle + segmentAngle center:center radius: radius color:dataItem.color];
        currentAngle += segmentAngle;
    }
}

- (void)renderSegment:(float)fromAngle to:(float)toAngle center:(CGPoint)center radius:(CGFloat)radius color:(UIColor *)color {
    const CGFloat kLineWidth = 50;
    
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.strokeColor = color.CGColor;
    layer.lineWidth = kLineWidth;
    layer.fillColor = UIColor.clearColor.CGColor;
    UIBezierPath *segmentPath = [UIBezierPath new];
    [segmentPath addArcWithCenter:center radius:radius - kLineWidth * 0.5f startAngle:fromAngle endAngle:toAngle clockwise:NO];
    layer.path = segmentPath.CGPath;
    [self.shapeLayers addObject:layer];
    [self.layer addSublayer:layer];
    layer.frame = self.bounds;
}

- (NSMutableArray<CAShapeLayer *> *)shapeLayers {
    if (_shapeLayers == nil) {
        _shapeLayers = [NSMutableArray new];
    }
    return _shapeLayers;
}
@end
