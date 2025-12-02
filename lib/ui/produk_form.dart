import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class ProdukForm extends StatefulWidget {
  final Produk? produk;

  const ProdukForm({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH PRODUK";
  String tombolSubmit = "SIMPAN";

  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  // Fungsi untuk mengecek apakah ini mode Edit atau Tambah
  isUpdate() {
    if (widget.produk != null) {
      setState(() {
        judul = "UBAH PRODUK";
        tombolSubmit = "UBAH";
        _kodeProdukTextboxController.text = widget.produk!.kodeProduk!;
        _namaProdukTextboxController.text = widget.produk!.namaProduk!;
        _hargaProdukTextboxController.text =
            widget.produk!.hargaProduk.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _kodeProdukTextField(),
                _namaProdukTextField(),
                _hargaProdukTextField(),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET INPUT FIELDS ---

  Widget _kodeProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Kode Produk"),
      keyboardType: TextInputType.text,
      controller: _kodeProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Kode Produk harus diisi";
        }
        return null;
      },
    );
  }

  Widget _namaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Produk"),
      keyboardType: TextInputType.text,
      controller: _namaProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Nama Produk harus diisi";
        }
        return null;
      },
    );
  }

  Widget _hargaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Harga"),
      keyboardType: TextInputType.number,
      controller: _hargaProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Harga harus diisi";
        }
        if (int.tryParse(value) == null) {
          return "Harga harus angka";
        }
        return null;
      },
    );
  }

  // --- TOMBOL & LOGIKA ---

  Widget _buttonSubmit() {
    return ElevatedButton(
      child: _isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : Text(tombolSubmit),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
      ),
      onPressed: _isLoading
          ? null
          : () {
              var validate = _formKey.currentState!.validate();
              if (validate) {
                if (widget.produk != null) {
                  // Jika data produk ada, jalankan fungsi ubah
                  _ubah();
                } else {
                  // Jika data produk kosong, jalankan fungsi simpan
                  _simpan();
                }
              }
            },
    );
  }

  void _simpan() {
    setState(() {
      _isLoading = true;
    });

    // PERBAIKAN: Konstruktor Produk baru (dengan required hargaProduk)
    Produk createProduk = Produk(
      id: null,
      kodeProduk: _kodeProdukTextboxController.text,
      namaProduk: _namaProdukTextboxController.text,
      hargaProduk: int.parse(_hargaProdukTextboxController.text),
    );

    ProdukBloc.addProduk(produk: createProduk).then((value) {
      // PERBAIKAN: Ganti push dengan pushReplacement
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProdukPage()),
      );
    }, onError: (error) {
      // Jika gagal, tampilkan pesan error
      showDialog(
        context: context,
        builder: (BuildContext context) => WarningDialog(
          description: "Simpan gagal: $error",
        ),
      );
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _ubah() {
    setState(() {
      _isLoading = true;
    });

    // PERBAIKAN: Konstruktor Produk baru (dengan required hargaProduk)
    Produk updateProduk = Produk(
      id: widget.produk!.id!,
      kodeProduk: _kodeProdukTextboxController.text,
      namaProduk: _namaProdukTextboxController.text,
      hargaProduk: int.parse(_hargaProdukTextboxController.text),
    );

    ProdukBloc.updateProduk(produk: updateProduk).then((value) {
      // PERBAIKAN: Ganti push dengan pushReplacement
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProdukPage()),
      );
    }, onError: (error) {
      // Jika gagal, tampilkan pesan error
      showDialog(
        context: context,
        builder: (BuildContext context) => WarningDialog(
          description: "Ubah data gagal: $error",
        ),
      );
      setState(() {
        _isLoading = false;
      });
    });
  }
}