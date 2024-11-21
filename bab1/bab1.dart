class User {
  String name;
  int age;
  late List<Product> products;
  Role? role;

  User(this.name, this.age, this.role) {
    products = [];
  }
}

class Product {
  String productName;
  double price;
  bool inStock;

  Product(this.productName, this.price, this.inStock);
}

enum Role { Admin, Customer }

class AdminUser extends User {
  AdminUser(String name, int age) : super(name, age, Role.Admin);

  // Cek apakah produk sudah ada sebelum menambahkan
  void tambahProduk(Product product) {
    bool alreadyExists = products.any((p) => p.productName == product.productName);

    if (alreadyExists) {
      print('${product.productName} sudah ada dalam daftar produk.');
    } else if (product.inStock) {
      products.add(product);
      print("\n===== INFO LAPORAN TAMBAH PRODUK =====");
      print('${product.productName} berhasil ditambahkan ke daftar produk.');
    } else {
      print('${product.productName} tidak tersedia dalam stok dan tidak dapat ditambahkan.');
    }
  }

  // Cek apakah produk ada di dalam daftar sebelum menghapus
  void hapusProduk(Product product) {
    if (products.contains(product)) {
      products.remove(product);
      print("\n===== INFO LAPORAN HAPUS PRODUK =====");
      print('${product.productName} berhasil dihapus dari daftar produk.');
    } else {
      print('${product.productName} tidak ditemukan dalam daftar produk.');
    }
  }
}

class CustomerUser extends User {
  CustomerUser(String name, int age) : super(name, age, Role.Customer);

  // Mengambil data produk sebelum menampilkan
  Future<void> lihatProduk() async {
    await fetchProductDetails(); // Menambahkan pengambilan data secara async
    print('\nDaftar Produk Tersedia:');
    if (products.isEmpty) {
      print('Tidak ada produk yang tersedia.');
    } else {
      for (var product in products) {
        print('${product.productName} - Rp${product.price} - ${product.inStock ? "Tersedia" : "Habis"}');
      }
    }
  }
}

// Mengambil data produk dengan penyesuaian stok secara acak
Future<void> fetchProductDetails() async {
  print('\nMengambil detail produk...');
  await Future.delayed(Duration(seconds: 2));
  print('Detail produk berhasil diambil dan stok telah diperbarui.');
}

void main() async {
  AdminUser admin = AdminUser('Alice', 30);
  CustomerUser customer = CustomerUser('Bob', 25);

  Product product1 = Product('Laptop', 15000000.0, true);
  Product product2 = Product('Handphone1', 8000000.0, false);
  Product product3 = Product('Handphone2', 8000000.0, true);

  try {
    admin.tambahProduk(product1); // Tambah produk yang tersedia
    admin.tambahProduk(product2); // Tambah produk yang tidak tersedia
    admin.tambahProduk(product3); // Tambah produk yang tersedia
    admin.tambahProduk(product1); // Tambah produk duplikasi
    admin.hapusProduk(product2); // Hapus produk yang tidak ada dalam daftar
    admin.hapusProduk(product1); // Hapus produk yang ada dalam daftar
  } on Exception catch (e) {
    print('Kesalahan: $e');
  }

  // Menambahkan produk ke customer secara manual untuk melihat produk
  customer.products.addAll([product1, product2, product3]);
  await customer.lihatProduk();

  // Menggunakan Map untuk menyimpan produk dengan harga dan stok terbaru
  Map<String, Product> productMap = {
    product1.productName: product1,
    product2.productName: product2,
    product3.productName: product3,
  };

  print('\nDaftar Produk dari Map dengan Validasi Stok:');
  productMap.forEach((key, value) {
    if (value.inStock) {
      print('${key} - Harga: Rp${value.price} - Stok: Tersedia');
    } else {
      print('${key} - Harga: Rp${value.price} - Stok: Habis');
    }
  });

  // Menggunakan Set untuk menampilkan produk unik
  Set<Product> productSet = {product1, product2, product3};
  print('\nDaftar Produk dari Set (Produk Unik):');
  productSet.forEach((product) {
    print('${product.productName} - Harga: Rp${product.price} - ${product.inStock ? "Tersedia" : "Habis"}');
  });
}
