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

- (instancetype)initWithUrl:(NSURL *)url;// Designated init method

@property (nonatomic, strong, readonly) NSURL *url;// affiliate url
@property NSTimeInterval timeoutIntervalForRequest;// request timeout interval

- (void)startRedirecting;// start redirecting...
- (void)startRedirectingWithBlock:(AffiliateRedirectToITunesBlock)block;// start redirecting...with block

@end
