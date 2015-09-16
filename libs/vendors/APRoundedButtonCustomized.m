//
//  APRoundedButtonCustomized.m
//  VirtualQ
//
//  Created by GrepRuby on 23/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "APRoundedButtonCustomized.h"

@implementation APRoundedButtonCustomized

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

//add the animation part
- (void)animate //this method is called within the this class
{
  
  [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    self.layer.affineTransform = CGAffineTransformMakeScale(0.0f, 0.0f);
    //edit: comment below lines becz u already made it to round
    //  self.layer.cornerRadius = 0.0f;
    //  self.layer.masksToBounds = YES;
    //  self.clipsToBounds = YES;
    
    //        CATransform3D t = CATransform3DIdentity;
    //        t = CATransform3DMakeScale(0 , 0, 1.0f);
    //        cButton.layer.transform = t;
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
      self.layer.affineTransform = CGAffineTransformMakeScale(1.0f, 1.0f);
      //  edit comment below lines
      //  self.layer.cornerRadius = self.frame.size.width/2;
      //  self.layer.masksToBounds = YES;
      //  self.clipsToBounds = YES;
      //            CATransform3D t = CATransform3DIdentity;
      //            t = CATransform3DMakeScale(1 , 1, 1.0f);
      //            cButton.layer.transform = t;
    } completion:nil];
  }];
  
}

//implement touch handling methods to call animation
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self animate];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self animate];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  // [self animate];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  // [self animate];
}


@end
