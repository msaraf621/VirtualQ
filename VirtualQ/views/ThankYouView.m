//
//  ThankYouView.m
//  VirtualQ
//
//  Created by GrepRuby on 18/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "ThankYouView.h"
#define degreesToRadians(x) ((x) * M_PI / 180.0)

@implementation ThankYouView{
  CGPoint circleCenter;
}

@synthesize shapeFillColor;
@synthesize  shapeStrokColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
  
  circleCenter=CGPointMake(39, 18);
  if(!self.shapeFillColor){
    shapeFillColor = [UIColor whiteColor];
  }
  if(!self.shapeStrokColor){
    shapeStrokColor = [UIColor whiteColor];
  }
  
  [self.shapeStrokColor setStroke];
  [self.shapeFillColor setFill];
  
  UIBezierPath* bezierPath = UIBezierPath.bezierPath;
  [UIColor.blackColor setStroke];
  bezierPath.lineWidth = 1;
  [bezierPath stroke];
  
  
  //// Oval Drawing
 UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(circleCenter.x ,circleCenter.y,UNI_VAL([self calPointX:200], [self calPointX:200]), UNI_VAL([self calPointX:200], [self calPointY:200]))];
  [[UIColor vqfacebookIconColor] setFill];
  [[UIColor vqfacebookIconColor] setStroke];
  [ovalPath stroke];
  [ovalPath fill];
  
  [self facebookIcon:CGPointMake(UNI_VAL(90, 72) ,UNI_VAL(352, 206) )];
 [self rectangleIcon:CGPointMake(UNI_VAL(230,145),UNI_VAL(207, 125))];
 [self thumbsUpIcon:CGPointMake(UNI_VAL(282, 174),UNI_VAL(207, 125))];
}


-(void)setShapeStrokColor:(UIColor*)color{
  shapeStrokColor = color;
  [self setNeedsDisplay];
}
-(void)setShapeFillColor:(UIColor*)color{
  shapeFillColor = color;
  [self setNeedsDisplay];
}

-(float)calPointX:(float)x{
  return x*UNI_VAL(2.0, 1.1);
}
-(float)calPointY:(float)y{
  return y*UNI_VAL(2.0, 1.1);
}

-(void)facebookIcon:(CGPoint)start{
  UIBezierPath* bezierPath = UIBezierPath.bezierPath;
  [bezierPath moveToPoint: CGPointMake(start.x, start.y+[self calPointY:1])];
  [bezierPath addLineToPoint:CGPointMake(start.x, start.y-[self calPointY:48])];
  [bezierPath addLineToPoint:CGPointMake(start.x-[self calPointX:14], start.y-[self calPointY:48])];
  [bezierPath addLineToPoint:CGPointMake(start.x-[self calPointX:14], start.y-[self calPointY:73])];
  [bezierPath addLineToPoint:CGPointMake(start.x, start.y-[self calPointY:73])];
  [bezierPath addLineToPoint:CGPointMake(start.x, start.y-[self calPointY:93])];
  [bezierPath addArcWithCenter:CGPointMake(start.x+ [self calPointX:25],start.y-[self calPointY:93])
                        radius:[self calPointX:24.5f]
                     startAngle:degreesToRadians(180)
                       endAngle:degreesToRadians(270)
                      clockwise:YES];
  [bezierPath addLineToPoint:CGPointMake(start.x+[self calPointX:50.5], start.y-[self calPointY:117])];
  [bezierPath addLineToPoint:CGPointMake(start.x+[self calPointX:50.5], start.y-[self calPointY:93])];
  [bezierPath addLineToPoint:CGPointMake(start.x+[self calPointX:35.5], start.y-[self calPointY:93])];
  [bezierPath addArcWithCenter:CGPointMake(start.x+[self calPointX:35.5], start.y-[self calPointY:86])
                         radius:[self calPointX:7.0f]
                     startAngle:degreesToRadians(270)
                       endAngle:degreesToRadians(180)
                      clockwise:NO];
  [bezierPath addLineToPoint:CGPointMake(start.x+[self calPointX:29.5], start.y-[self calPointY:73])];
  [bezierPath addLineToPoint:CGPointMake(start.x+[self calPointX:51.5], start.y-[self calPointY:73])];
  [bezierPath addLineToPoint:CGPointMake(start.x+[self calPointX:48.5], start.y-[self calPointY:48])];
  [bezierPath addLineToPoint:CGPointMake(start.x+[self calPointX:29.5], start.y-[self calPointY:48])];
  [bezierPath addLineToPoint: CGPointMake(start.x+[self calPointX:28.5], start.y+[self calPointY:22])];
  [bezierPath addArcWithCenter:CGPointMake(start.x+[self calPointX:73], start.y-[self calPointY:67.5])
                         radius:[self calPointX:100.0f]
                     startAngle:degreesToRadians(117)
                       endAngle:degreesToRadians(137.5)
                      clockwise:YES];
 
  
  
  
  [[UIColor vqThankYouScreenBottomViewColor] setFill];
  [[UIColor vqThankYouScreenBottomViewColor] setStroke];


  [bezierPath fill];
  
  bezierPath.lineWidth = 1;
  [bezierPath stroke];
}

