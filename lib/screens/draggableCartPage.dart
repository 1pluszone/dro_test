import 'package:dro_test/data/cart.dart';
import 'package:dro_test/model/cartModel.dart';
import 'package:dro_test/reusables/color_codes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DraggableCartPage extends StatefulWidget {
  final ScrollController controller;
  DraggableCartPage({this.controller});
  @override
  _DraggableCartPageState createState() => _DraggableCartPageState();
}

class _DraggableCartPageState extends State<DraggableCartPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: (97 * MediaQuery.of(context).size.height / 100),
        margin: const EdgeInsets.only(top: 6.0),
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
          color: dark_pupple,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Consumer<Cart>(
          builder: (context, myCart, child) => Column(
            children: [
              Center(
                child: Divider(
                  //height: 50,
                  thickness: 5,
                  color: Colors.white,
                  indent: 150,
                  endIndent: 150,
                ),
              ),
              Row(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          shopBagIcon,
                          SizedBox(width: 5),
                          Text("Bag", style: cartpageStyle)
                        ],
                      )),
                  Expanded(
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(myCart.cartList.length.toString()))),
                  )
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  color: Colors.white,
                ),
                child: Text("Tap on an item for add, remove, delete options",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  primary: false,
                  //controller: widget.controller,
                  itemCount: myCart.cartList.length,
                  itemBuilder: (context, index) => (myCart.cartList.isEmpty)
                      ? Center(
                          child: Text("Your cart is empty"),
                        )
                      : Column(
                          children: [
                            InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () => detectTap(myCart.cartList, index),
                              child: ListTile(
                                leading: Wrap(spacing: 10, children: [
                                  CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Image.asset(myCart
                                          .cartList[index].drugModel.drugUrl)),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                        "${myCart.cartList[index].quantity}X",
                                        style: cartpageStyle),
                                  )
                                ]),
                                title: Text(
                                    myCart.cartList[index].drugModel.drugName,
                                    style: cartpageStyle),
                                subtitle: Text(
                                    myCart
                                        .cartList[index].drugModel.dispensedIn,
                                    style: cartpageStyle),
                                trailing: Text(
                                    "₦${myCart.cartList[index].amount.toString()}",
                                    style: cartpageStyle),
                              ),
                            ),
                            (!myCart.cartList[index].expand)
                                ? SizedBox()
                                : Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.white, size: 30),
                                        onPressed: () =>
                                            myCart.removeFromCart(index),
                                      ),
                                      Spacer(),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                          onPressed: () {
                                            if (myCart
                                                    .cartList[index].quantity !=
                                                1)
                                              myCart.cartList[index].quantity--;
                                            myCart.changeInPrice(
                                                myCart.cartList[index].quantity,
                                                index);
                                          },
                                          icon: Icon(Icons.remove),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text('${myCart.cartList[index].quantity}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                      SizedBox(width: 10),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                          onPressed: () {
                                            myCart.cartList[index].quantity++;
                                            myCart.changeInPrice(
                                                myCart.cartList[index].quantity,
                                                index);
                                          },
                                          icon: Icon(
                                            Icons.add,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                          ],
                        ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Total", style: cartpageStyle),
                            Spacer(),
                            Text("₦${myCart.totalAmount}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20))
                          ],
                        ),
                        ButtonTheme(
                            padding: EdgeInsets.symmetric(horizontal: 70),
                            buttonColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: RaisedButton(
                              child: Text("Checkout"),
                              onPressed: () {},
                            ))
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }

  detectTap(List<CartModel> myCart, int index) {
    setState(() {
      myCart[index].expand = !myCart[index].expand;
    });
  }
}
