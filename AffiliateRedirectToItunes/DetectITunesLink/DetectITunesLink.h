//
//  DetectITunesLink.h
//  AffiliateRedirectToITunes
//
//  Created by yhw on 17/3/21.
//  Copyright © 2017年 yhw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^DetectITunesLinkBlock)(NSURL *iTunesUrl, CGFloat detectTime, NSArray *links, NSError *error);// block

@interface DetectITunesLink : NSObject

- (instancetype)initWithUrl:(NSURL *)url;// init with affiliate url

@property (nonatomic, assign) CGFloat logEnabled;

@property (nonatomic, strong) NSURL *url;// affiliate url
@property NSTimeInterval timeoutIntervalForRequest;// request timeout interval, default is 30s

- (void)startDetecting;
@property (nonatomic, copy) DetectITunesLinkBlock block;// block
- (void)startRedirectingWithBlock:(DetectITunesLinkBlock)block;// start redirecting...with block

@end
