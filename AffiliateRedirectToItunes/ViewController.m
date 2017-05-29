//
//  ViewController.m
//  AffiliateRedirectToItunes
//
//  Created by yhw on 17/1/18.
//  Copyright © 2017年 yhw. All rights reserved.
//

#import "ViewController.h"
#import "AffiliateRedirectToItunes.h"
#import <StoreKit/StoreKit.h>
#import "DetectITunesLink.h"
#import <objc/runtime.h>

@interface ViewController () <SKStoreProductViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DetectITunesLink *detectITunesLink;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Affiliate Redirect To Itunes";
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Open outside by openURL:";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Open inside by SKStoreProductViewController";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Detect iTunes link using UIWebView";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"Detect iTunes link open in SKStoreProductViewController";
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
//        AffiliateRedirectToITunes *affiliateRedirectToITunes = [[AffiliateRedirectToITunes alloc] initWithUrl:[NSURL URLWithString:@"http://tknet.rayjump.com/agentapi/click?cid=113228596&aid=29646&tid=2042&uid=10188&idfa=F79CC41E-4706-43CE-B4EA-C615AC50C2B5&postback=aHR0cDovL3Rlc3QuYXBpLnVzZGNhdC5jb20vaW5zdGFsbC9hZG4%2FaV90aWQ9MjA0MiZpX3VpZD0xMDE4OCZpX2NpZD01ODdmMDVkZjE3ODYzYTc2NGI4YjRmYjQ%3D"]];
        
        AffiliateRedirectToITunes *affiliateRedirectToITunes = [[AffiliateRedirectToITunes alloc] initWithUrl:[NSURL URLWithString:@"https://asmclk.com/click.php?aff=35202&camp=1173029&prod=9&sub1=VR4-nLJ8OHjzVathhkYn6M1XayPFQ7NvOtGLQ.FqxZO.xGw-D&sub2=fnc4UTT-lUNoJmaxTkpywUkJt.wZqkf1TTlAa3Z.Llnb9TQ__&subsrc=909805414617452544_eyJpX3RpZCI6IjMyODQiLCJpX3VpZCI6IjEwMjM1IiwiaV9jaWQiOiI1OGQwOTk2NzE3ODYzYTUwMTA4YjRhYjIifQ=="]];
        
//        AffiliateRedirectToITunes *affiliateRedirectToITunes = [[AffiliateRedirectToITunes alloc] initWithUrl:[NSURL URLWithString:@"http://tknet.rayjump.com/agentapi/click?cid=114553989&aid=29646"]];
        
        [affiliateRedirectToITunes startRedirectingWithBlock:^(NSURL *itunesUrl, NSString *iTunesItemIdentifier, NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (error) {
                
                if ([[UIApplication sharedApplication] canOpenURL:affiliateRedirectToITunes.url]) {
                    [[UIApplication sharedApplication] openURL:affiliateRedirectToITunes.url];
                }
                
                NSLog(@"error = %@", error);
                return;
            }
            NSLog(@"itunesUrl = %@", itunesUrl);
            
            // 1. open outside app
            if ([[UIApplication sharedApplication] canOpenURL:itunesUrl]) {
                [[UIApplication sharedApplication] openURL:itunesUrl];
            }

        }];
    } else if (indexPath.row == 1) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        AffiliateRedirectToITunes *affiliateRedirectToITunes = [[AffiliateRedirectToITunes alloc] initWithUrl:[NSURL URLWithString:@"http://tknet.rayjump.com/agentapi/click?cid=130540871&aid=29646"]];
        
//        AffiliateRedirectToITunes *affiliateRedirectToITunes = [[AffiliateRedirectToITunes alloc] initWithUrl:[NSURL URLWithString:@"http://tknet.rayjump.com/agentapi/click?cid=112346694&aid=29646&tid=2050&uid=10188&idfa=F79CC41E-4706-43CE-B4EA-C615AC50C2B5&postback=aHR0cDovL3Rlc3QuYXBpLnVzZGNhdC5jb20vaW5zdGFsbC9hZG4%2FaV90aWQ9MjA1MCZpX3VpZD0xMDE4OCZpX2NpZD01ODdmMzRiODE3ODYzYTExMDI4YjQ2ZDM%3D"]];
        
        //    AffiliateRedirectToITunes *affiliateRedirectToITunes = [[AffiliateRedirectToITunes alloc] initWithUrl:[NSURL URLWithString:@"http://tknet.rayjump.com/agentapi/click?cid=114553989&aid=29646"]];
        
        [affiliateRedirectToITunes startRedirectingWithBlock:^(NSURL *itunesUrl, NSString *iTunesItemIdentifier, NSError *error) {
            if (error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                NSLog(@"error = %@", error);
                return;
            }
            NSLog(@"itunesUrl = %@", itunesUrl);
            
            // 2. open inside app
            SKStoreProductViewController *controller = [[SKStoreProductViewController alloc] init];
            controller.delegate = self;
            NSDictionary *parameters = @{SKStoreProductParameterITunesItemIdentifier:iTunesItemIdentifier};
            // 1
//            [self presentViewController:controller animated:YES completion:^{
//                [controller loadProductWithParameters:parameters completionBlock:^(BOOL result, NSError *error) {
//                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//                    if (result) {
//                        NSLog(@"AffiliateLinkify: Internal app store presented successfully.");
//                    }
//                    else {
//                        NSLog(@"AffiliateLinkify: App store failed to load url. %@", error.localizedDescription);
//                    }
//                }];
//            }];
            // 2
            [controller loadProductWithParameters:parameters completionBlock:^(BOOL result, NSError *error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                if (result) {
                    [self presentViewController:controller animated:YES completion:^{
                        NSLog(@"AffiliateLinkify: Internal app store presented successfully.");
                    }];
                }
                else {
                    NSLog(@"AffiliateLinkify: App store failed to load url. %@", error.localizedDescription);
                }
            }];
        }];
    } else if (indexPath.row == 2) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
