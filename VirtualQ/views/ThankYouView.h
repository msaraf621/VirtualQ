//
//  ThankYouView.h
//  VirtualQ
//
//  Created by GrepRuby on 18/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThankYouView : UIView

@property (nonatomic,assign) UIColor *shapeFillColor;
@property (nonatomic,assign) UIColor *shapeStrokColor;


-(void)setShapeStrokColor:(UIColor*)color;
-(void)setShapeFillColor:(UIColor*)color;

@end
