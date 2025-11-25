import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_detail.dart';
import 'package:tokokita/ui/produk_form.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({Key? key}) : super(key: key);

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  
  List<Produk> produkList = [
    Produk(
      id: "3",
      kodeProduk: 'A001',
      namaProduk: 'Laptop ASUS',
      hargaProduk: 8000000,
    ),
    Produk(
      id: "4",
      kodeProduk: 'A001-Updated',
      namaProduk: 'Laptop ASUS ROG',
      hargaProduk: 8500000,
    ),
    Produk(
      id: "5",
      kodeProduk: 'B002',
      namaProduk: 'Smartphone Samsung',
      hargaProduk: 5000000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Produk Fatim"), 
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProdukForm()),
                );
              },
            ),
          ),
        ],
      ),
      body: ListView(
        children: produkList.map((produk) {
          return ItemProduk(produk: produk);
        }).toList(),
      ),
    );
  }
}

class ItemProduk extends StatelessWidget {
  final Produk produk;

  const ItemProduk({Key? key, required this.produk}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProdukDetail(produk: produk),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(produk.namaProduk!),
          subtitle: Text("Rp ${produk.hargaProduk}"),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}