# 前言
这是2016年写的一个appplay使用的demo。
#正文
其实appplay支付代码不是很难，很容易理解。只是证书配置的时候要配置一次。
具体流程和推送证书类似，也是在id那里去添加appplay功能，然后去生成cer证书。这个网上很多，就不再累赘了。直接说代码：
支付用的一个库是
```
#import <PassKit/PassKit.h>
```
主要使用的类：
```
PKPaymentAuthorizationViewController
PKPaymentRequest
```
检查手机支不支持appplay：
```

    if([PKPaymentAuthorizationViewController canMakePayments]) {
        [self appPlay];
        
    } else {
        NSLog(@"不支持AppPlay支付");
    }
```
我把支付的一套流程放在了一个方法里面，容易移植:
```
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

```
有几个属性要写：
1，货币的单位
2，所处的国家
3，所绑定得卡型
4，你的支付merchants
5，支持的处理标准
6, 配送信息
对于支付的结果和后台的交互，我们用两个代理可以获得:
```
//代理的回调方法
-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion{
    
    //在这里服务器与银行和商家进行接口调用和支付将结果返回到这里
    //我们根据结果生成对应的状态对象，根据状态对象显示不同的支付结构
    //状态对象
    //在这里了 为了测试方便 设置为支付失败的状态
    //可以选择枚举值PKPaymentAuthorizationStatusSuccess   (支付成功)
    PKPaymentAuthorizationStatus staus = PKPaymentAuthorizationStatusFailure;
    completion(staus);
}


//支付完成的代理方法
-(void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"支付完成");
}
```
运行结果:
![这里写图片描述](http://img.blog.csdn.net/20160330183554148)
