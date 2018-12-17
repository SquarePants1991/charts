//
//  RWPChartData.m
//  ChartRWP
//
//  Created by ocean on 2018/12/17.
//  Copyright © 2018 handytool. All rights reserved.
//

#import "RWPChartData.h"

@implementation RWPChartDataItem
- (instancetype)initWithX:(float)x y:(float)y xLabel:(NSString *)xLabel {
    if (self = [super init]) {
        self.x = x;
        self.y = y;
        self.xLabel = xLabel;
    }
    return self;
}
@end

@implementation RWPChartData {
    
}
- (instancetype)initWithEntries:(NSArray<RWPChartDataItem *> *)items {
    if (self = [super init]) {
        self.items = items;
    }
    return self;
}

- (float)totalYValue {
    __block float finalValue = 0;
    [self.items enumerateObjectsUsingBlock:^(RWPChartDataItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        finalValue += obj.y;
    }];
    return finalValue;
}

- (int)xUnits {
    __block float maxX = 0.0f;
    [self.items enumerateObjectsUsingBlock:^(RWPChartDataItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        maxX = MAX(obj.x, maxX);
    }];
    return (int)(maxX / self.valuePerXUnit + 0.5f) + 1;
}

- (int)yUnits {
    __block float maxY = 0.0f;
    [self.items enumerateObjectsUsingBlock:^(RWPChartDataItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        maxY = MAX(obj.y, maxY);
    }];
    return (int)(maxY / self.valuePerYUnit + 0.5f);
}
@end
