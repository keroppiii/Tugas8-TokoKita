import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/produk.dart';
import 'produk_form.dart';

class ProdukDetail extends StatefulWidget {
  final Produk produk;

  const ProdukDetail({super.key, required this.produk});

  @override
  State<ProdukDetail> createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  bool loading = false;

  Future<void> hapusProduk() async {
    setState(() => loading = true);

    final url = Uri.parse("http://localhost:8080/produk/${widget.produk.id}");
    final response = await http.delete(url);

    setState(() => loading = false);

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menghapus produk")),
      );
    }
  }

  void _confirmHapus() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Produk"),
        content: const Text("Yakin ingin menghapus produk ini?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(context);
              hapusProduk();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Produk"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Kode Produk"),
                    _value(widget.produk.kodeProduk),

                    const SizedBox(height: 16),
                    _label("Nama Produk"),
                    _value(widget.produk.namaProduk),

                    const SizedBox(height: 16),
                    _label("Harga"),
                    _value("Rp ${widget.produk.hargaProduk}"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
            _tombolHapusEdit(),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
    );
  }

  Widget _value(String? text) {
    return Text(
      text ?? "",
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Tombol Edit
        ElevatedButton.icon(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProdukForm(produk: widget.produk),
              ),
            ).then((value) {
              if (value == true) Navigator.pop(context, true);
            });
          },
          label: const Text("EDIT"),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(130, 48),
          ),
        ),

        // Tombol Delete
        ElevatedButton.icon(
          icon: const Icon(Icons.delete),
          onPressed: _confirmHapus,
          label: const Text("DELETE"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            minimumSize: const Size(130, 48),
          ),
        ),
      ],
    );
  }
}
