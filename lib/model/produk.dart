class Produk {
  String? id;
  String? kodeProduk;
  String? namaProduk;
  int hargaProduk;  // ← UBAH KE 'int' (bukan 'int?')
  
  Produk({
    this.id,
    this.kodeProduk,
    this.namaProduk,
    required this.hargaProduk,  // ← required karena int (non-nullable)
  });
  
  factory Produk.fromJson(Map<String, dynamic> obj) {
    // DEBUG: Print untuk lihat data
    print('=== DEBUG PARSING PRODUK ===');
    print('Received obj: $obj');
    print('harga value: ${obj['harga']}, type: ${obj['harga']?.runtimeType}');
    
    // Parse harga dengan aman
    int parsedHarga = 0;
    
    if (obj['harga'] != null) {
      if (obj['harga'] is int) {
        parsedHarga = obj['harga'];
      } else if (obj['harga'] is String) {
        // Coba parse string ke int
        parsedHarga = int.tryParse(obj['harga']) ?? 0;
        
        // Jika masih 0, mungkin ada karakter non-numeric
        if (parsedHarga == 0) {
          String clean = (obj['harga'] as String).replaceAll(RegExp(r'[^0-9]'), '');
          parsedHarga = int.tryParse(clean) ?? 0;
        }
      } else if (obj['harga'] is double) {
        parsedHarga = (obj['harga'] as double).toInt();
      }
    }
    
    print('Parsed harga: $parsedHarga');
    
    return Produk(
      id: obj['id']?.toString() ?? '',
      kodeProduk: obj['kode_produk']?.toString() ?? '',
      namaProduk: obj['nama_produk']?.toString() ?? '',
      hargaProduk: parsedHarga,
    );
  }
  
  // Helper method untuk debug
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode_produk': kodeProduk,
      'nama_produk': namaProduk,
      'harga': hargaProduk,
    };
  }
}