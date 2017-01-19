//
//  AffiliateRedirectToItunes.m
//  AffiliateRedirectToItunes
//
//  Created by yhw on 17/1/18.
//  Copyright © 2017年 yhw. All rights reserved.
//

#import "AffiliateRedirectToITunes.h"

static NSString * const kAffiliateRedirectToITunesDomain = @"AffiliateRedirectToITunes";

static NSString * const kItunesDomain = @"itunes.apple.com";
static NSString * const kAmpersand = @"&";
static NSString * const kEquals = @"=";
static NSString * const kQuestionMark = @"?";
static NSString * const kITunesItemIdentifierKey = @"id";

@interface AffiliateRedirectToITunes () <NSURLSessionDelegate>

@property (nonatomic, strong) NSURL *redirectUrl;

@property (nonatomic, assign) BOOL redirecting;

@end

@implementation AffiliateRedirectToITunes

- (instancetype)initWithUrl:(NSURL *)url {
    if (self = [super init]) {
        _url = url;
        _timeoutIntervalForRequest = 5;
    }
    return self;
}

- (void)startRedirecting {
    if (self.redirecting) {
        return;
    }
    self.redirecting = YES;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = self.timeoutIntervalForRequest;
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue currentQueue]];
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithURL:self.url];
    
    [dataTask resume];
}

- (void)startRedirectingWithBlock:(AffiliateRedirectToITunesBlock)block {
    self.block = block;
    [self startRedirecting];
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    
    // Step 1: Save the most recent response URL as the redirect URL in case multiple redirects occur.
    // Step 2: If the response URL or request URL are valid iTunes URLs, cancel the connection and finish loading. Otherwise, continue to send the request.
    
    if ([[self class] isItunesURL:response.URL]) {
        self.redirectUrl = response.URL;
        [task cancel];
    } else if ([[self class] isItunesURL:request.URL]) {
        self.redirectUrl = request.URL;
        [task cancel];
    } else {
        completionHandler(request);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    
    if (self.redirecting) {
        self.redirecting = NO;
    }
    
    if ([[self class] isItunesURL:self.redirectUrl]) {
        if (self.block) {
            self.block(self.redirectUrl, [[self class] iTunesItemIdentifierForURL:self.redirectUrl], nil);
        }
        return;
    }
    if (error) {
        self.block(nil, nil, error);
    } else {
        NSError *error = [NSError errorWithDomain:kAffiliateRedirectToITunesDomain
                                             code:1
                                         userInfo:@{NSLocalizedDescriptionKey:@"itunes URL not founded"}];
        self.block(nil, nil, error);
    }
}

#pragma mark - ITunes
+ (BOOL)isItunesURL:(NSURL *)url {
    return [url.host hasSuffix:kItunesDomain];
}

+ (NSString *)iTunesItemIdentifierForURL:(NSURL *)URL {
    NSString *itemIdentifier;
    if ([URL.host hasSuffix:kItunesDomain]) {
        NSString *lastPathComponent = [[URL path] lastPathComponent];
        if ([lastPathComponent hasPrefix:kITunesItemIdentifierKey]) {
            itemIdentifier = [lastPathComponent substringFromIndex:2];
        }
        else {
            itemIdentifier = [[self dictionaryFromURL:URL] objectForKey:kITunesItemIdentifierKey];
        }
    }
    
    NSCharacterSet *nonIntegers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if (itemIdentifier && itemIdentifier.length > 0 && [itemIdentifier rangeOfCharacterFromSet:nonIntegers].location == NSNotFound) {
        return itemIdentifier;
    }
    
    return nil;
}

+ (NSDictionary *)dictionaryFromURL:(NSURL *)url {
    NSMutableDictionary *queryDict = [NSMutableDictionary dictionary];
    NSArray *queryElements = [url.query componentsSeparatedByString:kAmpersand];
    for (NSString *element in queryElements) {
        NSArray *keyVal = [element componentsSeparatedByString:kEquals];
        if (keyVal.count >= 2) {
            NSString *key = [keyVal objectAtIndex:0];
            NSString *value = [keyVal objectAtIndex:1];
            if ([[[UIDevice currentDevice] systemVersion] compare:@"9" options:NSNumericSearch] != NSOrderedAscending) {
                [queryDict setObject:[value stringByRemovingPercentEncoding]
                              forKey:key];
            } else {
                [queryDict setObject:[value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                              forKey:key];
            }
        }
    }
    return queryDict;
}

@end
