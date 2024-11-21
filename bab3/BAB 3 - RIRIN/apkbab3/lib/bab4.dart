import 'package:flutter/material.dart';

class Bab4 extends StatefulWidget {
  @override
  _Bab4State createState() => _Bab4State();
}

class _Bab4State extends State<Bab4> {
  // Daftar item di keranjang
  List<CartItem> cartItems = [
    CartItem(
        gambar: "assets/images/Mi hype abis.png",
        judul: "Indomie Mieghetti",
        deskripsi: "Mie Instan",
        harga: 4,
        jumlah: 0),
    CartItem(
        gambar: "assets/images/Mi goreng.png",
        judul: "Indomie goreng",
        deskripsi: "Mie Instan",
        harga: 4,
        jumlah: 0),
    CartItem(
        gambar: "assets/images/Mi goreng ayam geprek.png",
        judul: "Indomie ayam geprek",
        deskripsi: "Mie Instan",
        harga: 4,
        jumlah: 0),
  ];

  // Menghitung subtotal dari harga dan jumlah item
  double getSubtotal() {
    double subtotal = 0;
    for (var item in cartItems) {
      subtotal += item.harga * item.jumlah;
    }
    return subtotal;
  }

  // Menghitung diskon 4%
  double getDiscount() {
    double subtotal = getSubtotal();
    return subtotal * 0.04; // 4% dari subtotal
  }

  // Menghitung total setelah diskon dan biaya pengiriman
  double getTotal() {
    return getSubtotal() - getDiscount() + 0; // Menambahkan biaya pengiriman
  }

  // Fungsi untuk memperbarui jumlah item
  void updateItemQuantity(int index, int quantity) {
    setState(() {
      if (quantity > 0) {
        cartItems[index].jumlah = quantity;
      }
    });
  }

  // Fungsi untuk menghapus item
  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 20.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.1),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context); // Navigasi ke halaman sebelumnya
                },
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: Text(
                "Cart",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0, top: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.1),
                ),
                child: IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.black),
                  onPressed: () {},
                ),
              ),
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Menampilkan item keranjang
            Column(
              children: cartItems.map((item) {
                int index = cartItems.indexOf(item); // Mendapatkan index item
                return ListItem(
                  item: item,
                  onQuantityChanged: (quantity) {
                    updateItemQuantity(index, quantity);
                  },
                  onDelete: () {
                    removeItem(index); // Menghapus item
                  },
                );
              }).toList(),
            ),
            Container(
              padding: EdgeInsets.all(15),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Summary",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildCheckoutDetail(
                      "Items", cartItems.length.toString(), false),
                  _buildCheckoutDetail("Subtotal",
                      "\$${getSubtotal().toStringAsFixed(2)}", false),
                  _buildCheckoutDetail("Discount",
                      "-\$${getDiscount().toStringAsFixed(2)}", true),
                  _buildCheckoutDetail("Delivery Charges", "\$5.00", false),
                  Divider(thickness: 1, color: Colors.grey),
                  _buildCheckoutDetail(
                      "Total", "\$${getTotal().toStringAsFixed(2)}", true),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Proceeding to Checkout")));
                          },
                          child: Text("Check Out"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Color.fromARGB(255, 116, 3, 254), // Warna tombol
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            textStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk menampilkan detail checkout
  Widget _buildCheckoutDetail(String label, String value, bool isTotal) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 16,
                color: isTotal ? Colors.black : Colors.black.withOpacity(0.6)),
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? const Color.fromARGB(255, 0, 0, 0) : Colors.black),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String gambar;
  final String judul;
  final String deskripsi;
  final int harga;
  int jumlah;

  CartItem({
    required this.gambar,
    required this.judul,
    required this.deskripsi,
    required this.harga,
    this.jumlah = 1,
  });
}

class ListItem extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;
  final VoidCallback onDelete; // Callback untuk menghapus item

  ListItem(
      {required this.item, required this.onQuantityChanged, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        height: 160.0,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                item.gambar,
                width: 120.0,
                height: 120.0,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.judul,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    item.deskripsi,
                    style: TextStyle(
                        fontSize: 14, color: Colors.black.withOpacity(0.7)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    "\$ ${item.harga * item.jumlah}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 167, 32, 200)),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete, // Hapus item
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, size: 15, color: Colors.black),
                      onPressed: () {
                        if (item.jumlah > 1) {
                          onQuantityChanged(item.jumlah - 1);
                        }
                      },
                    ),
                    Text(
                      "${item.jumlah}",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, size: 15, color: Colors.black),
                      onPressed: () {
                        onQuantityChanged(item.jumlah + 1);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}