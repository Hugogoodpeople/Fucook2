//
//  WebServiceSender.h
//  Wan2Trip
//
//  Created by CODANGEL on 30/08/13.
//  Copyright (c) 2013 CodAngel codAngel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebServiceSenderProtocol

-(void)sendCompleteWithResult:(NSDictionary*)result withError:(NSError*)error;

@end

@interface WebServiceSender : NSObject

@property (nonatomic, assign) id delegate;
@property NSString* url;
@property NSString* method;
@property int timeout;
@property int timeoutStep;
@property int retries;


-(id)initWithUrl:(NSString*)serviceUrl method:(NSString*)m tag:(int)tag;
-(id)initWithGetUrl:(NSString*)serviceUrl method:(NSString*)m tag:(int)tag;

-(void)sendDict:(NSDictionary*)dict;
-(void)cancel;

+(int)getTagFromWebServiceSenderDict:(NSDictionary*)dict;

@end