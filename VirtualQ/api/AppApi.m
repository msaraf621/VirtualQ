//
//  AppApi.m
//  VirtualQ
//
//  Created by GrepRuby on 03/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import "AppApi.h"
#import "VQLine.h"

/* API Constants */
static NSString * const kAppAPIBaseURLString = @"http://virtualq-api.herokuapp.com:80/api/v1";

@interface AppApi(){
  }
@end


@implementation AppApi
 

/* API Clients */
+(AppApi*)sharedClient {
  static AppApi * _sharedClient = nil;
//  _sharedClient.responseSerializer = [AFCompoundResponseSerializer serializer];
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedClient = [[AppApi alloc] initWithBaseURL:[NSURL URLWithString:kAppAPIBaseURLString]];
  });
 // return _sharedClient;

  return [AppApi manager];
 // return nil;
}

+ (AppApi*)sharedAuthorizedClient{
  return nil;
}

/* API Initialization */

-(id)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (!self) {
    return nil;
  }

  return self;
}

/* API Deallocation */

-(void)dealloc {
 
}

#pragma mark- Create Session

- (AFHTTPRequestOperation *)createSession:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  NSUserDefaults *vqDefaults = [NSUserDefaults standardUserDefaults];
  NSDictionary *parameters = @{@"device_hash": [aParams valueForKey:@"deviceID"]};

  NSString *url=[NSString stringWithFormat:@"%@/sessions/login_device.json",kAppAPIBaseURLString];
  return [self POST:url parameters:parameters success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    if(successBlock){
      @try {
        
        NSLog(@"Create Session");
        [vqDefaults setObject:[responseObject valueForKey:@"token"] forKey:@"token"];
        [vqDefaults synchronize];
        
        successBlock(task, responseObject);
      }
      @catch (NSException *exception) {
        [self processExceptionBlock:task blockException:exception];
      }
      
    }
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
    if(failureBlock){
      [self processFailureBlock:task blockError:error];
      NSInteger statusCode = error.code;
      if(statusCode == -1001) {
        // request timed out
      } else if (statusCode == -1009 || statusCode==-1004) {
        // no internet connectivity
        UIAlertView* errorBox = [[UIAlertView alloc]
                                 initWithTitle:@"Error"
                                 message:@"No Internet Connection. Do you want to exit?"
                                 delegate:self
                                 cancelButtonTitle:@"Cancel"
                                 otherButtonTitles:@"Ok",nil];
        [errorBox show];
        

      }
      failureBlock(task, error);
    }
    
  }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex != 0)  // 0 == the cancel button
  {
    //home button press programmatically
    UIApplication *app = [UIApplication sharedApplication];
    [app performSelector:@selector(suspend)];
    
    //wait 2 seconds while app is going background
    [NSThread sleepForTimeInterval:2.0];
    
    //exit app when app is in background
    exit(0);
  }
}


#pragma mark- DELETE /v1/sessions/logout.json Destroy sessions

- (AFHTTPRequestOperation *)destroySession:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  NSUserDefaults *vqDefaults = [NSUserDefaults standardUserDefaults];

  NSString *url=[NSString stringWithFormat:@"%@/sessions/logout.json?token=%@",kAppAPIBaseURLString,[aParams objectForKey:@"token"]];
  
  return [self DELETE:url parameters:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    if(successBlock){
      @try {
        
        NSLog(@"Responce------ %@",responseObject);
        [vqDefaults setObject:nil forKey:@"token"];
        [vqDefaults synchronize];

        successBlock(task, responseObject);
      }
      @catch (NSException *exception) {
        [self processExceptionBlock:task blockException:exception];
      }
      
    }
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
    if(failureBlock){
      [self processFailureBlock:task blockError:error];
      failureBlock(task, error);
    }
    
  }];
}



//Lines Api

#pragma mark - GET /v1/lines.json  List all open Lines. If latitude and longitude are given, lines within 1000 miles radius are returned in order of distance and distance is exposed


