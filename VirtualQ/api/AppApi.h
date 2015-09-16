//
//  AppApi.h
//  VirtualQ
//
//  Created by GrepRuby on 03/07/14.
//  Copyright (c) 2014 optimalconsulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "AFHTTPSessionManager.h"
#import "AFNetworkActivityIndicatorManager.h"


@class User;


@interface AppApi : AFHTTPRequestOperationManager

+(AppApi*)sharedClient ;
+(AppApi*)sharedAuthorizedClient;
-(id)initWithBaseURL:(NSURL *)url;

// Api's
//+(void)createSession:(NSString*)deviceID;
- (AFHTTPRequestOperation *)createSession:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)destroySession:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)getLine:(NSDictionary *)aParams
                            success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                          failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)getAllLine:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)getLineBySearchTerm:(NSDictionary *)aParams
                                        success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                        failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)getUserByToken:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)openQueue:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)getListOfHostedQueue:(NSDictionary *)aParams
                                         success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                         failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)getListOfWaiters:(NSDictionary *)aParams
                                     success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                     failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)getQueueById:(NSDictionary *)aParams
                                 success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                 failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)pullWaiterIntoUpPosition:(NSDictionary *)aParams
                                             success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                             failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)closeQueue:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)getLineById:(NSDictionary *)aParams
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)joinQueue:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)quitLineForWaiters:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)getListofWaitersInJoinedQueue:(NSDictionary *)aParams
                                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)getWaitersById:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)sendDeviceTokenToServer:(NSDictionary *)aParams
                                            success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                            failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;
// GET latitude and longitude by address
- (AFHTTPRequestOperation *)getLatitudeAndLongitudeByAddress:(NSDictionary *)aParams
                                                     success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                                     failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (void)processExceptionBlock:(AFHTTPRequestOperation*)task blockException:(NSException*) exception;
- (void) deleteAllObjects: (NSString *) entityDescription withContext:(NSManagedObjectContext*)localContext;
@end
