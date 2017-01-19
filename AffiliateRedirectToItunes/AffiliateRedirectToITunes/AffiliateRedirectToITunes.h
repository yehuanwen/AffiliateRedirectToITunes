//
//  AffiliateRedirectToItunes.h
//  AffiliateRedirectToItunes
//
//  Created by yhw on 17/1/18.
//  Copyright © 2017年 yhw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^AffiliateRedirectToITunesBlock)(NSURL *itunesUrl, NSString *iTunesItemIdentifier, NSError *error);// block

@interface AffiliateRedirectToITunes : NSObject

- (instancetype)initWithUrl:(NSURL *)url;// init with affiliate url

@property (nonatomic, strong) NSURL *url;// affiliate url
@property NSTimeInterval timeoutIntervalForRequest;// request timeout interval
@property (nonatomic, copy) AffiliateRedirectToITunesBlock block;// block
- (void)startRedirecting;// start redirecting...
- (void)startRedirectingWithBlock:(AffiliateRedirectToITunesBlock)block;// start redirecting...with block

@end
