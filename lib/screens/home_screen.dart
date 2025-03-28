import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jewellery_ordering_app/models/cart_item.dart';
import 'package:jewellery_ordering_app/models/graph_data.dart';
import 'package:jewellery_ordering_app/providers/cart_provider.dart';
import 'package:jewellery_ordering_app/providers/sold_data_provider.dart';
import 'package:jewellery_ordering_app/screens/jewellery_items_details_page.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/product_item.dart';
import '../providers/product_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<ProductItem> listOfProducts =
        Provider.of<ProductProvider>(context).getProductList();
    // fetching the list data
    List<GraphData> soldDataList =
        Provider.of<SoldDataProvider>(context).getGraphData();

    return listOfProducts.isNotEmpty
        ? SingleChildScrollView(
            // 👈 This makes the full page scrollable
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.r),
                  child: Text("Sales Char",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: 1.sw,
                    height: 200.h,
                    margin: EdgeInsets.all(5.r),
                    decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12.r)),
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(), // X-Axis as category
                      primaryYAxis: NumericAxis(), // Y-Axis as number
                      title: ChartTitle(text: 'Product Sales Data'),
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                        color: Colors.white,
                        builder:
                            (data, point, series, pointIndex, seriesIndex) =>
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.r),
                                    color: Colors.white60
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(5.r),
                                    child: Text(
                                      'Product Name: ${point.x}, \nTotal sale count : ${point.y}',
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),

                        ),
                      ),
                      zoomPanBehavior: ZoomPanBehavior(enablePanning: true),
                      series: [
                        ColumnSeries<GraphData, String>(
                          dataSource: soldDataList,
                          xValueMapper: (GraphData data, _) => data.productName,
                          yValueMapper: (GraphData data, _) => data.count,
                          name: "Sales",
                          color: Colors.blue,

                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(10.r),
                  child: Text("Featured Jewelry",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),

                // Horizontal Scrollable List
                Container(
                  height: 350.h, // Fixed height for horizontal scroll section
                  padding: EdgeInsets.only(bottom: 10.r),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        listOfProducts.length >= 3 ? 3 : listOfProducts.length,
                    itemBuilder: (context, index) {
                      return featureJewelleryItem(listOfProducts[index]);
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(10.r),
                  child: Text("All Products",
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.bold)),
                ),

                ListView.builder(
                  physics: NeverScrollableScrollPhysics(), // used to Disable scrolling inside ListView
                  shrinkWrap:true, // used to ListView inside SingleChildScrollView
                  itemCount: listOfProducts.length,
                  itemBuilder: (context, index) {
                    return jewelleryItem(listOfProducts[index]);
                  },
                ),
              ],
            ),
          )
        : Center(child: CircularProgressIndicator());
  }

  Widget featureJewelleryItem(ProductItem item) {
    return StatefulBuilder(builder: (context, setState) {
      return InkWell(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          margin: EdgeInsets.only(right: 8.r, top: 8.r, bottom: 10.r),
          child: Container(
            width: 300.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.r),
                        child: ClipRRect(
                          child: Image.network(
                            item.image,
                            height: 200.h,
                            width: 1.sw,
                            fit: BoxFit.contain,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.r, left: 8.r),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5.w,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.pink,
                            ),
                            Text('${item.rating.rate} (${item.rating.count})')
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // image

                //   name of the product
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.r, right: 8.r, top: 8.r),
                    child: Text(
                      "${item.title}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.r, right: 8.r),
                      child: Text(
                        "Price : \u20B9${item.price} ",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                      ),
                    ),

                    Expanded(child: SizedBox()),
                    // Add to cart Button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:8.r,vertical: 8.r),
                      child: ElevatedButton(
                        onPressed: () {
                          CartItem cartItem = CartItem(
                              id: item.id,
                              title: item.title,
                              image: item.image,
                              description: item.description,
                              price: item.price,
                              quantity: 1);
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
                            fixedSize: Size(150.w, 15.h),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r))),
                      ),
                    )
                  ],
                )

              ],
            ),
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
          ),
          elevation: 8.r,
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    JewelleryItemsDetailsPage(productId: item.id),
              ));
        },
      );
    });
  }

  Widget jewelleryItem(ProductItem item) {
    return StatefulBuilder(builder: (context, setState) {
      return InkWell(
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          margin: EdgeInsets.only(right: 8.r, top: 8.r, bottom: 10.r),
          child: Container(
            height: 400.h,
            width: 1.sw,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.r),
                        child: ClipRRect(
                          child: Image.network(
                            item.image,
                            height: 200.h,
                            width: 1.sw,
                            fit: BoxFit.contain,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.r, left: 8.r),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5.w,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.pink,
                            ),
                            Text('${item.rating.rate} (${item.rating.count})')
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // image

                //   name of the product
                Padding(
                  padding: EdgeInsets.only(left: 8.r, right: 8.r, top: 8.r),
                  child: Text(
                    "${item.title}",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.r, right: 8.r),
                  child: Text(
                    "Price : \u20B9${item.price} ",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                  ),
                ),
                //  description of the product
                Padding(
                  padding: EdgeInsets.all(8.r),
                  child: Text(
                    item.description.toString().length >= 80
                        ? item.description.toString().substring(0, 80) + " ...."
                        : item.description,
                    style: TextStyle(),
                  ),
                ),
                // Add to cart Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      CartItem cartItem = CartItem(
                          id: item.id,
                          title: item.title,
                          image: item.image,
                          description: item.description,
                          price: item.price,
                          quantity: 1);
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
            decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
          ),
          elevation: 8.r,
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    JewelleryItemsDetailsPage(productId: item.id),
              ));
        },
      );
    });
  }
}
