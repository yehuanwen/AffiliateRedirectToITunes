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

@interface DetectITunesLink () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NSMutableArray *links;
@property (nonatomic, strong) NSMutableArray *errorMessages;

@property (nonatomic, assign) CGFloat startTime;// start time
@property (nonatomic, strong) dispatch_source_t timer;// timer

@property (nonatomic, assign) BOOL redirecting;

@end

@implementation DetectITunesLink

- (instancetype)initWithUrl:(NSURL *)url {
    if (self = [super init]) {
        _url = url;
        _timeoutIntervalForRequest = 30;
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
    
    self.startTime = CFAbsoluteTimeGetCurrent();
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    [self startTimer];
}

- (void)startTimer {
    // 取消定时器
    [self stopTimer];
    // 获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 创建一个定时器
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 设置回调
    __weak __typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        [weakSelf stopTimer];
        if (weakSelf.block) {
            if (self.redirecting) {
                self.redirecting = NO;
            }
            NSError *error = [NSError errorWithDomain:kDetectITunesLinkDomain
                                                 code:-1
                                             userInfo:@{NSLocalizedDescriptionKey:@"Time out and itunes URL not founded"}];
            weakSelf.block(nil, self.timeoutIntervalForRequest, self.links, error);
        }
    });
    // 设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeoutIntervalForRequest * NSEC_PER_SEC));
    // 设置时间间隔
    uint64_t interval = (uint64_t)(self.timeoutIntervalForRequest * NSEC_PER_SEC);
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
            self.block(url, CFAbsoluteTimeGetCurrent() - self.startTime, self.links, nil);
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

@end
