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
#import "MultiUtils.h"
#import "ChainCommands.h"

@interface QRScanViewController ()<NetworkingClassDelegate, ChainCommandsDelegate>
{
    UILabel * lblBalance;
    UILabel * lbl_2;
    UIView * viewQRScan;
    
    NetworkingClass * serverReq;
    ChainCommands * commandChain;
    CC_SHA256_CTX shaCTX;
    
    BTCKey * _dataKey;
    NSString * _data;
    
    NSString * qrMessage;
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
    
//    [self getWalletSeed];
    
    serverReq = [[NetworkingClass alloc] init];
    serverReq.delegate = self;

    commandChain = [[ChainCommands alloc] init];
    commandChain.delegate = self;
    

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
//            [self excuteBit:@"bitid://carbonwallet.com/callback?x=9dad35460705fc68" withKey:[self getHDWalletDeterministicKeyWithIndex:0]];
//    return;
    
    
    
    viewQRScan =  [BTCQRCode scannerViewWithBlock:^(NSString *message)
    {
        NSLog(@"QR ====> %@", message);
        
        [self processQR:message];
//        BTCKey * data = [self getHDWalletDeterministicKeyWithIndex:0];

        [viewQRScan removeFromSuperview];
    }];
    [self.view addSubview:viewQRScan];

}
- (void) processQR:(NSString *) data
{
    if ([data rangeOfString:@"bitid"].length == 5 && ![data rangeOfString:@"bitid"].location) {
        [self excuteBit:data withKey:[self getHDWalletDeterministicKeyWithIndex:0]];
    }
    else
    {
        NSArray * array = [data componentsSeparatedByString:@"\\|"];
        if (array.count < 3) {
            // BIP 39 seed
            array = [data componentsSeparatedByString:@" "];
            if (array.count == 24) {
                [self processNewWalletSeed:data];
            } else if ([data rangeOfString:@"5"].length == 1 && ![data rangeOfString:@"5"].location)
            {
                [self seedWalletWithWalletImportFormatPrivateKey:data];
                
            }
            return;
        }
        NSString * cmd = array[0];
        NSString * service = array[1];
        NSString * postBack = array[2];
        
        NSInteger crc = [MultiUtils crc16:service];
        
        if ([cmd isEqualToString:@"mpk"]) {
            [commandChain processMPKRequestWithParams:array withPostBack:postBack withKey:[self getHDWalletDeterministicKeyWithIndex:crc]];
        } else if ([cmd isEqualToString:@"sign"]){
            [commandChain processSignRequestWithParams:array withPostBack:postBack withKey:[self getHDWalletDeterministicKeyWithIndex:crc]];
        } else if ([cmd isEqualToString:@"pubkey"]){
            [commandChain processPubKeyRequestWithParams:array withPostBack:postBack withKey:[self getHDWalletDeterministicKeyWithIndex:crc]];
        }
        
    }

}
- (void) processNewWalletSeed:(NSString *) data
{
    qrMessage = data;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Do you want to change your BIP39 seed?" message:data delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 1;
    [alert show];
 
}
- (void) seedWalletWithWalletImportFormatPrivateKey:(NSString *) data
{
    qrMessage = data;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Do you want to change generate a new wallet from this private key?" message:data delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 2;
    [alert show];

}
- (BTCKey *) getHDWalletDeterministicKeyWithIndex:(NSInteger) index
{
    BTCKey * data = [[self getHDWalletDeterministicKey] keyAtIndex:(uint32_t)index];
    return data;
}
- (BTCKeychain *) getHDWalletDeterministicKey
{
    NSMutableArray * seed = [NSMutableArray arrayWithArray:[[self getWalletSeed] componentsSeparatedByString:@" "]];
    for (NSString * theStr in seed) {
        if (!theStr.length) {
            [seed removeObject:theStr];
        }
    }
    BTCMnemonic * mc = [[BTCMnemonic alloc] initWithWords:seed password:@"" wordListType:BTCMnemonicWordListTypeEnglish];
    BTCKeychain * keyChain = [[BTCKeychain alloc] initWithSeed:mc.entropy];
    
    return keyChain;
//    return [self getWalletSeed];
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
- (void) setWalletSeedWithSeed:(NSString *) seed
{
    [[NSUserDefaults standardUserDefaults] setObject:seed forKey:@"wallet-seed"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
- (NSString *) getWalletSeed
{
    NSString * walletSeed = [[NSUserDefaults standardUserDefaults] objectForKey:@"wallet-seed"];
    if (!walletSeed || !walletSeed.length) {
        NSMutableData * data = [NSMutableData dataWithLength:32];
        
        uint8_t rndData[32];
        
        int error = SecRandomCopyBytes(kSecRandomDefault, 32, rndData);
        if (error != noErr) {
            
        }
        data = [NSMutableData dataWithBytes:rndData length:32];
//        BTCMnemonic * mne = [[BTCMnemonic alloc] initWithData:data];
        BTCMnemonic * mne = [self getMnemonic];
        NSArray * tmpArr = [mne words];
        NSMutableString * seed = [[NSMutableString alloc] init];
        for (NSString * theStr in tmpArr) {
            [seed appendFormat:@"%@ ", theStr];
            
        }
        
        walletSeed = seed;
        NSLog(@"%@", walletSeed);

        
        
        [[NSUserDefaults standardUserDefaults] setObject:walletSeed forKey:@"wallet-seed"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return walletSeed;
//    BTCKeychain * keyChain = [self getMnemonic].keychain;
//    
//    return keyChain;
}
- (void) excuteBit:(NSString *) data withKey:(BTCKey *) dataKey
{
    if (![BitID checkBitIDValidatyWithQR:[NSURL URLWithString:data]]) {
        return;
    }
    _data = data;
    _dataKey = dataKey;
    
    NSURL * callback = [BitID buildCallbackUrlFromBitUrl:[NSURL URLWithString:data]];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"BIP ID Sign in request." message:[NSString stringWithFormat:@"%@ is requesting that you identify yourself.\nDo you want to proceed?", callback] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 0;
    [alert show];
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 0:
            if (buttonIndex) {
                NSURL * callback = [BitID buildCallbackUrlFromBitUrl:[NSURL URLWithString:_data]];
                NSData * dataMessage = [_dataKey signatureForMessage:_data];
                
                NSString * strSigned = [dataMessage base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                
                NSString * address = [_dataKey.address base58String];
                
                [serverReq doBitIDWithSigned:strSigned withPostBack:[callback absoluteString]  withAddress:address withData:_data];
            } 
            break;
        case 1:
            if (buttonIndex) {
                [self setWalletSeedWithSeed:qrMessage];
            }
            break;
            
        case 2:
            if (buttonIndex) {
                
            }
            break;
            
        case 3:
            
            break;
            
            
        default:
            break;
    }
}
@end