- (AFHTTPRequestOperation *)getLine:(NSDictionary *)aParams
                                 success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                 failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  

  CLLocation *userLoc=[aParams objectForKey:@"userLocation"];

  NSString *url=[NSString stringWithFormat:@"%@/lines.json?latitude=%f&longitude=%f",kAppAPIBaseURLString,userLoc.coordinate.latitude,userLoc.coordinate.longitude];
  
  //Deletes all objects
  // NSManagedObjectContext *localContext =[NSManagedObjectContext contextForCurrentThread];
  // [self deleteAllObjects:@"VQLine" withContext:localContext];

  return [self GET:url parameters:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    if(successBlock){
      @try {
        NSManagedObjectContext *localContext =[NSManagedObjectContext contextForCurrentThread];
        [VQLine entityFromArray:responseObject inContext:localContext];
        NSLog(@"Get Current position lines");

        successBlock(task, responseObject);
      }
      @catch (NSException *exception) {
        [self processExceptionBlock:task blockException:exception];
      }
      
    }
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
    if(failureBlock){
      [self processFailureBlock:task blockError:error];
      failureBlock(task, error);
    }
    
  }];
}

- (AFHTTPRequestOperation *)getAllLine:(NSDictionary *)aParams
                            success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                            failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  NSString *url=[NSString stringWithFormat:@"%@/lines.json",kAppAPIBaseURLString];

  //Deletes all objects
//  NSManagedObjectContext *localContext =[NSManagedObjectContext contextForCurrentThread];
//  [self deleteAllObjects:@"VQLine" withContext:localContext];
  
  return [self GET:url parameters:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    if(successBlock){
      @try {
        NSManagedObjectContext *localContext =[NSManagedObjectContext contextForCurrentThread];
        [VQLine entityFromArray:responseObject inContext:localContext];
        NSLog(@"Get all lines");

        successBlock(task, responseObject);
      }
      @catch (NSException *exception) {
        [self processExceptionBlock:task blockException:exception];
      }
      
    }
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
    if(failureBlock){
      [self processFailureBlock:task blockError:error];
      failureBlock(task, error);
    }
    
  }];
}

- (AFHTTPRequestOperation *)getLineBySearchTerm:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  CLLocation *userLoc=[aParams objectForKey:@"userLocation"];

NSString *url=[NSString stringWithFormat:@"%@/lines.json?latitude=%f&longitude=%f&search_term=%@",kAppAPIBaseURLString,userLoc.coordinate.latitude,userLoc.coordinate.longitude,[aParams objectForKey:@"search_term"]];
 
  url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSLog(@"Get searched lines");


  //Deletes all objects
 // NSManagedObjectContext *localContext =[NSManagedObjectContext contextForCurrentThread];
  //[self deleteAllObjects:@"VQLine" withContext:localContext];
  
  return [self GET:url parameters:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    if(successBlock){
      @try {
        NSManagedObjectContext *localContext =[NSManagedObjectContext contextForCurrentThread];
        [VQLine entityFromArray:responseObject inContext:localContext];
        
        successBlock(task, responseObject);
      }
      @catch (NSException *exception) {
        [self processExceptionBlock:task blockException:exception];
      }
      
    }
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
    if(failureBlock){
      [self processFailureBlock:task blockError:error];
      failureBlock(task, error);
    }
    
  }];
}


#pragma mark- GET /v1/users/{token}.json Get User by Token

- (AFHTTPRequestOperation *)getUserByToken:(NSDictionary *)aParams
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  
  NSString *url=[NSString stringWithFormat:@"%@/users/%@.json",kAppAPIBaseURLString,[aParams objectForKey:@"token"]];
  
  return [self GET:url parameters:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    if(successBlock){
      @try {
        
        NSLog(@"getUserByToken");

        successBlock(task, responseObject);
      }
      @catch (NSException *exception) {
        [self processExceptionBlock:task blockException:exception];
      }
      
    }
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
    if(failureBlock){
      [self processFailureBlock:task blockError:error];
      failureBlock(task, error);
    }
    
  }];
}




