import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jewellery_ordering_app/models/product_item.dart';
import 'package:jewellery_ordering_app/providers/product_provider.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

class JewelleryItemsDetailsPage extends StatelessWidget {
  int productId;
  JewelleryItemsDetailsPage({super.key, required this.productId});

  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    ProductItem? jewelleryItemData = Provider.of<ProductProvider>(context).getProduct(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Jewellery Details Page",
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: jewelleryItemData!=null?SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Container(
                width: 1.sw,
                height: MediaQuery.of(context).size.height * 0.30,
                padding: EdgeInsets.all(8.r),
                child: ClipRRect(
                  child: Image.network(
                    jewelleryItemData.image,
                    fit: BoxFit.contain,
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12.r)),
              ),
              elevation: 8.r,
            ),

            //   name of the product
            Padding(
              padding: EdgeInsets.only(left: 8.r, right: 8.r, top: 8.r),
              child: Text(
                "${jewelleryItemData.title}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                textAlign: TextAlign.justify,
              ),
            ),

            //  description of the product
            Padding(
              padding: EdgeInsets.all(8.r),
              child: Text(
                jewelleryItemData.description.toString(),
                style: TextStyle(fontSize: 17.sp),
                textAlign: TextAlign.justify,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 8.r, right: 8.r),
              child: Row(
                children: [
                  Text(
                    "Price : \u20B9${jewelleryItemData.price} ",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp),
                  ),
                  Expanded(child: SizedBox()),
                  StatefulBuilder(
                    builder: (context, setState) => Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  if (quantity > 1) {
                                    quantity--;
                                  }
                                },
                              );
                            },
                            icon: Icon(Icons.remove_outlined),
                            disabledColor: Colors.grey),
                        Text(
                          "Quantity : $quantity ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17.sp),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(
                                    () {
                                  if (quantity < 10) {
                                    quantity++;
                                  }
                                },
                              );
                            },
                            icon: Icon(Icons.add),
                            disabledColor: Colors.grey),
                      ],
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 50.h,),

            // Add to cart Button
            Center(
              child: ElevatedButton(
                onPressed: () {

                  CartItem cartItem = CartItem(
                      id: jewelleryItemData.id,
                      title: jewelleryItemData.title,
                      image: jewelleryItemData.image,
                      description: jewelleryItemData.description,
                      price: jewelleryItemData.price,
                      quantity: quantity);
                  Provider.of<CartProvider>(context, listen: false)
                      .addToCart(cartItem);


                },
                child: Text(
                  "Add To Cart",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    fixedSize: Size(200.w, 20.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r))),
              ),
            )
          ],
        ),
      ):Center(child: Text("No product details found!"),),
    );
  }
}
