//
//  CounterView.h
//  VirtualQ
//
//  Created by GrepRuby on 14/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CounterView : UIView

@property (nonatomic,assign) UIColor *shapeFillColor;
@property (nonatomic,assign) UIColor *shapeStrokColor;

-(void)setShapeStrokColor:(UIColor*)color;
-(void)setShapeFillColor:(UIColor*)color;

@end
