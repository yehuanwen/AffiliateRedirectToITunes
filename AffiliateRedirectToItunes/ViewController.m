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

@interface ViewController () <SKStoreProductViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

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
        
        AffiliateRedirectToITunes *affiliateRedirectToITunes = [[AffiliateRedirectToITunes alloc] initWithUrl:[NSURL URLWithString:@"http://tknet.rayjump.com/agentapi/click?cid=113228596&aid=29646&tid=2042&uid=10188&idfa=F79CC41E-4706-43CE-B4EA-C615AC50C2B5&postback=aHR0cDovL3Rlc3QuYXBpLnVzZGNhdC5jb20vaW5zdGFsbC9hZG4%2FaV90aWQ9MjA0MiZpX3VpZD0xMDE4OCZpX2NpZD01ODdmMDVkZjE3ODYzYTc2NGI4YjRmYjQ%3D"]];
        
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
        NSURL *url = [NSURL URLWithString:@"https://ad.api.yyapi.net/v1/tracking?ad=923016484135899136&app_id=add44af6878dbe0f&pid=5&user_id=10235&chn=eyJpX3RpZCI6IjMzNjIiLCJpX3VpZCI6IjEwMjM1IiwiaV9jaWQiOiI1OGQzNzkxZTE3ODYzYTExNmU4YjRjZTQifQ%3D%3D"];
        
        DetectITunesLink *detectITunesLink = [[DetectITunesLink alloc] initWithUrl:url];
        detectITunesLink.logEnabled = YES;
        [detectITunesLink startRedirectingWithBlock:^(NSURL *iTunesUrl, CGFloat detectTime, NSArray *links, NSError *error) {
            if (error) {
                NSLog(@"detect error = %@", error);
                return;
            }
            NSLog(@"detect iTunes url is %@, detect time is %@", iTunesUrl, @(detectTime));
            NSLog(@"redirect links are %@", links);
        }];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