#pragma mark- GET /v1/lines/{id}.json Get Queue by ID


- (AFHTTPRequestOperation *)getLineById:(NSDictionary *)aParams
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  
  NSString *url=[NSString stringWithFormat:@"%@/lines/%@.json",kAppAPIBaseURLString,[aParams objectForKey:@"lineId"]];
  
  return [self GET:url parameters:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    if(successBlock){
      @try {
        
        NSLog(@"getLineById");
        
        successBlock(task, responseObject);
      }
      @catch (NSException *exception) {
        [self processExceptionBlock:task blockException:exception];
      }
      
    }
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
    if(failureBlock){
      [self processFailureBlock:task blockError:error];
      failureBlock(task, error);
    }
    
  }];
}

//Host Api

#pragma mark- POST /v1/hosts.json Open a Queue

- (AFHTTPRequestOperation *)openQueue:(NSDictionary *)aParams
                                             success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                             failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  NSUserDefaults *vqDefaults = [NSUserDefaults standardUserDefaults];

  NSString *url=[NSString stringWithFormat:@"%@/hosts.json",kAppAPIBaseURLString];

  return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    if(successBlock){
      @try {
        
        NSLog(@"openQueue ---- %@",responseObject);
        NSLog(@"LineId: %@", [responseObject objectForKey:@"id"]);
        [vqDefaults setObject:[responseObject objectForKey:@"id"] forKey:@"lineId"];
        [vqDefaults synchronize];
        
        successBlock(task, responseObject);
      }
      @catch (NSException *exception) {
        [self processExceptionBlock:task blockException:exception];
      }
      
    }
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
    if(failureBlock){
      [self processFailureBlock:task blockError:error];
      failureBlock(task, error);
    }
    
  }];
}

#pragma mark- GET /v1/hosts.json Get List of Hosted Queues

- (AFHTTPRequestOperation *)getListOfHostedQueue:(NSDictionary *)aParams
                                 success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                 failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{

  NSString *url=[NSString stringWithFormat:@"%@/hosts.json?token=%@",kAppAPIBaseURLString,[aParams objectForKey:@"token"]];
  return [self GET:url parameters:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    if(successBlock){
      @try {
        NSLog(@"getListOfHostedQueue-- %@",responseObject);
        successBlock(task, responseObject);
      }
      @catch (NSException *exception) {
        [self processExceptionBlock:task blockException:exception];
      }
      
    }
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
    if(failureBlock){
      [self processFailureBlock:task blockError:error];
      failureBlock(task, error);
    }
    
  }];
}


#pragma  mark- GET /v1/hosts/{id}.json Get Hosted Queue by Id


- (AFHTTPRequestOperation *)getQueueById:(NSDictionary *)aParams
                                     success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                     failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  NSString *url=[NSString stringWithFormat:@"%@/hosts/%@.json?token=%@",kAppAPIBaseURLString,[aParams objectForKey:@"lineId"],[aParams objectForKey:@"token"]];

  return [self GET:url parameters:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    if(successBlock){
      @try {
        NSLog(@"getQueueById");
        successBlock(task, responseObject);
      }
      @catch (NSException *exception) {
        [self processExceptionBlock:task blockException:exception];
      }
      
    }
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
    if(failureBlock){
      [self processFailureBlock:task blockError:error];
      failureBlock(task, error);
    }
    
  }];
}


#pragma mark- GET /v1/hosts/{id}/waiters.json Get List of Waiters with Queue Id


- (AFHTTPRequestOperation *)getListOfWaiters:(NSDictionary *)aParams
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  NSString *url=[NSString stringWithFormat:@"%@/hosts/%@/waiters.json?token=%@",kAppAPIBaseURLString,[aParams objectForKey:@"lineId"],[aParams objectForKey:@"token"]];
  
  return [self GET:url parameters:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    if(successBlock){
      @try {
        
        //Deletes all objects
        NSManagedObjectContext *localContext =[NSManagedObjectContext contextForCurrentThread];
        [self deleteAllObjects:@"VQWaiters" withContext:localContext];

        NSLog(@"getListOfWaiters------ %lu",(unsigned long)[responseObject count]);
        [VQWaiters entityFromArray:responseObject inContext:localContext];
        successBlock(task, responseObject);
      }
      @catch (NSException *exception) {
        [self processExceptionBlock:task blockException:exception];
      }
     
    }
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
    if(failureBlock){
      [self processFailureBlock:task blockError:error];
      failureBlock(task, error);
    }
    
  }];
}