//        NSURL *url = [NSURL URLWithString:@"https://asmclk.com/click.php?aff=35202&camp=1173029&prod=9&sub1=VR4-nLJ8OHjzVathhkYn6M1XayPFQ7NvOtGLQ.FqxZO.xGw-D&sub2=fnc4UTT-lUNoJmaxTkpywUkJt.wZqkf1TTlAa3Z.Llnb9TQ__&subsrc=909805414617452544_eyJpX3RpZCI6IjMyODQiLCJpX3VpZCI6IjEwMjM1IiwiaV9jaWQiOiI1OGQwOTk2NzE3ODYzYTUwMTA4YjRhYjIifQ=="];
//        NSURL *url = [NSURL URLWithString:@"http://test.api.usdcat.com/click?tid=3273&uid=10235&idfa=22F0C81D-463A-420E-A421-863B724B127E"];
        NSURL *url = [NSURL URLWithString:@"http://net.rayjump.com/agentapi/impression?cid=146062503&aid=29646&pid=9318&sign=96e16f92a27b5f806f176bfdba603ac7"];
        
        self.detectITunesLink = [[DetectITunesLink alloc] initWithUrl:url];
        self.detectITunesLink.logEnabled = YES;
        [self.detectITunesLink startRedirectingWithBlock:^(NSURL *iTunesUrl, CGFloat detectDuration, NSArray *links, NSString *iTunesItemIdentifier, NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (error) {
                NSLog(@"detect error = %@", error);
                return;
            }
            NSLog(@"detect iTunes url is %@, detect time is %@, iTunes item identifier is %@", iTunesUrl, @(detectDuration), iTunesItemIdentifier);
            NSLog(@"redirect links are %@", links);
        }];
    } else if (indexPath.row == 3) {
        mns_swizzleMethod(objc_getClass("SKStoreProductViewController"), @selector(loadProductWithParameters:completionBlock:), @selector(mns_loadProductWithParameters:completionBlock:));
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        NSURL *url = [NSURL URLWithString:@"https://t.api.yyapi.net/v1/tracking?ad=946163349291277715&app_id=add44af6878dbe0f&pid=5&user_id={user_id}"];
        
        self.detectITunesLink = [[DetectITunesLink alloc] initWithUrl:url];
        self.detectITunesLink.logEnabled = YES;
        [self.detectITunesLink startRedirectingWithBlock:^(NSURL *iTunesUrl, CGFloat detectDuration, NSArray *links, NSString *iTunesItemIdentifier, NSError *error) {
            if (error) {
                NSLog(@"detect error = %@", error);
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                return;
            }
            NSLog(@"detect iTunes url is %@, detect time is %@, iTunes item identifier is %@", iTunesUrl, @(detectDuration), iTunesItemIdentifier);
            NSLog(@"redirect links are %@", links);
            
            // 2. open inside app
            SKStoreProductViewController *controller = [[SKStoreProductViewController alloc] init];
            controller.delegate = self;
            NSDictionary *parameters = @{SKStoreProductParameterITunesItemIdentifier:iTunesItemIdentifier};
            // 2
            [controller loadProductWithParameters:parameters completionBlock:^(BOOL result, NSError *error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                if (result) {
                    [self presentViewController:controller animated:YES completion:^{
                        NSLog(@"AffiliateLinkify: Internal app store presented successfully.");
                    }];
                }
                else {
                    NSLog(@"AffiliateLinkify: App store failed to load url. %@", error.localizedDescription);
                }
            }];
        }];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)mns_loadProductWithParameters:(NSDictionary<NSString *, id> *)parameters completionBlock:(nullable void(^)(BOOL result, NSError * __nullable error))block {
    NSLog(@"xxx");
}

void mns_swizzleMethod(Class clazz, SEL oriSel, SEL swizzledSel) {
    Method oriMethod = class_getInstanceMethod(clazz, oriSel);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSel);
    BOOL didAddMethod = class_addMethod(clazz, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(clazz, swizzledSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swizzledMethod);
    }
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
