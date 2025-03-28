import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jewellery_ordering_app/models/cart_item.dart';
import 'package:jewellery_ordering_app/models/sold_data_item.dart';
import 'package:jewellery_ordering_app/providers/cart_provider.dart';
import 'package:jewellery_ordering_app/providers/sold_data_provider.dart';
import 'package:jewellery_ordering_app/screens/bottom_nav_screen.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../screens/cart_page.dart';

class PaymentService {
  late Razorpay _razorpay;
  BuildContext context;
  User? _user;
  PaymentService({required this.context}) {
    _user = FirebaseAuth.instance.currentUser;
    _razorpay = Razorpay();
    //     event listeners
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handlePaymentExternalWallet);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  }

  void _handlePaymentExternalWallet(ExternalWalletResponse response) {
    print("wallet name : ${response.walletName}");
    _showPaymentStatusDialogBox(
        "External Wallet", "You selected ${response.walletName}.", false);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(
        "payment failed : ${response.message},and error message is : ${response.error}");
    _showPaymentStatusDialogBox(
        "Payment Failed", "Your payment is failed!", false);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("payment success : ${response.data}");
    _showPaymentStatusDialogBox(
        "Payment Success", "Your payment successful!", true);

    List<CartItem> listOfCartItems =
        Provider.of<CartProvider>(context, listen: false).getCartItems();
    //   adding the cart items into the sold data
    for (int i = 0; i < listOfCartItems.length; i++) {
      CartItem element = listOfCartItems[i];
      Provider.of<SoldDataProvider>(context, listen: false).addSoldDataItem(
          SoldDataItem(element.id, element.title, element.quantity));
    }

    //   clearing the cart items
    Provider.of<CartProvider>(context, listen: false).clear();
  }

  void _showPaymentStatusDialogBox(
      String title, String message, bool isSuccess) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
            child: Container(
              width: 1.sw,
              height: 220.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Icon(
                          isSuccess ? Icons.check_circle : Icons.error,
                          size: 40.r,
                          color: isSuccess ? Colors.green : Colors.red,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(right: 8.r, top: 8.r, bottom: 8.r),
                        child: Text(
                          "$title",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.sp),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "$message",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Icon(
                    isSuccess
                        ? Icons.check_circle_outline_sharp
                        : Icons.close_rounded,
                    size: 60.r,
                    color: isSuccess ? Colors.green : Colors.red,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (isSuccess) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNavScreen()),
                          (route) => false,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "Okey",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.r)),
                        backgroundColor: Colors.blue),
                  )
                ],
              ),
            ),
            insetPadding: EdgeInsets.symmetric(horizontal: 10.r),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r)));
      },
    );
  }

  void openCheckOut(int amount, int numOfProduct) {
    var options = {
      'key': 'rzp_test_DGMdBeD8rMlmLA', // Razorpay Test API Key
      'amount': amount * 100, // Amount in paise (₹1000)
      'currency': 'INR',
      'name': 'Jewellery Ordering App', // Enter business name here
      'description': 'Order Payment for Jewellery',
      'prefill': {
        'contact': _user?.phoneNumber, // Customer's phone number
        'email': _user?.email, // Customer's email
      },
      'notes': {
        'customer_name': _user?.displayName, // Store the customer's name
        'number_of_product': numOfProduct,
      },
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error is : ${e.toString()}");
    }
  }
}
