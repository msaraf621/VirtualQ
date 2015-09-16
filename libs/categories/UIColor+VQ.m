//
//  UIColor+VQ.m
//  VirtualQ
//
//  Created by GrepRuby on 05/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "UIColor+VQ.h"

@implementation UIColor (VQ)

+(UIColor*)colorFromHex:(NSString *)hex {
  
  NSString *colorString = [[hex uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ;
  if ([colorString length] < 6)
    return [UIColor grayColor];
  
  if ([colorString hasPrefix:@"0X"])
    colorString = [colorString substringFromIndex:2];
  else if ([colorString hasPrefix:@"#"])
    colorString = [colorString substringFromIndex:1];
  else if ([colorString length] != 6)
    return  [UIColor grayColor];
  
  NSRange range;
  range.location = 0;
  range.length = 2;
  NSString *rString = [colorString substringWithRange:range];
  range.location += 2;
  NSString *gString = [colorString substringWithRange:range];
  range.location += 2;
  NSString *bString = [colorString substringWithRange:range];
  
  unsigned int red, green, blue;
  [[NSScanner scannerWithString:rString] scanHexInt:&red];
  [[NSScanner scannerWithString:gString] scanHexInt:&green];
  [[NSScanner scannerWithString:bString] scanHexInt:&blue];
  
  return [UIColor colorWithRed:((float) red / 255.0f)
                         green:((float) green / 255.0f)
                          blue:((float) blue / 255.0f)
                         alpha:1.0f];
}

+(UIColor*)colorFromHex:(NSString *)hex withAlpha:(float)alpha{
  
  NSString *colorString = [[hex uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ;
  if ([colorString length] < 6)
    return [UIColor grayColor];
  
  if ([colorString hasPrefix:@"0X"])
    colorString = [colorString substringFromIndex:2];
  else if ([colorString hasPrefix:@"#"])
    colorString = [colorString substringFromIndex:1];
  else if ([colorString length] != 6)
    return  [UIColor grayColor];
  
  NSRange range;
  range.location = 0;
  range.length = 2;
  NSString *rString = [colorString substringWithRange:range];
  range.location += 2;
  NSString *gString = [colorString substringWithRange:range];
  range.location += 2;
  NSString *bString = [colorString substringWithRange:range];
  
  unsigned int red, green, blue;
  [[NSScanner scannerWithString:rString] scanHexInt:&red];
  [[NSScanner scannerWithString:gString] scanHexInt:&green];
  [[NSScanner scannerWithString:bString] scanHexInt:&blue];
  
  return [UIColor colorWithRed:((float) red / 255.0f)
                         green:((float) green / 255.0f)
                          blue:((float) blue / 255.0f)
                         alpha:alpha];
  
}

// Opening Screen - Common

+(UIColor*)vqBackgroundColor{
  return [self colorFromHex:@"#F8F8F8" withAlpha:1.0f];
}

+(UIColor*)vqPulseBubbleColor{
  return [self colorFromHex:@"#f7c245" withAlpha:1.0f];
}

+(UIColor*)vqAnyWaitButtonColor{
  return [self colorFromHex:@"#F5D05E" withAlpha:1.0f];
}

+(UIColor*)vqOpenLineBubbleColor{
  return [self colorFromHex:@"#ef9666" withAlpha:1.0f];
}

+(UIColor*)vqOpenLineBubbleTextColor{
  return [self colorFromHex:@"#333333" withAlpha:1.0f];
}

// Open Queue - Host Mode

+(UIColor*)vqPlaceholderTextColor{
  return [self colorFromHex:@"#444444" withAlpha:1.0f];
}

+(UIColor*)vqTextField2Color{
  return [self colorFromHex:@"#f5cf5f" withAlpha:1.0f];
}

+(UIColor*)vqQuitQueueButtonColor{
  return [self colorFromHex:@"#E0D3BF" withAlpha:1.0f];
}



//Manage Queue - Host Mode

+(UIColor*)vqBubbleColor{
  return [self colorFromHex:@"#f5cf5f" withAlpha:1.0f];
}

+(UIColor*)vqBubbleTextColor{
  return [self colorFromHex:@"#333333" withAlpha:1.0f];
}

+(UIColor*)vqNoUserBubbleColor{
  return [self colorFromHex:@"#f5e1ab" withAlpha:1.0f];
}

+(UIColor*)vqCounterViewColor{
  return [self colorFromHex:@"#ed9566" withAlpha:1.0f];
}

// LookForQueue - User Mode

+(UIColor*)vqJoinButtonColor{
  return [self colorFromHex:@"#88B96D" withAlpha:1.0f];
}

+(UIColor*)vqTableViewTextColor{
  return [self colorFromHex:@"#333333" withAlpha:1.0f];
}

+(UIColor*)vqTeaserStateColor{
  return [self colorFromHex:@"#e3e0d8" withAlpha:1.0f];
}

+(UIColor*)vqTableViewCellBubbleColor{
    return [self colorFromHex:@"#F5D05E" withAlpha:1.0f];
}


// Join Queue With Counter - User Mode

+(UIColor*)vqCountIncreaseColor{
  return [self colorFromHex:@"#89b86c" withAlpha:1.0f];
}

+(UIColor*)vqCountDecreaseColor{
  return [self colorFromHex:@"#ef9666" withAlpha:1.0f];
}

+(UIColor*)vqCountWaitingUserColor{
  return [self colorFromHex:@"#EFEDE9" withAlpha:1.0f];
}

+(UIColor*)vqPlusMinusColor{
  return [self colorFromHex:@"#333333" withAlpha:1.0f];
}


//Quit Queue and Quit Line Colors

+(UIColor*)vqYesAndNoButtonTitleColor{
  return [self colorFromHex:@"#333333" withAlpha:1.0f];
}

+(UIColor*)vqYesBubbleColor{
  return [self colorFromHex:@"#f5cf5f" withAlpha:1.0f];
}

+(UIColor*)vqNoBubbleColor{
  return [self colorFromHex:@"#ef9666" withAlpha:1.0f];
}

// Current Position Screen

+(UIColor*)vqCurrentPositonBubbleColor{
  return [self colorFromHex:@"#F5D05E" withAlpha:1.0f];
}



// Push Notification Screen

+(UIColor*)vqPushNotificationTopViewColor{
  return [self colorFromHex:@"#fcf7eb" withAlpha:1.0f];
}


+(UIColor*)vqPushNotificationBottomViewColor{
  return [self colorFromHex:@"#f5cf5f" withAlpha:1.0f];
}

+(UIColor*)vqPushNotificationBottomViewAnimationColor{
  return [self colorFromHex:@"#F5D05E" withAlpha:1.0f];
}


// Thankyou Screen - Common

+(UIColor*)vqThankYouScreenBottomViewColor{
  return [self colorFromHex:@"#e0d3bf" withAlpha:1.0f];
}

+(UIColor*)vqThankYouScreenTopViewColor{
  return [self colorFromHex:@"#f0e9df" withAlpha:1.0f];
}

+(UIColor*)vqfacebookIconColor{
  return [self colorFromHex:@"#3c5b99" withAlpha:1.0f];
}



@end
