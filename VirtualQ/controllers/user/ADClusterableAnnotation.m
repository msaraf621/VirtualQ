//
//  ADClusterableAnnotation.m
//  ADClusterMapView
//
//  Created by Patrick Nollet on 27/06/11.
//  Copyright 2011 Applidium. All rights reserved.
//

#import "ADClusterableAnnotation.h"

@interface ADClusterableAnnotation () {
    NSString * _name;
}

@end

@implementation ADClusterableAnnotation

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _name = [dictionary objectForKey:@"name"];
    CLLocation *location=[dictionary objectForKey:@"coordinates"];
      self.coordinate=location.coordinate;
      }
    return self;
}

- (NSString *)title {
    return self.description;
}

- (NSString *)description {
    return _name;
}
@end
