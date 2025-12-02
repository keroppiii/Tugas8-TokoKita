import 'dart:convert';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/produk.dart';

class ProdukBloc {
  
  // 1. GET: Mengambil semua data produk
  static Future<List<Produk>> getProduks() async {
    String apiUrl = ApiUrl.listProduk;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    
    // Mengambil key 'data' dari respon JSON
    List<dynamic> listProduk = (jsonObj as Map<String, dynamic>)['data'];
    List<Produk> produks = [];
    
    // Looping data untuk dimasukkan ke Model Produk
    for (int i = 0; i < listProduk.length; i++) {
      produks.add(Produk.fromJson(listProduk[i]));
    }
    
    return produks;
  }

  // 2. POST: Menambah produk baru
  static Future addProduk({Produk? produk}) async {
    String apiUrl = ApiUrl.createProduk;

    var body = {
      "kode_produk": produk!.kodeProduk,
      "nama_produk": produk.namaProduk,
      "harga": produk.hargaProduk.toString()
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  // 3. PUT: Mengupdate produk
  static Future updateProduk({required Produk produk}) async {
    // Pastikan ID dikonversi ke int jika di model tipe datanya String
    String apiUrl = ApiUrl.updateProduk(int.parse(produk.id!));
    print(apiUrl);

    var body = {
      "kode_produk": produk.kodeProduk,
      "nama_produk": produk.namaProduk,
      "harga": produk.hargaProduk.toString()
    };

    print("Body : $body");
    
    // Perhatikan penggunaan jsonEncode di sini karena method PUT biasanya butuh raw JSON
    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  // 4. DELETE: Menghapus produk
  static Future<bool> deleteProduk({int? id}) async {
    String apiUrl = ApiUrl.deleteProduk(id!);

    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    
    // Mengembalikan data boolean (true/false) dari respon server
    return (jsonObj as Map<String, dynamic>)['data'];
  }
}