//
//  Created by Alberto Pasca on 27/02/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APRoundedButton : UIButton

@property (nonatomic, assign) int style;
@property (nonatomic,retain) UIColor *shapeFillColor;
@property (nonatomic,retain) UIColor *shapeStrokColor;

-(void)setShapeStrokColor:(UIColor*)color;
-(void)setShapeFillColor:(UIColor*)color;
-(void)setTitleOfButton:(NSString*)title;
@end
