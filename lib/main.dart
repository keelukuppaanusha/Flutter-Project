import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopping Cart App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const ShoppingCartScreen(),
      ),
    );
  }
}

class ShoppingCartScreen extends StatelessWidget {
  const ShoppingCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("🛍️ Online Shopping 🛒"),
        backgroundColor: Colors.green,
      ),
      body: Row(
        children: [
          // Left Side: Product Categories
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProductCategory(title: "🍅 Vegetables", products: vegetables),
                  ProductCategory(title: "🍎 Fruits", products: fruits),
                  ProductCategory(title: "🛒 Groceries", products: groceries),
                  ProductCategory(title: "🥛 Dairy Products", products: dairy),
                ],
              ),
            ),
          ),

          // Right Side: Billing & Cart Items
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "🛒 Your Cart 🛒",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: cartProvider.cart.isEmpty
                        ? const Center(child: Text("No items in the cart", style: TextStyle(fontSize: 16)))
                        : ListView(
                            children: cartProvider.cart
                                .map((item) => ListTile(
                                      title: Text(item['name']),
                                      trailing: Text("₹${item['price']}"),
                                    ))
                                .toList(),
                          ),
                  ),
                  const SizedBox(height: 10),
                  cartProvider.cart.isNotEmpty
                      ? Text(
                          "Total: ₹${cartProvider.cart.fold<int>(0, (sum, item) => sum + (item['price'] as int))}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        )
                      : Container(),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: cartProvider.cart.isEmpty ? null : () {},
                    icon: const Icon(Icons.payment),
                    label: const Text("Proceed to Checkout"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Product Category Widget (4 Items in One Row)
class ProductCategory extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> products;

  const ProductCategory({super.key, required this.title, required this.products});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        // Row Layout for 4 Items
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: products.map((product) {
              return Container(
                width: 160, // Fixed width for each item
                margin: const EdgeInsets.only(right: 10), // Space between items
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(product['image'], height: 80, width: 80, fit: BoxFit.cover),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Text("₹${product['price']}", style: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () => cartProvider.addToCart(product),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Add to Cart", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// Cart Provider
class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _cart = [];

  List<Map<String, dynamic>> get cart => _cart;

  void addToCart(Map<String, dynamic> product) {
    _cart.add(product);
    notifyListeners();
  }
}

// Product Data
final List<Map<String, dynamic>> vegetables = [
  {"name": "Tomato", "price": 20, "image": "assets/images/tomato.jpg"},
  {"name": "Carrot", "price": 30, "image": "assets/images/carrot.jpg"},
  {"name": "Potato", "price": 10, "image": "assets/images/potato.jpg"},
  {"name": "Cabbage", "price": 40, "image": "assets/images/cabbage.jpg"},
];

final List<Map<String, dynamic>> fruits = [
  {"name": "Apple", "price": 30, "image": "assets/images/apple.jpg"},
  {"name": "Banana", "price": 20, "image": "assets/images/banana.jpg"},
  {"name": "Mango", "price": 40, "image": "assets/images/mango.jpg"},
  {"name": "Orange", "price": 30, "image": "assets/images/orange.jpg"},
];

final List<Map<String, dynamic>> groceries = [
  {"name": "Rice", "price": 100, "image": "assets/images/rice.jpg"},
  {"name": "Flour", "price": 80, "image": "assets/images/flour.jpg"},
  {"name": "Sugar", "price": 60, "image": "assets/images/sugar.jpg"},
  {"name": "Salt", "price": 20, "image": "assets/images/salt.jpg"},
];

final List<Map<String, dynamic>> dairy = [
  {"name": "Milk", "price": 40, "image": "assets/images/milk.jpg"},
  {"name": "Butter", "price": 60, "image": "assets/images/butter.jpg"},
  {"name": "Paneer", "price": 80, "image": "assets/images/paneer.jpg"},
  {"name": "Cheese", "price": 90, "image": "assets/images/cheese.jpg"},
];