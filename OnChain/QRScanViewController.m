//
//  QRScanViewController.m
//  OnChain
//
//  Created by Cool on 1/26/15.
//  Copyright (c) 2015 IT. All rights reserved.
//

#import "QRScanViewController.h"
#import "Define_Gloabal.h"
#import <CommonCrypto/CommonCrypto.h>

#import <Chain/Chain.h>
#import <CoreBitcoin/CoreBitcoin.h>
#import "ChainSRWebSocket.h"

#import "NetworkingClass.h"
#import "QRCodeParse.h"

#import "BitIDCommands.h"
#import "BitID.h"

@interface QRScanViewController ()<NetworkingClassDelegate>
{
    UILabel * lblBalance;
    UILabel * lbl_2;
    UIView * viewQRScan;
    
    NetworkingClass * reqServer;
    CC_SHA256_CTX shaCTX;
    
    BTCKey * _dataKey;
    NSString * _data;
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
    
    lblBalance = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40 * MULTIPLY_VALUE)];
    lblBalance.center = CGPointMake(SCREEN_WIDTH / 2, view1.frame.size.height / 2);
    lblBalance.textColor = [UIColor whiteColor];
    lblBalance.textAlignment = NSTextAlignmentCenter;
    lblBalance.font = [UIFont systemFontOfSize:25 * MULTIPLY_VALUE];
    lblBalance.text = @"0.00 BTC";
    [view1 addSubview:lblBalance];
    
    lbl_2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40 * MULTIPLY_VALUE)];
    lbl_2.center = CGPointMake(SCREEN_WIDTH / 2, view1.frame.size.height / 2);
    lbl_2.textColor = [UIColor whiteColor];
    lbl_2.textAlignment = NSTextAlignmentCenter;
    lbl_2.font = [UIFont systemFontOfSize:16 * MULTIPLY_VALUE];
    lbl_2.text = @"https://onchain.io";
    [view2 addSubview:lbl_2];
    
    [self getWalletSeed];
    
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
//            BitIDCommands * idCommand = [[BitIDCommands alloc] init];
            [self excuteBit:message withKey:[self getHDWalletDeterministicKeyWithIndex:0]];
        }
        else
        {
            
        }
//        BTCKey * data = [self getHDWalletDeterministicKeyWithIndex:0];

        [viewQRScan removeFromSuperview];
    }];
    [self.view addSubview:viewQRScan];

}
- (BTCKey *) getHDWalletDeterministicKeyWithIndex:(NSInteger) index
{
    BTCKey * data = [[self getHDWalletDeterministicKey] keyAtIndex:(uint32_t)index];
    return data;
}
- (BTCKeychain *) getHDWalletDeterministicKey
{
//    NSArray * seed = [[self getWalletSeed] componentsSeparatedByString:@" "];
//    BTCMnemonic * mc = [[BTCMnemonic alloc] initWithWords:seed password:@"" wordListType:BTCMnemonicWordListTypeUnknown];
//    return mc.entropy;
    return [self getWalletSeed];
}
- (BTCMnemonic *) getMnemonic
{
    CC_SHA256_Init(&shaCTX);
    NSData * data = BTCRandomDataWithLength(32);
    CC_SHA256_Update(&shaCTX, data.bytes, (CC_LONG)data.length);
    
    unsigned char digest[CC_SHA384_DIGEST_LENGTH];
    CC_SHA256_Final(digest, &shaCTX);
    
    NSMutableData * seed = [NSMutableData dataWithBytes:&digest length:CC_SHA256_DIGEST_LENGTH];
    
    BTCSecureMemset(digest, 0, CC_SHA256_DIGEST_LENGTH);
    BTCSecureMemset(&shaCTX, 0, sizeof(shaCTX));
    
    BTCMnemonic * mnemonic = [[BTCMnemonic alloc] initWithEntropy:BTCDataRange(seed, NSMakeRange(0, 16)) password:nil wordListType:BTCMnemonicWordListTypeEnglish];
    
    
//    BTCKeychain * keyChain = mnemonic.keychain.bitcoinMainnetKeychain;
    
    return mnemonic;
}
- (BTCKeychain *) getWalletSeed
{
    NSString * walletSeed = [[NSUserDefaults standardUserDefaults] objectForKey:@"wallet-seed"];
    if (!walletSeed || !walletSeed.length) {
        NSMutableData * data = [NSMutableData dataWithLength:32];
        
        uint8_t aa[32];
        
        int error = SecRandomCopyBytes(kSecRandomDefault, 32, aa);
        if (error != noErr) {
            
        }
        data = [NSMutableData dataWithBytes:aa length:32];
        
        walletSeed = [NSString stringWithUTF8String:data.mutableBytes];
        NSLog(@"%@", walletSeed);

        
        
        [[NSUserDefaults standardUserDefaults] setObject:walletSeed forKey:@"wallet-seed"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
//    return walletSeed; 
    BTCKeychain * keyChain = [self getMnemonic].keychain;
    
    return keyChain;
}
- (void) excuteBit:(NSString *) data withKey:(BTCKey *) dataKey
{
    if (![BitID checkBitIDValidatyWithQR:[NSURL URLWithString:data]]) {
        return;
    }
    _data = data;
    _dataKey = dataKey;
    
    NSURL * callback = [BitID buildCallbackUrlFromBitUrl:[NSURL URLWithString:data]];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@ is requesting that you identify yourself.\nDo you want to proceed?", callback] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
    
     
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        NSURL * callback = [BitID buildCallbackUrlFromBitUrl:[NSURL URLWithString:_data]];
        NSData * dataMessage = [_dataKey signatureForMessage:@"message"];
        
        NSString * strSigned = [[NSString alloc] initWithData:dataMessage encoding:NSASCIIStringEncoding];
        NSString * address = _dataKey.privateKeyAddress.string;
        
        NetworkingClass * serverReq = [[NetworkingClass alloc] init];
        serverReq.delegate = self;
        [serverReq doBitIDWithSigned:strSigned withPostBack:[callback absoluteString]  withAddress:address withData:_data];
    }
}
@end
