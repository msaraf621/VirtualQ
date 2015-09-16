//
//  VQWaiters.h
//  VirtualQ
//
//  Created by GrepRuby on 11/08/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface VQWaiters : NSManagedObject

@property (nonatomic, retain) NSString * group_name;
@property (nonatomic, retain) NSNumber * waiters_id;
@property (nonatomic, retain) NSNumber * party_size;
@property (nonatomic, retain) NSNumber * wait_time;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSNumber * line_size;
@property (nonatomic, retain) NSString * line_name;
@property (nonatomic, retain) NSString * location;

+(void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+(id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;

@end