-(void) rectangleIcon:(CGPoint)start{
  
  UIBezierPath* bezierPath = UIBezierPath.bezierPath;
  [bezierPath moveToPoint: CGPointMake(start.x, start.y)];
  [bezierPath addLineToPoint:CGPointMake(start.x+[self calPointX:25], start.y)];
  [bezierPath addLineToPoint:CGPointMake(start.x+[self calPointX:25], start.y+[self calPointY:35])];
  [bezierPath addArcWithCenter:CGPointMake(start.x+[self calPointX:21], start.y+[self calPointY:35])
                         radius:[self calPointX:4.0f]
                     startAngle:degreesToRadians(0)
                       endAngle:degreesToRadians(90)
                      clockwise:YES];
  [bezierPath addLineToPoint:CGPointMake(start.x, start.y+[self calPointY:39])];
  [bezierPath addArcWithCenter:CGPointMake(start.x+[self calPointX:1], start.y+[self calPointY:35])
                        radius:[self calPointX:4.0f]
                    startAngle:degreesToRadians(90)
                      endAngle:degreesToRadians(180)
                     clockwise:YES];
  [bezierPath addLineToPoint:CGPointMake(start.x-[self calPointX:3], start.y+[self calPointY:4])];
  [bezierPath addArcWithCenter:CGPointMake(start.x+[self calPointX:1], start.y+[self calPointY:4])
                        radius:[self calPointX:4.0f]
                    startAngle:degreesToRadians(180)
                      endAngle:degreesToRadians(270)
                     clockwise:YES];
  
  [[UIColor vqThankYouScreenBottomViewColor] setFill];
  [[UIColor vqfacebookIconColor] setStroke];

  [bezierPath fill];
  
  bezierPath.lineWidth = 1;
  [bezierPath stroke];

}

-(void) thumbsUpIcon:(CGPoint)start{
  UIBezierPath* bezierPath = UIBezierPath.bezierPath;
  [bezierPath moveToPoint: CGPointMake(start.x, start.y)];
  [bezierPath addLineToPoint:CGPointMake(start.x+[self calPointX:11], start.y-[self calPointY:18])];
  [bezierPath addLineToPoint:CGPointMake(start.x+[self calPointX:11], start.y-[self calPointY:22])];
  [bezierPath addArcWithCenter:CGPointMake(start.x+[self calPointX:17], start.y-[self calPointY:26])
                        radius:[self calPointX:7.0f]
                    startAngle:degreesToRadians(180)
                      endAngle:degreesToRadians(0)
                     clockwise:YES];
  [bezierPath addLineToPoint:CGPointMake(start.x+[self calPointX:27], start.y-[self calPointY:18])];
  [bezierPath addLineToPoint:CGPointMake(start.x+[self calPointX:27], start.y-[self calPointY:6])];
  [bezierPath addLineToPoint:CGPointMake(start.x+[self calPointX:44], start.y-[self calPointY:6])];
  [bezierPath addArcWithCenter:CGPointMake(start.x+[self calPointX:44], start.y+[self calPointY:0.8])
                        radius:[self calPointX:7.0f]
                    startAngle:degreesToRadians(270)
                      endAngle:degreesToRadians(50)
                     clockwise:YES];
  [bezierPath addArcWithCenter:CGPointMake(start.x+[self calPointX:38], start.y+[self calPointY:7.3])
                        radius:[self calPointX:11.5f]
                    startAngle:degreesToRadians(0)
                      endAngle:degreesToRadians(40)
                     clockwise:YES];
  [bezierPath addArcWithCenter:CGPointMake(start.x+[self calPointX:36.5], start.y+[self calPointY:15.8])
                        radius:[self calPointX:11.5f]
                    startAngle:degreesToRadians(0)
                      endAngle:degreesToRadians(40)
                     clockwise:YES];
  [bezierPath addArcWithCenter:CGPointMake(start.x+[self calPointX:31.5], start.y+[self calPointY:24])
                        radius:[self calPointX:14.7f]
                    startAngle:degreesToRadians(5)
                      endAngle:degreesToRadians(55)
                     clockwise:YES];
  [bezierPath addLineToPoint:CGPointMake(start.x+[self calPointX:5], start.y+[self calPointY:36.3])];
  [bezierPath addArcWithCenter:CGPointMake(start.x+[self calPointX:5.5], start.y+[self calPointY:29.5])
                        radius:[self calPointX:7.0f]
                    startAngle:degreesToRadians(90)
                      endAngle:degreesToRadians(140)
                     clockwise:YES];
  [bezierPath addLineToPoint:CGPointMake(start.x, start.y)];



  [[UIColor vqThankYouScreenBottomViewColor] setFill];
  [[UIColor vqfacebookIconColor] setStroke];
  [bezierPath fill];
  
  bezierPath.lineWidth = 1;
  [bezierPath stroke];

}

@end