#pragma mark- PUT /v1/hosts/{id}/pull.json  Pull waiter into UP position

- (AFHTTPRequestOperation *)pullWaiterIntoUpPosition:(NSDictionary *)aParams
                                     success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                     failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{

  NSString *url=[NSString stringWithFormat:@"%@/hosts/%@/pull.json",kAppAPIBaseURLString,[aParams objectForKey:@"lineId"]];
  
  return [self PUT:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    if(successBlock){
      @try {
        
        NSLog(@"pullWaiterIntoUpPosition------ %lu",(unsigned long)[responseObject count]);

        successBlock(task, responseObject);
      }
      @catch (NSException *exception) {
        [self processExceptionBlock:task blockException:exception];
      }
      
    }
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
    if(failureBlock){
      //[self processFailureBlock:task blockError:error];
           failureBlock(task, error);
    }
    
  }];
}

#pragma mark- DELETE /v1/hosts/{id}.json Close a Queue

- (AFHTTPRequestOperation *)closeQueue:(NSDictionary *)aParams
                                             success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                             failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{

//NSString *url=[NSString stringWithFormat:@"http://virtualq-api.herokuapp.com:80/api/v1/hosts/30.json?token=FR9HHWrLCQHhBD8Mc9gW"];

  NSString *url=[NSString stringWithFormat:@"%@/hosts/%@.json?token=%@",kAppAPIBaseURLString,[aParams objectForKey:@"lineId"],[aParams objectForKey:@"token"]];
  return [self DELETE:url parameters:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    if(successBlock){
      @try {
        
        NSLog(@"closeQueue");
        
        successBlock(task, responseObject);
      }
      @catch (NSException *exception) {
        [self processExceptionBlock:task blockException:exception];
      }
      
    }
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
    if(failureBlock){
      [self processFailureBlock:task blockError:error];
      failureBlock(task, error);
    }
    
  }];
}

// Waiter Api

#pragma mark- POST /v1/waiters.json Join a Queue

- (AFHTTPRequestOperation *)joinQueue:(NSDictionary *)aParams
                                             success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                             failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  NSString *url=[NSString stringWithFormat:@"%@/waiters.json",kAppAPIBaseURLString];
  return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    if(successBlock){
      @try {
        
        NSLog(@"joinQueue");
        
        successBlock(task, responseObject);
      }
      @catch (NSException *exception) {
        [self processExceptionBlock:task blockException:exception];
      }
      
    }
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
    if(failureBlock){
      [self processFailureBlock:task blockError:error];
      NSLog(@"%@",task.responseString);
      NSLog(@"Error: %@", [error debugDescription]);
      NSLog(@"Error: %@", [error localizedDescription]);
      failureBlock(task, error);
    }
    
  }];
}


#pragma mark- DELETE /v1/waiters/{id}.json  Leave a Queue

- (AFHTTPRequestOperation *)quitLineForWaiters:(NSDictionary *)aParams
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  //http://virtualq-api.herokuapp.com:80/api/v1/waiters/12.json?token=dTDrxqxxZyxFLJihn7HS

  NSString *url=[NSString stringWithFormat:@"%@/waiters/%@.json?token=%@",kAppAPIBaseURLString,[aParams objectForKey:@"waiters_id"],[aParams objectForKey:@"token"]];  
  return [self DELETE:url parameters:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    if(successBlock){
      @try {
        
        NSLog(@"quitLineForWaiters");
        
        successBlock(task, responseObject);
      }
      @catch (NSException *exception) {
        [self processExceptionBlock:task blockException:exception];
      }
      
    }
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
    if(failureBlock){
      [self processFailureBlock:task blockError:error];
      failureBlock(task, error);
    }
    
  }];
}

