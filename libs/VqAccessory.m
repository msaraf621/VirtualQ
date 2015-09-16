//
//  VqAccessory.m
//  VirtualQ
//
//  Created by GrepRuby on 30/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "VqAccessory.h"

@implementation VqAccessory

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor];
  }
  return self;
}


+ (VqAccessory *)accessoryWithColor:(UIColor *)color
{
	VqAccessory *ret = [[VqAccessory alloc] initWithFrame:CGRectMake(0, 0, 15.0, 15.0)];
	ret.accessoryColor = [UIColor vqTableViewTextColor];
  
	return ret;
}

- (void)drawRect:(CGRect)rect
{
  // (x,y) is the tip of the arrow
	CGFloat midx = CGRectGetMidX(self.bounds);
	CGFloat midy = CGRectGetMidY(self.bounds);
	const CGFloat R = 10;
	CGContextRef ctxt = UIGraphicsGetCurrentContext();
  
  if(self.accessoryType == AccessoryTypeTypeArrowLeft){
    CGFloat x = (midx*2)-2 ;
    CGFloat y = midy;
    CGContextMoveToPoint(ctxt, x-R, y-R);
    CGContextAddLineToPoint(ctxt, x, y);
    CGContextAddLineToPoint(ctxt, x-R, y+R);
  }else if(self.accessoryType == AccessoryTypeTypeArrowRight){
    CGFloat x = 3;
    CGFloat y = midy;
    CGContextMoveToPoint(ctxt, x+R, y-R);
    CGContextAddLineToPoint(ctxt, x, y);
    CGContextAddLineToPoint(ctxt, x+R, y+R);
  }else if(self.accessoryType == AccessoryTypeTypeArrowUp){
    CGFloat x = midx;
    CGFloat y = midy;
    CGContextMoveToPoint(ctxt, x-R, y+R);
    CGContextAddLineToPoint(ctxt, x, y);
    CGContextAddLineToPoint(ctxt, x+R, y+R);
  }else if(self.accessoryType == AccessoryTypeTypeArrowDown){
    CGFloat x = midx;
    CGFloat y = midy;
    CGContextMoveToPoint(ctxt, x-R, y-R);
    CGContextAddLineToPoint(ctxt, x, y);
    CGContextAddLineToPoint(ctxt, x+R, y-R);
  }else{
    // AccessoryTypeTypeArrowLeft Default
    CGFloat x = (midx * 2) - 3;
    CGFloat y = midy;
    CGContextMoveToPoint(ctxt, x-R, y-R);
    CGContextAddLineToPoint(ctxt, x, y);
    CGContextAddLineToPoint(ctxt, x-R, y+R);
  }
  
	CGContextSetLineCap(ctxt, kCGLineCapSquare);
	CGContextSetLineJoin(ctxt, kCGLineJoinMiter);
	CGContextSetLineWidth(ctxt, 0.75);
  
	if (self.highlighted)
  {
		[self.highlightedColor setStroke];
  }
	else
  {
		[self.accessoryColor setStroke];
  }
  
	CGContextStrokePath(ctxt);
  //TODO
  ctxt = nil;
}

- (void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];
  
	[self setNeedsDisplay];
}

- (UIColor *)accessoryColor
{
	if (!_accessoryColor)
  {
		return [UIColor blackColor];
  }
  
	return _accessoryColor;
}

- (UIColor *)highlightedColor
{
	if (!_highlightedColor)
  {
		return [UIColor whiteColor];
  }
  
	return _highlightedColor;
}

- (void)updateAccessoryType:(AccessoryType)type
{
	[self setAccessoryType:type];
	[self setNeedsDisplay];
}


@synthesize accessoryColor = _accessoryColor;
@synthesize highlightedColor = _highlightedColor;

@end
