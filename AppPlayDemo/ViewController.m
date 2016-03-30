//
//  ViewController.m
//  AppPlayDemo
//
//  Created by 孙云 on 16/3/30.
//  Copyright © 2016年 haidai. All rights reserved.
//
/**
 *  失败案例,又修改成功
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
        [self appPlay];
        
    } else {
        NSLog(@"不支持AppPlay支付");
    }

}
/**
 *  支付流程
 */
- (void)appPlay{

    //创建支付类
     PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
    //支付的商品
    PKPaymentSummaryItem *good1 = [PKPaymentSummaryItem summaryItemWithLabel:@"你要来一发吗" amount:[NSDecimalNumber decimalNumberWithString:@"10000.00"]];
    
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"并不约" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
    
    request.paymentSummaryItems = @[ good1, total ];
    //货币的单位
    request.countryCode = @"CN";
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
    //支付需要后端的支持

}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    NSLog(@"支付成功");
    
    [controller dismissViewControllerAnimated:TRUE completion:nil];
}
@end
