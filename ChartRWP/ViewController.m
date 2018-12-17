//
//  ViewController.m
//  ChartRWP
//
//  Created by ocean on 2018/12/17.
//  Copyright © 2018 handytool. All rights reserved.
//

#import "ViewController.h"
#import "Charts/RWPPieChart.h"
#import "Charts/RWPBarChart.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RWPBarChart *chart = [RWPBarChart new];
    int index = 0;
    NSArray *colors = @[
                        UIColor.redColor,
                        UIColor.greenColor,
                        UIColor.purpleColor,
                        UIColor.orangeColor,
                        UIColor.cyanColor
                        ];
    NSArray<RWPChartDataItem *> *items =@[
                                [RWPChartDataItem.alloc initWithX:0 y:10 xLabel:@""],
                                [RWPChartDataItem.alloc initWithX:1 y:20 xLabel:@""],
                                [RWPChartDataItem.alloc initWithX:2 y:40 xLabel:@""],
                                [RWPChartDataItem.alloc initWithX:3 y:80 xLabel:@""],
                                [RWPChartDataItem.alloc initWithX:4 y:90 xLabel:@""],
                                [RWPChartDataItem.alloc initWithX:5 y:0 xLabel:@""],
                                [RWPChartDataItem.alloc initWithX:6 y:0 xLabel:@""],
                                [RWPChartDataItem.alloc initWithX:7 y:0 xLabel:@""],
                                [RWPChartDataItem.alloc initWithX:8 y:0 xLabel:@""],
                                [RWPChartDataItem.alloc initWithX:9 y:0 xLabel:@""],
                                [RWPChartDataItem.alloc initWithX:10 y:0 xLabel:@""],
                                          ];
    for (RWPChartDataItem *item in items) {
        item.color = colors[index % colors.count];
        index++;
    }
    RWPChartData *data = [RWPChartData.alloc initWithEntries:items];
    data.valuePerYUnit = 30;
    data.valuePerXUnit = 1;
    chart.chartData = data;
    chart.frame = CGRectMake(16, 100, self.view.frame.size.width - 32, 300);
    [self.view addSubview:chart];
}


@end
