//
//  DetectITunesLink.h
//  AffiliateRedirectToITunes
//
//  Created by yhw on 17/3/21.
//  Copyright © 2017年 yhw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^DetectITunesLinkBlock)(NSURL *iTunesUrl, CGFloat detectDuration, NSArray *links, NSString *iTunesItemIdentifier, NSError *error);// block

@interface DetectITunesLink : NSObject

- (instancetype)initWithUrl:(NSURL *)url;// init with affiliate url

@property (nonatomic, assign) BOOL logEnabled;// enable log

@property (nonatomic, strong) NSURL *url;// affiliate url
@property NSTimeInterval timeoutIntervalForEachRedirect;// each redirect timeout interval, default is 5s

- (void)startDetecting;// start detecting iTunes url
@property (nonatomic, copy) DetectITunesLinkBlock block;// block
- (void)startRedirectingWithBlock:(DetectITunesLinkBlock)block;// start redirecting...with block
- (void)stopDetecting;// stop detecting iTunes url

@end
