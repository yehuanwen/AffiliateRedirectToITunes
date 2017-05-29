//
//  DetectITunesLink.m
//  AffiliateRedirectToITunes
//
//  Created by yhw on 17/3/21.
//  Copyright © 2017年 yhw. All rights reserved.
//

#import "DetectITunesLink.h"
#import <WebKit/WebKit.h>

static NSString * const kDetectITunesLinkDomain = @"DetectITunesLink";

static NSString * const kItunesDomain = @"itunes.apple.com";
static NSString * const kAmpersand = @"&";
static NSString * const kEquals = @"=";
static NSString * const kQuestionMark = @"?";
static NSString * const kITunesItemIdentifierKey = @"id";

@interface DetectITunesLink () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;// web view to load request

@property (nonatomic, strong) NSMutableArray *links;// redirect urls
@property (nonatomic, strong) NSMutableArray *errorMessages;// error messages

@property (nonatomic, assign) CGFloat startTime;// start time
@property (nonatomic, strong) dispatch_source_t timer;// timer

@property (nonatomic, assign) BOOL redirecting;// is redirecting or not

@end

@implementation DetectITunesLink

- (void)dealloc {
    NSLog(@"dealloc");
}

- (instancetype)init {
    return [self initWithUrl:nil];
}

- (instancetype)initWithUrl:(NSURL *)url {
    if (self = [super init]) {
        _url = url;
        _timeoutIntervalForEachRedirect = 5;
    }
    return self;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = ({
            UIWebView *view = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            view.delegate = self;
            view;
        });
    }
    return _webView;
}

- (NSMutableArray *)links {
    if (!_links) {
        _links = [[NSMutableArray alloc] init];
    }
    return _links;
}

- (NSMutableArray *)errorMessages {
    if (!_errorMessages) {
        _errorMessages = [[NSMutableArray alloc] init];
    }
    return _errorMessages;
}

- (void)stopDetecting {
    if (self.redirecting) {
        self.redirecting = NO;
    }
    self.block = nil;
    [self stopTimer];
    [self.webView stopLoading];
}

- (void)startRedirectingWithBlock:(DetectITunesLinkBlock)block {
    self.block = block;
    [self startDetecting];
}

- (void)startDetecting {
    if (self.redirecting) {
        return;
    }
    self.redirecting = YES;
    [self.links removeAllObjects];
    [self.errorMessages removeAllObjects];
    
    [self stopTimer];
    [self startTimer];
    
    self.startTime = CFAbsoluteTimeGetCurrent();
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    
}

- (void)startTimer {
    // 获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 创建一个定时器
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 设置回调
    __weak __typeof__(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        __strong __typeof__(self) strongSelf = weakSelf;
        [strongSelf stopTimer];
        [strongSelf.webView stopLoading];
        if (strongSelf.block) {
            if (strongSelf.redirecting) {
                strongSelf.redirecting = NO;
            }
            NSError *error = [NSError errorWithDomain:kDetectITunesLinkDomain
                                                 code:-1
                                             userInfo:@{NSLocalizedDescriptionKey:@"Time out and itunes URL not founded"}];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.block(nil, strongSelf.timeoutIntervalForEachRedirect, strongSelf.links, nil, error);
            });
        }
    });
    // 设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeoutIntervalForEachRedirect * NSEC_PER_SEC));
    // 设置时间间隔
    uint64_t interval = (uint64_t)(self.timeoutIntervalForEachRedirect * NSEC_PER_SEC);
    // 设置定时器
    dispatch_source_set_timer(self.timer, start, interval, 0);
    // 启动定时器
    dispatch_resume(self.timer);
}

- (void)stopTimer {
    // 取消定时器
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // restart timer
    [self stopTimer];
    [self startTimer];
    //
    NSURL *url = request.URL;
    if (url.absoluteString.length > 0) {
        [self.links addObject:url.absoluteString];
        if (self.logEnabled) {
            NSLog(@"%@, %@", @(self.links.count), url.absoluteString);
        }
    }
    
    if ([[self class] isItunesURL:url]) {
        if (self.redirecting) {
            self.redirecting = NO;
        }
        [self stopTimer];
        [self.webView stopLoading];
        if (self.block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.block(url, CFAbsoluteTimeGetCurrent() - self.startTime, self.links, [[self class] iTunesItemIdentifierForURL:url], nil);
            });
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (error.localizedDescription.length > 0) {
        [self.errorMessages addObject:error.localizedDescription];
        if (self.logEnabled) {
            NSLog(@"%@, error message = %@", @(self.errorMessages.count), error.localizedDescription);
        }
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
            // Fix detect url condition is http://xxx/idxxx&xxx=xxx , not http://xxx/idxxx?xxx=xxx
            // ? is replaced by &, so last path component is not right
            NSArray *components = [itemIdentifier componentsSeparatedByString:kAmpersand];
            if (components.count > 0) {
                itemIdentifier = components.firstObject;
            }
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
