//
//  WebServiceSender.m
//  Wan2Trip
//
//  Created by CODANGEL on 30/08/13.
//  Copyright (c) 2013 CodAngel codAngel. All rights reserved.
//

#import "WebServiceSender.h"

#define WEBSERVISESENDERTAG @"webservicesendertag"

@implementation WebServiceSender
{
    NSMutableData *receivedData;
    NSMutableURLRequest *request;
    NSURLConnection *connection;
    int syncState;
    int syncing;
    bool canceled;
    NSDictionary* myDict;
    int timeoutretries;
    int myTag;
    int type;
}

@synthesize delegate, method, retries, timeout, timeoutStep, url;

+(int)getTagFromWebServiceSenderDict:(NSDictionary*)dict
{
    NSNumber* tag = [dict objectForKey:WEBSERVISESENDERTAG];
    if(tag)
        return tag.intValue;
    else
        return -1;
}

-(id)initWithGetUrl:(NSString*)serviceUrl method:(NSString*)m tag:(int)tag
{
    self = [super init];
    if(self)
    {
        type=2; // get
        method = m;
        retries = 3;
        timeoutretries = 0;
        timeout = 30;
        timeoutStep = 15;
        url = serviceUrl;
        myTag = tag;
    }
    return self;
}



-(id)initWithUrl:(NSString*)serviceUrl method:(NSString*)m tag:(int)tag
{
    self = [super init];
    if(self)
    {
        type =1; // post
        method = m;
        retries = 3;
        timeoutretries = 0;
        timeout = 30;
        timeoutStep = 15;
        url = serviceUrl;
        myTag = tag;
    }
    return self;
}

-(void)dealloc
{
    if(connection)
        [connection cancel];
    delegate = nil;
    receivedData = nil;
    request = nil;
    connection = nil;
    url = nil;
    myDict = nil;
}

-(void)sendDict:(NSDictionary*)dict
{
    myDict= dict;
    [self start];
}

-(void)start
{
    [self send:myDict];
}

-(int)isSyncing
{
    @synchronized(self)
    {
        return syncing;
    };
}

-(void)cancel
{
    @synchronized(self)
    {
        syncing = 0;
    };
    [connection cancel];
    [self reset];
}

-(void)readResponse
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&error];
    
    if(json.count==0 || error)
    {
        NSMutableDictionary* errorDict = [NSMutableDictionary new];
        [errorDict setObject:@"Got 0 bytes from server" forKey:@"reason"];
        NSError* myError = [[NSError alloc] initWithDomain:@"WebServiseSenderError" code:0 userInfo:errorDict];
        [self error:error ? error : myError];
    }
    
    else
    {
        [self sucess:json];
    }
    
    [self reset];
}

//connection delegate methods

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{ // executed when the connection receives data
    if (receivedData==nil) {
        receivedData = [[NSMutableData alloc] initWithData:data];
    }
    else
        [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%@ Request response:, '%@'", url, response.description);
    [receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{ //executed when the connection fails
    NSLog(@"URL %@ Connection failed with error: %@", url , error.localizedDescription);
    if(timeoutretries<retries)
    {
        timeoutretries++;
        timeout+= timeoutStep;
        [self start];
    }
    else
    {
        [self error:error];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSMutableDictionary* errorDict = [NSMutableDictionary new];
    [errorDict setObject:@"Remote authentication failed" forKey:@"reason"];
    NSError* error = [[NSError alloc] initWithDomain:@"WebServiseSenderError" code:1 userInfo:errorDict];
    [self error:error];
    [self reset];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    // NSLog(@"%@ Request Complete,recieved %d bytes of data", url ,receivedData.length);
    timeoutretries = 0;
    if(receivedData.length>0)
    {
        [self readResponse];
    }
    else
    {
        NSMutableDictionary* errorDict = [NSMutableDictionary new];
        [errorDict setObject:@"Got 0 bytes from server" forKey:@"reason"];
        NSError* error = [[NSError alloc] initWithDomain:@"WebServiseSenderError" code:0 userInfo:errorDict];
        [self error:error];
    }
}

-(void)reset
{
    canceled = 0;
    timeoutretries =0;
    timeout = 30;
}

-(void)sucess:(NSDictionary*)receivedDict
{
    NSMutableDictionary* sucessDict = [NSMutableDictionary new];
    [sucessDict setObject:[NSNumber numberWithInt:myTag] forKey:WEBSERVISESENDERTAG];
    [sucessDict addEntriesFromDictionary:receivedDict];
    
    if(delegate)
        [delegate performSelector:@selector(sendCompleteWithResult:withError:) withObject:sucessDict withObject:nil];
    
    
}

-(void)error:(NSError*)error
{
    [self reset];
    NSMutableDictionary* emptyDict = [NSMutableDictionary new];
    [emptyDict setObject:[NSNumber numberWithInt:myTag] forKey:WEBSERVISESENDERTAG];
    if(delegate)
        [delegate performSelector:@selector(sendCompleteWithResult:withError:) withObject:emptyDict withObject:error];
}

-(void)send:(NSDictionary*)info
{
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info options:kNilOptions error:&error];
    NSString* data = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData* encodedData = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeout];
    if(type == 1){
        [request setHTTPMethod:@"POST"];
        [request setValue:[NSString stringWithFormat:@"%d", [encodedData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: encodedData];
    }
    else{
        [request setHTTPMethod:@"GET"];
    }
    
    [request addValue:method forHTTPHeaderField:@"METHOD"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setTimeoutInterval:timeout];
    
    connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if (connection) {
        NSLog(@"%@ data sent with size '%d' bytes", url ,encodedData.length);
      //  NSLog(@"url para a foofa %@ data %@", url, encodedData);
    }
}


@end