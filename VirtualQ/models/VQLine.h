//
//  VQLine.h
//  VirtualQ
//
//  Created by GrepRuby on 07/08/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>


@interface VQLine : NSManagedObject

@property (nonatomic, retain) NSNumber * line_id;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * line_size;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * open;
@property (nonatomic) BOOL  flag;



+(void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+(id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;

/**
 Returns a CLLocation representation of this lines' Location.
 */
- (CLLocation *)computedLocation;


@end
