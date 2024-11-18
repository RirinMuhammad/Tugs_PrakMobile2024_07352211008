import 'dart:io';

enum KategoriBuku { Fiksi, NonFiksi, Sains, Sejarah }

mixin StatusPeminjaman {
  bool _dipinjam = false;

  bool get dipinjam => _dipinjam;

  void pinjam() {
    _dipinjam = true;
  }

  void kembalikan() {
    _dipinjam = false;
  }
}

abstract class Anggota {
  final String nama;
  final int umur;

  Anggota(this.nama, this.umur);

  void infoAnggota();
}

class AnggotaTetap extends Anggota {
  AnggotaTetap(String nama, int umur) : super(nama, umur);

  @override
  void infoAnggota() {
    print("Anggota Tetap: $nama, Umur: $umur");
  }
}

class AnggotaSementara extends Anggota {
  AnggotaSementara(String nama, int umur) : super(nama, umur);

  @override
  void infoAnggota() {
    print("Anggota Sementara: $nama, Umur: $umur");
  }
}

class Buku with StatusPeminjaman {
  final String judul;
  String penulis;
  KategoriBuku kategori;

  Buku(this.judul, this.penulis, this.kategori);

  void infoBuku() {
    print("Judul: $judul, Penulis: $penulis, Kategori: $kategori");
  }
}

class Perpustakaan {
  List<Buku> koleksiBuku = [];
  List<Anggota> daftarAnggota = [];

  void tambahBuku(Buku buku) {
    koleksiBuku.add(buku);
    print("Buku '${buku.judul}' ditambahkan ke perpustakaan.");
  }

  void daftarBuku() {
    koleksiBuku.forEach((buku) => buku.infoBuku());
  }

  void tambahAnggota(Anggota anggota) {
    daftarAnggota.add(anggota);
    print("Anggota '${anggota.nama}' telah terdaftar.");
  }

  void daftarAnggotaPerpustakaan() {
    daftarAnggota.forEach((anggota) => anggota.infoAnggota());
  }
}

void main() {
  var perpustakaan = Perpustakaan();

  var buku1 = Buku("Harry Potter", "J.K. Rowling", KategoriBuku.Fiksi);
  perpustakaan.tambahBuku(buku1);

  var anggota1 = AnggotaTetap("Irin", 20);
  perpustakaan.tambahAnggota(anggota1);

  perpustakaan.daftarBuku();
  perpustakaan.daftarAnggotaPerpustakaan();

  buku1.pinjam();
  print("Status peminjaman buku '${buku1.judul}': ${buku1.dipinjam ? 'Dipinjam' : 'Tersedia'}");
}
