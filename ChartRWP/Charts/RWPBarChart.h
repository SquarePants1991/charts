//
//  RWPBarChart.h
//  ChartRWP
//
//  Created by ocean on 2018/12/17.
//  Copyright © 2018 handytool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWPChartData.h"

NS_ASSUME_NONNULL_BEGIN

@interface RWPBarChart : UIView
@property (strong, nonatomic) UIFont *labelFont;
@property (strong, nonatomic) RWPChartData *chartData;
@end

NS_ASSUME_NONNULL_END
