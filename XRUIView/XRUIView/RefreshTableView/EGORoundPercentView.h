//
//  EGORoundPercentView.h
//  MDRadialProgress
//
//  Created by libj on 15/5/8.
//  Copyright (c) 2015年 Marco Dinacci. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EGORoundPercentUIColor : NSObject

// Color of the completed steps.
@property (strong, nonatomic) UIColor *completedColor;

// Color of the incompleted steps.
@property (strong, nonatomic) UIColor *incompletedColor;

// Color of the inner center
@property (strong, nonatomic) UIColor *centerColor;

@end

@interface EGORoundPercentView : UIView

// The total number of steps in the progress view.
@property (assign, nonatomic) float progressTotal;

// The number of steps currently completed.
@property (assign, nonatomic) float progressCounter;

// Temp
@property (assign, nonatomic) float progressCounterTemp;

// Whether the progress is drawn clockwise (YES) or anticlockwise (NO)
@property (assign, nonatomic) BOOL clockwise;

// Whether the progress is in indeterminate mode or not
@property (assign, nonatomic) BOOL isIndeterminateProgress;

//
@property (strong, nonatomic) EGORoundPercentUIColor *themeColors;

@end