#pragma mark- GET /v1/waiters.json Get List of Waiters in Joined Queues

- (AFHTTPRequestOperation *)getListofWaitersInJoinedQueue:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  NSString *url=[NSString stringWithFormat:@"%@/waiters.json?token=%@",kAppAPIBaseURLString,[aParams objectForKey:@"token"]];
  
  return [self GET:url parameters:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    if(successBlock){
      @try {
        
        NSLog(@"getListofWaitersInJoinedQueue");
        
        successBlock(task, responseObject);
      }
      @catch (NSException *exception) {
        [self processExceptionBlock:task blockException:exception];
      }
      
    }
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
    if(failureBlock){
      [self processFailureBlock:task blockError:error];
      failureBlock(task, error);
    }
    
  }];
}

#pragma mark- GET /v1/waiters/{id}.json Get Waiter by Id

- (AFHTTPRequestOperation *)getWaitersById:(NSDictionary *)aParams
                                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  NSString *url=[NSString stringWithFormat:@"%@/waiters/%@.json?token=%@",kAppAPIBaseURLString,[aParams objectForKey:@"waiters_id"] ,[aParams objectForKey:@"token"]];
  
  return [self GET:url parameters:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    if(successBlock){
      @try {
        
        NSLog(@"getListofWaitersInJoinedQueue");
        
        successBlock(task, responseObject);
      }
      @catch (NSException *exception) {
        [self processExceptionBlock:task blockException:exception];
      }
      
    }
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
    if(failureBlock){
      [self processFailureBlock:task blockError:error];
      failureBlock(task, error);
    }
    
  }];
}

#pragma mark- Dummy Method for sending device token for push notification to server

-(AFHTTPRequestOperation *)sendDeviceTokenToServer:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{

  NSString *url=[NSString stringWithFormat:@"%@/users/set_apn_token.json",kAppAPIBaseURLString];
//  url=@"";
  
  return [self PUT:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    if(successBlock){
      @try {
        
        NSLog(@"sendDeviceTokenToServer");
        
        successBlock(task, responseObject);
      }
      @catch (NSException *exception) {
        [self processExceptionBlock:task blockException:exception];
      }
      
    }
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    
    if(failureBlock){
      [self processFailureBlock:task blockError:error];
      NSLog(@"%@",task.responseString);
      NSLog(@"Error: %@", [error debugDescription]);
      NSLog(@"Error: %@", [error localizedDescription]);
      failureBlock(task, error);
    }
    
  }];
}



#pragma mark- other methods

-(void)processExceptionBlock:(AFHTTPRequestOperation*)task blockException:(NSException*) exception{
  NSLog(@"Exception : %@",((NSException*)exception));
}

- (void) deleteAllObjects: (NSString *) entityDescription withContext:(NSManagedObjectContext*)localContext{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:localContext];
  [fetchRequest setEntity:entity];
  
  NSError *error;
  NSArray *items = [localContext executeFetchRequest:fetchRequest error:&error];
  
  
  for (NSManagedObject *managedObject in items) {
    [localContext deleteObject:managedObject];
  }
  if (![localContext save:&error]) {
  }
  
}


- (NSError*)processFailureBlock:(AFHTTPRequestOperation*) task blockError:(NSError*) error{
  //Common Method for error handling
  // Do some thing for error handling
    NSLog(@"Error :%@",error);
  return nil;
}


#pragma mark - GET latitude and longitude by Address

- (AFHTTPRequestOperation *)getLatitudeAndLongitudeByAddress:(NSDictionary *)aParams
                                                     success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                                     failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    NSString *url=[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?address=+%@+&sensor=false",[aParams objectForKey:@"address"]];
    return [self GET:url parameters:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
        
        if(successBlock){
            @try {
                NSLog(@"getListOfHostedQueue-- %@",responseObject);
                successBlock(task, responseObject);
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
        }
    }];
}



@end
