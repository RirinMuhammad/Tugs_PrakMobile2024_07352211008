class ProdukDigital {
  String namaProduk;
  double harga;
  String kategori;

  ProdukDigital(this.namaProduk, this.harga, this.kategori);

  void terapkanDiskon(double persenDiskon) {
    // Diskon hanya berlaku jika kategori adalah 'NetworkAutomation' dan diskon <= 50%
    if (kategori == 'NetworkAutomation' && persenDiskon <= 50) {
      harga -= harga * (persenDiskon / 100);
      print('Diskon sebesar $persenDiskon% diterapkan.');
    } else {
      print('Diskon tidak valid.');
    }
  }
}

abstract class Karyawan {
  String nama;
  int umur;
  bool statusBekerja = false; // Menambahkan status bekerja

  Karyawan(this.nama, this.umur);

  void mulaiBekerja() {
    statusBekerja = true;
    bekerja();
  }

  void berhentiBekerja() {
    statusBekerja = false;
    print('$nama sedang beristirahat.');
  }

  void bekerja();
}

class KaryawanTetap extends Karyawan {
  KaryawanTetap(String nama, int umur) : super(nama, umur);

  @override
  void bekerja() {
    if (statusBekerja) {
      print('$nama (Tetap) sedang bekerja keras.');
    } else {
      print('$nama (Tetap) sedang tidak bekerja.');
    }
  }
}

class KaryawanKontrak extends Karyawan {
  KaryawanKontrak(String nama, int umur) : super(nama, umur);

  @override
  void bekerja() {
    if (statusBekerja) {
      print('$nama (Kontrak) sedang bekerja dengan fokus.');
    } else {
      print('$nama (Kontrak) sedang tidak bekerja.');
    }
  }
}

mixin Kinerja {
  int produktivitas = 0;
  final int batasProduktivitas = 100; // Batas maksimal produktivitas

  void tingkatkanProduktivitas() {
    if (produktivitas + 10 <= batasProduktivitas) {
      produktivitas += 10;
      print('Produktivitas meningkat menjadi $produktivitas.');
    } else {
      print('Produktivitas sudah maksimal.');
    }
  }

  void turunkanProduktivitas() {
    if (produktivitas - 10 >= 0) {
      produktivitas -= 10;
      print('Produktivitas menurun menjadi $produktivitas.');
    } else {
      print('Produktivitas tidak bisa lebih rendah.');
    }
  }

  bool cekProduktivitasManager() {
    return produktivitas >= 85;
  }
}

class Manager extends Karyawan with Kinerja {
  Manager(String nama, int umur) : super(nama, umur);

  @override
  void bekerja() {
    print('$nama (Manager) bekerja dengan produktivitas $produktivitas.');
  }
}

enum FaseProyek { Perencanaan, Pengembangan, Evaluasi }

class Proyek {
  FaseProyek faseSaatIni = FaseProyek.Perencanaan;

  void transisiFase(FaseProyek faseBaru) {
    if (faseBaru.index == faseSaatIni.index + 1) {
      faseSaatIni = faseBaru;
      print('Transisi ke fase $faseBaru berhasil.');
    } else if (faseBaru.index < faseSaatIni.index) {
      faseSaatIni = faseBaru;
      print('Kembali ke fase $faseBaru untuk evaluasi lebih lanjut.');
    } else {
      print('Transisi tidak valid.');
    }
  }
}

class Perusahaan {
  List<Karyawan> karyawanAktif = [];
  List<Karyawan> karyawanNonAktif = [];
  final int batasMaksimal = 20;

  void tambahKaryawan(Karyawan karyawan) {
    if (karyawanAktif.length < batasMaksimal) {
      karyawanAktif.add(karyawan);
      print('Karyawan ${karyawan.nama} berhasil ditambahkan.');
    } else {
      print('Batas maksimal karyawan aktif tercapai.');
    }
  }

  void resignKaryawan(Karyawan karyawan) {
    if (karyawanAktif.contains(karyawan)) {
      karyawanAktif.remove(karyawan);
      karyawanNonAktif.add(karyawan);
      print('Karyawan ${karyawan.nama} telah resign.');
    } else {
      print('Karyawan tidak ditemukan dalam daftar aktif.');
    }
  }

  void tampilkanDaftarKaryawan() {
    print('Daftar Karyawan Aktif:');
    for (var karyawan in karyawanAktif) {
      print('- ${karyawan.nama}');
    }

    print('Daftar Karyawan Non-Aktif:');
    for (var karyawan in karyawanNonAktif) {
      print('- ${karyawan.nama}');
    }
  }
}

void main() {
  var produk = ProdukDigital('Automasi Jaringan', 5000000, 'NetworkAutomation');
  produk.terapkanDiskon(10);
  print('Harga setelah diskon: ${produk.harga}');

  var karyawanTetap = KaryawanTetap('Ririn', 30);
  karyawanTetap.mulaiBekerja();
  karyawanTetap.berhentiBekerja();

  var karyawanKontrak = KaryawanKontrak('Destita', 25);
  karyawanKontrak.mulaiBekerja();
  karyawanKontrak.berhentiBekerja();

  var manager = Manager('Lisa', 40);
  manager.tingkatkanProduktivitas();
  manager.bekerja();
  manager.turunkanProduktivitas();

  var proyek = Proyek();
  proyek.transisiFase(FaseProyek.Pengembangan);
  proyek.transisiFase(FaseProyek.Perencanaan);

  var perusahaan = Perusahaan();
  perusahaan.tambahKaryawan(karyawanTetap);
  perusahaan.tambahKaryawan(karyawanKontrak);
  perusahaan.tambahKaryawan(manager);
  perusahaan.resignKaryawan(karyawanTetap);
  perusahaan.tampilkanDaftarKaryawan();
}
