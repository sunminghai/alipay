//
//  ViewController.m
//  AlipayDemo
//
//  Created by 孙明海 on 16/2/29.
//  Copyright © 2016年 孙明海. All rights reserved.
//

#import "ViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "APAuthV2Info.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 是东方闪电
    //水电费
    //孙明海大神开始代码了
    // 上的
    // 得得得
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    /*=======================需要填写商户app申请的===================================*/

    NSString *partner = @"";
    NSString *seller = @"";
    NSString *privateKey = @"";
    
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = @"订单ID"; //订单ID(由商家□自□行制定)
    order.productName = @"商品标题"; //商品标题
    order.productDescription = @"商品标题"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",6.66]; //商 品价格
    
    order.notifyURL = @"http://www.sunminghai.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"com.sunminghai.ios";
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description]; NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
//        [tableView deselectRowAtIndexPath:indexPath animated:YES]; }
    }
}
@end
