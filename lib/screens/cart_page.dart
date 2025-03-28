import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jewellery_ordering_app/models/cart_item.dart';
import 'package:jewellery_ordering_app/providers/cart_provider.dart';
import 'package:jewellery_ordering_app/screens/jewellery_items_details_page.dart';
import 'package:jewellery_ordering_app/services/payment_service.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});
  PaymentService? paymentService;
  @override
  Widget build(BuildContext context) {
    paymentService = PaymentService(context: context);

    double price = Provider.of<CartProvider>(context).totalPrice();
    int totalCartItems =
        Provider.of<CartProvider>(context).getCartItems().length;
    double taxPrice = (price * 18) / 100;
    double totalPrice = (price * 18) / 100 + price;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "My Cart",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blueAccent,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Provider.of<CartProvider>(context).getCartItems().isNotEmpty
            ? Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                    itemCount: Provider.of<CartProvider>(context)
                        .getCartItems()
                        .length,
                    itemBuilder: (context, index) {
                      return CartWidget(Provider.of<CartProvider>(context)
                          .getCartItems()[index]);
                    },
                  )),
                  Container(
                    height: 150.h,
                    width: 1.sw,
                    margin: EdgeInsets.symmetric(horizontal: 5.r),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.r),
                            topRight: Radius.circular(8.r)),
                        color: Colors.grey.shade200),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            width: 300.w,
                            margin: EdgeInsets.only(top: 10.r),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Price "),
                                    Expanded(child: SizedBox()),
                                    Text("\u20B9$price")
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Tax (18%) "),
                                    Expanded(child: SizedBox()),
                                    Text("\u20B9${taxPrice.ceilToDouble()}")
                                  ],
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 1.r,
                                ),
                                Row(
                                  children: [
                                    Text("Total Price "),
                                    Expanded(child: SizedBox()),
                                    Text("\u20B9${totalPrice.ceilToDouble()}")
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            paymentService?.openCheckOut(
                                totalPrice.toInt(),
                                totalCartItems);
                          },
                          child: Text(
                            "Proceed to checkout",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              fixedSize: Size(200.w, 25.h),
                              backgroundColor: Colors.green),
                        ),
                        SizedBox(
                          height: 5.h,
                        )
                      ],
                    ),
                  ),
                ],
              )
            : Center(
                child: Text(
                  "Your cart is empty!",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                ),
              ));
  }

  Widget CartWidget(CartItem cartItem) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Card(
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        JewelleryItemsDetailsPage(productId: cartItem.id),
                  ));
            },
            child: Container(
              height: 180.h,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    elevation: 2,
                    child: Container(
                      height: 120.h,
                      width: 120.w,
                      margin: EdgeInsets.all(5.r),
                      child: ClipRRect(
                        child: Image.network(
                          cartItem.image,
                          width: 120.w,
                          fit: BoxFit.contain,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.r),
                            child: Text(
                              cartItem.title,
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: 15.sp),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.r),
                            child: Text(
                              'Price : \u20B9${cartItem.price}',
                              style: TextStyle(fontSize: 15.sp),
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(
                                      () {
                                        if (cartItem.quantity > 1) {
                                          cartItem.quantity -= 1;
                                          Provider.of<CartProvider>(context,
                                                  listen: false)
                                              .updateQuantity(cartItem.id,
                                                  cartItem.quantity);
                                        }
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.remove_outlined),
                                  disabledColor: Colors.grey),
                              Text(
                                "Quantity : ${cartItem.quantity} ",
                                style: TextStyle(),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(
                                      () {
                                        if (cartItem.quantity < 10) {
                                          cartItem.quantity += 1;
                                          Provider.of<CartProvider>(context,
                                                  listen: false)
                                              .updateQuantity(cartItem.id,
                                                  cartItem.quantity);
                                        }
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.add),
                                  disabledColor: Colors.grey),
                              // Expanded(child: SizedBox()),
                              IconButton(
                                  onPressed: () {
                                    Provider.of<CartProvider>(context,
                                            listen: false)
                                        .removeFromCart(cartItem.id);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                          SizedBox(height: 15.h,)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          color: Colors.grey.shade200,
          elevation: 8.r,
        );
      },
    );
  }

}
