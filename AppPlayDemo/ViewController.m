//
//  ViewController.m
//  AppPlayDemo
//
//  Created by 孙云 on 16/3/30.
//  Copyright © 2016年 haidai. All rights reserved.
//
/**
 *  失败案例
 *
 *  @param IBAction <#IBAction description#>
 *
 *  @return <#return value description#>
 */
#import "ViewController.h"
#import <PassKit/PassKit.h>
#import <Contacts/Contacts.h>
@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate>
- (IBAction)clickBtn:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  付款点击
 *
 *  @param sender <#sender description#>
 */
- (IBAction)clickBtn:(id)sender {

    if([PKPaymentAuthorizationViewController canMakePayments]) {
        
        NSLog(@"Woo! Can make payments!");
        
        PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
        
        PKPaymentSummaryItem *widget1 = [PKPaymentSummaryItem summaryItemWithLabel:@"Widget 1"
                                                                            amount:[NSDecimalNumber decimalNumberWithString:@"0.99"]];
        
        PKPaymentSummaryItem *widget2 = [PKPaymentSummaryItem summaryItemWithLabel:@"Widget 2"
                                                                            amount:[NSDecimalNumber decimalNumberWithString:@"1.00"]];
        
        PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"Grand Total"
                                                                          amount:[NSDecimalNumber decimalNumberWithString:@"1.99"]];
        
        request.paymentSummaryItems = @[widget1, widget2, total];
        request.countryCode = @"CN";
        request.currencyCode = @"CNY";
        request.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
        request.merchantIdentifier = @"merchant.com.testAppPlay";
        request.merchantCapabilities = PKMerchantCapabilityEMV;
        
        PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        paymentPane.delegate = self;
        [self presentViewController:paymentPane animated:TRUE completion:nil];
        
    } else {
        NSLog(@"This device cannot make payments");
    }

}
/**
 *  支付流程
 */
- (void)appPlay{

    //创建支付类
     PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
    //支付的商品
    PKPaymentSummaryItem *good1 = [PKPaymentSummaryItem summaryItemWithLabel:@"HHKB professional 2" amount:[NSDecimalNumber decimalNumberWithString:@"1388"]];  PKPaymentSummaryItem *good2 = [PKPaymentSummaryItem summaryItemWithLabel:@"营养快线" amount:[NSDecimalNumber decimalNumberWithString:@"4"]];  PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"德玛西亚" amount:[NSDecimalNumber decimalNumberWithString:@"1392"]];
    
    request.paymentSummaryItems = @[ good1, good2, total ];
    //货币的单位
    request.currencyCode = @"CNY";
    //所绑定的卡的类型
    request.supportedNetworks = @[ PKPaymentNetworkMasterCard, PKPaymentNetworkVisa, PKPaymentNetworkChinaUnionPay ];
    //merchant ID
    request.merchantIdentifier = @"merchant.com.testAppPlay";
    //支付处理标准
    request.merchantCapabilities = PKMerchantCapabilityEMV;
    //配送信息
    request.requiredShippingAddressFields = PKAddressFieldPostalAddress | PKAddressFieldPhone | PKAddressFieldEmail | PKAddressFieldName;
    //创建用来显示支付信息的控制器
    PKPaymentAuthorizationViewController *paymentPane     = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    paymentPane.delegate = self;
    [self presentViewController:paymentPane animated:YES completion:nil];
   
}


- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    NSLog(@"Payment was authorized: %@", payment);

    BOOL asyncSuccessful = FALSE;
    

    
    if(asyncSuccessful) {
        completion(PKPaymentAuthorizationStatusSuccess);
        
        // do something to let the user know the status
        
        NSLog(@"Payment was successful");
        
        //        [Crittercism endTransaction:@"checkout"];
        
    } else {
        completion(PKPaymentAuthorizationStatusFailure);
        
        // do something to let the user know the status
        
        NSLog(@"Payment was unsuccessful");
        
        //        [Crittercism failTransaction:@"checkout"];
    }
    
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    NSLog(@"Finishing payment view controller");
    
    // hide the payment window
    [controller dismissViewControllerAnimated:TRUE completion:nil];
}
@end
