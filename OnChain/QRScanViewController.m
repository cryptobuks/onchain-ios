//
//  QRScanViewController.m
//  OnChain
//
//  Created by Cool on 1/26/15.
//  Copyright (c) 2015 IT. All rights reserved.
//

#import "QRScanViewController.h"
#import "Define_Gloabal.h"

#import <Chain/Chain.h>
#import <CoreBitcoin/CoreBitcoin.h>
#import "ChainSRWebSocket.h"

#import "NetworkingClass.h"
#import "QRCodeParse.h"
@interface QRScanViewController ()
{
    UILabel * lbl_1;
    UILabel * lbl_2;
    UIView * viewQRScan;
    
    NetworkingClass * reqServer;
}
@end

@implementation QRScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton * btnScan = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200 * MULTIPLY_VALUE, 80 * MULTIPLY_VALUE)];
    [btnScan setBackgroundColor:[UIColor colorWithRed:50.0 / 255.0 green:220.0 / 255.0 blue:235.0 / 255.0 alpha:1.0]];
    [btnScan addTarget:self action:@selector(onScan) forControlEvents:UIControlEventTouchUpInside];
    btnScan.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.25);
    [btnScan setTitle:@"SCAN QR CODE" forState:UIControlStateNormal];
    btnScan.layer.cornerRadius = 10 * MULTIPLY_VALUE;
    [self.view addSubview:btnScan];
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.5, SCREEN_WIDTH, SCREEN_HEIGHT * 0.25)];
    view1.backgroundColor = [UIColor colorWithRed:240.0 / 255.0 green:130.0 / 255.0 blue:40.0 / 255.0 alpha:1.0];
    [self.view addSubview:view1];
    
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.75, SCREEN_WIDTH, SCREEN_HEIGHT * 0.25)];
    view2.backgroundColor = [UIColor colorWithRed:50.0 / 255.0 green:140.0 / 255.0 blue:240.0 / 255.0 alpha:1.0];
    [self.view addSubview:view2];
    
    lbl_1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40 * MULTIPLY_VALUE)];
    lbl_1.center = CGPointMake(SCREEN_WIDTH / 2, view1.frame.size.height / 2);
    lbl_1.textColor = [UIColor whiteColor];
    lbl_1.textAlignment = NSTextAlignmentCenter;
    lbl_1.font = [UIFont systemFontOfSize:25 * MULTIPLY_VALUE];
    lbl_1.text = @"0.00 BTC";
    [view1 addSubview:lbl_1];
    
    lbl_2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40 * MULTIPLY_VALUE)];
    lbl_2.center = CGPointMake(SCREEN_WIDTH / 2, view1.frame.size.height / 2);
    lbl_2.textColor = [UIColor whiteColor];
    lbl_2.textAlignment = NSTextAlignmentCenter;
    lbl_2.font = [UIFont systemFontOfSize:16 * MULTIPLY_VALUE];
    lbl_2.text = @"https://onchain.io";
    [view2 addSubview:lbl_2];
    
    
    reqServer = [[NetworkingClass alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation 

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) onScan
{
    viewQRScan =  [BTCQRCode scannerViewWithBlock:^(NSString *message)
    {
        NSLog(@"QR ====> %@", message);
        
        NSString * tmpStr = [message substringWithRange:NSMakeRange(0, 5)];
        [tmpStr lowercaseString];
        
        if ([tmpStr isEqualToString:@"bitid"]) {
            
        }
        else
        {
            
        }
        
        
        [viewQRScan removeFromSuperview];
    }];
    [self.view addSubview:viewQRScan];

}

- (NSString *) getWalletSeed
{
    NSString * walletSeed = [[NSUserDefaults standardUserDefaults] objectForKey:@"wallet-seed"];
    if (!walletSeed || !walletSeed.length) {
        NSMutableData * data = [NSMutableData dataWithLength:32];
        int error = SecRandomCopyBytes(kSecRandomDefault, 32, [data mutableBytes]);
        if (error != noErr) {
//            @throw [NSException exceptionWithName:<#(NSString *)#> reason:<#(NSString *)#> userInfo:nil]
            
        }
        walletSeed = [NSString stringWithUTF8String:[data mutableBytes]];
        
        [[NSUserDefaults standardUserDefaults] setObject:walletSeed forKey:@"wallet-seed"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return walletSeed;
}

@end
