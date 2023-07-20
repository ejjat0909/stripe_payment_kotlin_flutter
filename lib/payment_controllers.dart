import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment_kotlin/payment_request_model.dart';

class PaymentController extends GetxController {
  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(
      {required String amount, required String currency}) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          // applePay: const PaymentSheetApplePay(
          //   merchantCountryCode: 'MYR',
          //   buttonType: PlatformButtonType.pay,

          // ),
          googlePay: const PaymentSheetGooglePay(
              merchantCountryCode: "+60",
              testEnv: false,
              currencyCode: "ISO 4217"),
          merchantDisplayName: 'Prospects',
          customerId: paymentIntentData!['customer'],
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
        ));
        print(paymentIntentData);
        displayPaymentSheet();
      }
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  // Future<void> makePayment(
  //     {required String amount, required String currency}) async {
  //   try {
  //     paymentIntentData = await createPaymentIntent(amount, currency);
  //     if (paymentIntentData != null) {
  //       await Stripe.instance.initPaymentSheet(
  //           paymentSheetParameters: SetupPaymentSheetParameters(
  //         applePay: true,
  //         googlePay: true,
  //         testEnv: true,
  //         merchantCountryCode: 'US',
  //         merchantDisplayName: 'Prospects',
  //         customerId: paymentIntentData!['customer'],
  //         paymentIntentClientSecret: paymentIntentData!['client_secret'],
  //         customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
  //       ));
  //       displayPaymentSheet();
  //     }
  //   } catch (e, s) {
  //     print('exception:$e$s');
  //   }
  // }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print("success payment");
    } on Exception catch (e) {
      if (e is StripeException) {
        print("Error from Stripe: ${e.error.localizedMessage}");
      } else {
        print("Unforeseen error: ${e}");
      }
    } catch (e) {
      print("exception:$e");
    }
  }

  Future<String> getProductPrice() async {
    final String url =
        'https://api.stripe.com/v1/prices?product=prod_OIQPVXxQUB2MLX';
    final Map<String, String> headers = {
      'Authorization':
          'Bearer sk_test_51NVTKRFfsjmBEM78EXDd9Hap18gwvOHKK97FPKTiPaAsTvaL2QAggsoKSbZzzdjcx0ThEkySHSdEsDVnCIMm3MCG00B7iv2zl4',
    };

    final http.Response response =
        await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final int unitAmount = responseData['data'][0]['unit_amount'];
     
      return unitAmount.toStringAsFixed(0);
    } else {
      throw Exception('Failed to retrieve product price.');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': await getProductPrice(),
        'currency': currency,
        'payment_method_types[0]': 'card',
        'metadata[product_id]': 'prod_OIQPVXxQUB2MLX'
      };
      // Map<String, dynamic> body = PaymentRequestModel(
      //   cancelUrl: "https://example.com/cancel",
      //   successUrl: "https://example.com/success",
      //   mode: "payment",
      //   paymentMethodTypes: ['card', 'fpx'],
      //   lineItems: [
      //     LineItems(
      //       quantity: 1,
      //       priceData: PriceData(
      //         unitAmount: 2000,
      //         currency: "myr",
      //         productData: ProductData(
      //           name: "product 1",
      //         ),
      //       ),
      //     )
      //   ],
      // ).toJson();
      var response = await http.post(
          Uri.parse('https://dashboard.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51NVTKRFfsjmBEM78EXDd9Hap18gwvOHKK97FPKTiPaAsTvaL2QAggsoKSbZzzdjcx0ThEkySHSdEsDVnCIMm3MCG00B7iv2zl4',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}
