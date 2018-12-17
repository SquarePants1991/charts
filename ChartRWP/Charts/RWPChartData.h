//
//  RWPChartData.h
//  ChartRWP
//
//  Created by ocean on 2018/12/17.
//  Copyright © 2018 handytool. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWPChartDataItem : NSObject
@property (assign, nonatomic) float x;
@property (assign, nonatomic) float y;
@property (copy, nonatomic) NSString *xLabel;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *highlightColor;
- (instancetype)initWithX:(float)x y:(float)y xLabel:(NSString *)xLabel;
@end

NS_ASSUME_NONNULL_BEGIN

@interface RWPChartData : NSObject
@property (strong, nonatomic) NSArray<RWPChartDataItem *> *items;
@property (assign, nonatomic) float valuePerXUnit;
@property (assign, nonatomic) float valuePerYUnit;
- (instancetype)initWithEntries:(NSArray<RWPChartDataItem *> *)items;
- (float)totalYValue;
- (int)xUnits;
- (int)yUnits;
@end

NS_ASSUME_NONNULL_END
