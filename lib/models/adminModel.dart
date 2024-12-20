import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GetPostinganKategoriDetail{
  String id, judul, file, deskripsi, tanggal, kategori, idKategori, jumlahDownload, jumlahKomentar;

  GetPostinganKategoriDetail({
    required this.id,
    required this.judul,
    required this.file,
    required this.deskripsi,
    required this.tanggal,
    required this.kategori,
    required this.idKategori,
    required this.jumlahDownload,
    required this.jumlahKomentar
  });

  static Future<List<GetPostinganKategoriDetail>> getPostinganKategoriDetail(String id) async{
    var url = Uri.parse("http://192.168.1.80:3000/api/getPostinganKategoriDetail/$id");
    var hasilResponse = await http.get(url);
    var jsonData = jsonDecode(hasilResponse.body);
    var dataList = jsonData["data"] as List;
    return dataList.map((user) {
      return GetPostinganKategoriDetail(
        id: user['id'].toString(),
        judul: user['judul'].toString(),
        file: user['file'].toString(),
        deskripsi: user['deskripsi'].toString(),
        tanggal: user['tanggal'].toString(),
        kategori: user['kategori'].toString(),
        idKategori: user['id_kategori'].toString(),
        jumlahDownload: user['jumlahDownload'].toString(),
        jumlahKomentar: user['jumlahKomentar'].toString(),
      );  
    }).toList();
  }
}

class GetViewDownload{
  String nama;

  GetViewDownload({required this.nama});

  Future<List<GetViewDownload>> getViewDownload(String id) async{
    var url = Uri.parse("http://192.168.1.80:3000/api/getViewDownload/$id");
    var hasilResponse = await http.get(url);
    var jsonData = jsonDecode(hasilResponse.body);
    var dataList = jsonData["data"] as List;
    return dataList.map((user) {
      return GetViewDownload(
        nama: user['nama'].toString(),
      );  
    }).toList();
  }
}

class GetViewKomentar{
  String  nama, komentar, tanggal;

  GetViewKomentar({required this.nama, required this.komentar, required this.tanggal});

  Future<List<GetViewKomentar>> getViewKomentar(String id) async{
    Uri url = Uri.parse("http://192.168.1.80:3000/api/getViewKomentar/$id");
    var hasilResponse = await http.get(url);
    var jsonData = jsonDecode(hasilResponse.body);
    var dataList = jsonData["data"] as List;
    return dataList.map((user) {
      return GetViewKomentar(
        nama: user['nama'].toString(),
        komentar: user['komentar'].toString(),
        tanggal: user['tanggal'].toString(),
      );
    }).toList();
  }
}

class DeleteAccountAdmin{
  String id;
  DeleteAccountAdmin({required this.id});
  static Future<DeleteAccountAdmin> deleteAccountAdmin(String id) async{
    Uri url = Uri.parse("http://192.168.1.80:3000/api/deleteAkun/$id");
    var hasilResponse = await http.delete(url);
    var jsonData = jsonDecode(hasilResponse.body);
    return DeleteAccountAdmin(id: jsonData['id'].toString());
  }
}

class GetAccountAdminDetail{
  String username, password, role, phone, nama, kodePerawat, id;

  GetAccountAdminDetail({required this.username, required this.password, required this.role, required this.phone, required this.nama, required this.kodePerawat, required this.id});

  static Future<GetAccountAdminDetail> getAccountAdminDetail(String id) async{
    Uri url = Uri.parse("http://192.168.1.80:3000/api/getAccountAdminDetail/$id");
    var hasilResponse = await http.get(url);
    var jsonData = jsonDecode(hasilResponse.body);
    var user = jsonData["data"][0];
    return GetAccountAdminDetail(
      id: user['id'].toString(),
      username: user['username'].toString(),
      password: user['password'].toString(),
      role: user['role'].toString(),
      phone: user['phone'].toString(),
      nama: user['identitas_nama'].toString(),
      kodePerawat: user['kode_perawat'].toString(),
    );
  }
}

class UpdateAccount{
  String username, password, role, phone, nama, kodePerawat;

  UpdateAccount({required this.username, required this.password, required this.role, required this.phone, required this.nama, required this.kodePerawat});

  static Future<UpdateAccount> updateAccount(String username, password, role, phone, nama, kodePerawat, id) async{
    Uri url = Uri.parse("http://192.168.1.80:3000/api/updateAkun/$id");
    var hasilResponse = await http.patch(url, 
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "username": username, 
      "password": password, 
      "role": role, 
      "phone": phone, 
      "nama": nama, 
      "kodePerawat": kodePerawat
    }));
    var jsonData = jsonDecode(hasilResponse.body);
    return UpdateAccount(
      username: jsonData['username'].toString(),
      password: jsonData['password'].toString(),
      role: jsonData['role'].toString(),
      phone: jsonData['phone'].toString(),
      nama: jsonData['nama'].toString(),
      kodePerawat: jsonData['kode_perawat'].toString(),
    );
    }
  }


class PostAccount{
  String username, password, role, phone, nama, kodePerawat;

  PostAccount({required this.username, required this.password, required this.role, required this.phone, required this.nama, required this.kodePerawat});

  static Future<PostAccount> postAccount(String username, password, role, phone, nama, kodePerawat) async{
    Uri url = Uri.parse("http://192.168.1.80:3000/api/postAkun");
    var hasilResponse = await http.post(url, 
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "username": username,
      "password": password,
      "role": role,
      "phone": phone,
      "nama": nama,
      "kodePerawat": kodePerawat
    }));
    var jsonData = jsonDecode(hasilResponse.body);
    return PostAccount(
      username: jsonData['username'].toString(),
      password: jsonData['password'].toString(),
      role: jsonData['role'].toString(),
      phone: jsonData['phone'].toString(),
      nama: jsonData['nama'].toString(),
      kodePerawat: jsonData['kode_perawat'].toString(),
    );
  }
}

class GetAccount{
  String username, password, role, phone, nama, kodePerawat, id;

  GetAccount({required this.username, required this.password, required this.role, required this.phone, required this.nama, required this.kodePerawat, required this.id});

  static Future<List<GetAccount>> getAccount() async {
    Uri url = Uri.parse("http://192.168.1.80:3000/api/getAccountAdmin");
    var hasilResponse = await http.get(url);
    var jsonData = jsonDecode(hasilResponse.body);
    var dataList = jsonData["data"] as List;
    return dataList.map((user) {
      return GetAccount(
        id: user['id'].toString(),
        username: user['username'].toString(),
        password: user['password'].toString(),
        role: user['role'].toString(),
        phone: user['phone'].toString(),
        nama: user['identitas_nama'].toString(),
        kodePerawat: user['kode_perawat'].toString(),
      );
    }).toList();
  }
}

class Adminmodel {
  String judul;
  IconData ikon;

  Adminmodel({required this.judul, required this.ikon});

  static List<Adminmodel> getAdminModel() {
    List<Adminmodel> adminList = [];

    adminList.add(Adminmodel(judul: "Jumlah Postingan", ikon: Icons.book));
    adminList.add(Adminmodel(judul: "Jumlah Download", ikon: Icons.analytics));
    adminList.add(Adminmodel(judul: "Jumlah Komentar", ikon: Icons.comment));
    return adminList;
  }
}

class GetTotalPostingan {
  String jumlah, judul;

  GetTotalPostingan({required this.jumlah, required this.judul});

  static Future<List<GetTotalPostingan>> getTotalPostingan() async {
    Uri url = Uri.parse(
        "http://192.168.1.80:3000/api/getTotalPostinganDownloadKomentar");
    var hasilResponse = await http.get(url);
    var jsonData = jsonDecode(hasilResponse.body);
    var dataList = jsonData["data"] as List;
    return dataList.map((user) {
      return GetTotalPostingan(
        judul: user['table_nama'],
        jumlah: user['total'].toString(),
      );
    }).toList();
  }
}

class GetPostinganAdmin {
  String id,
      title,
      content,
      date,
      category,
      jumlahDownload,
      file,
      jumlahKomentar;

  GetPostinganAdmin({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.category,
    required this.jumlahDownload,
    required this.file,
    required this.jumlahKomentar,
  });

  static Future<List<GetPostinganAdmin>> getPostinganAdmin() async {
    Uri url = Uri.parse("http://192.168.1.80:3000/api/getPostinganAdmin");
    var hasilResponse = await http.get(url);
    var jsonData = jsonDecode(hasilResponse.body);
    var dataList = jsonData["data"] as List;
    return dataList.map((user) {
      return GetPostinganAdmin(
        id: user['id'].toString(),
        title: user['judul'].toString(),
        file: user['file'],
        content: user['deskripsi'],
        date: user['tanggal'].toString(),
        category: user['kategori'],
        jumlahDownload: user['jumlah_download'].toString(),
        jumlahKomentar: user['jumlah_komentar'].toString(),
      );
    }).toList();
  }
}

class GetKategoriAdmin {
  String id, kategori, jumlahPostingan;

  GetKategoriAdmin({
    required this.id,
    required this.kategori,
    required this.jumlahPostingan,
  });

  static Future<List<GetKategoriAdmin>> getKategoriAdmin() async {
    Uri url = Uri.parse("http://192.168.1.80:3000/api/getKategoriAdmin");
    var hasilResponse = await http.get(url);
    var jsonData = jsonDecode(hasilResponse.body);
    var dataList = jsonData["data"] as List;
    return dataList.map((user) {
      return GetKategoriAdmin(
        id: user['id'].toString(),
        kategori: user['kategori'],
        jumlahPostingan: user['total_postingan'].toString(),
      );
    }).toList();
  }
}

class UpdatePostinganAdmin {
  String judul, deskripsi, file;

  UpdatePostinganAdmin({
    required this.judul,
    required this.deskripsi,
    required this.file,
  });

  static Future<UpdatePostinganAdmin> updatePostinganAdmin(
      String id, String judul, String file, String deskripsi) async {
    Uri url = Uri.parse("http://192.168.1.80:3000/api/updatePostingan/$id");
    var hasilResponse = await http.patch(url, body: {
      "judul": judul,
      "file": file,
      "deskripsi": deskripsi,
    });
    var jsonData = jsonDecode(hasilResponse.body);
    return UpdatePostinganAdmin(
        judul: jsonData['judul'].toString(),
        file: jsonData['file'].toString(),
        deskripsi: jsonData['deskripsi'].toString());
  }
}

class UpdateKategoriAdmin {
  String kategori;

  UpdateKategoriAdmin({required this.kategori});

  static Future<UpdateKategoriAdmin> updateKategoriAdmin(
      String id, String kategori) async {
    Uri url = Uri.parse("http://192.168.1.80:3000/api/updateKategori/$id");
    var hasilResponse = await http.patch(url, body: {"kategori": kategori});
    var jsonData = jsonDecode(hasilResponse.body);
    return UpdateKategoriAdmin(kategori: jsonData['kategori'].toString());
  }
}

class DeletePostinganAdmin {
  String id;

  DeletePostinganAdmin({
    required this.id,
  });

  static Future<DeletePostinganAdmin> deletePostinganAdmin(String id) async {
    Uri url = Uri.parse("http://192.168.1.80:3000/api/deletePostingan/$id");
    var hasilResponse = await http.delete(url);
    var jsonData = jsonDecode(hasilResponse.body);
    return DeletePostinganAdmin(id: jsonData['id'].toString());
  }
}

class DeleteKategoriAdmin {
  String id;

  DeleteKategoriAdmin({
    required this.id,
  });

  static Future<DeleteKategoriAdmin> deleteKategoriAdmin(String id) async {
    Uri url = Uri.parse("http://192.168.1.80:3000/api/deleteKategori/$id");
    var hasilResponse = await http.delete(url);
    var jsonData = jsonDecode(hasilResponse.body);
    return DeleteKategoriAdmin(id: jsonData['id'].toString());
  }
}

class PostPostinganAdmin {
  String id, idKategori, judul, file, deskripsi, tanggal;

  PostPostinganAdmin({
    required this.id,
    required this.idKategori,
    required this.judul,
    required this.file,
    required this.deskripsi,
    required this.tanggal,
  });

  static Future<PostPostinganAdmin> postPostinganAdmin(String idKategori,
      String judul, String file, String deskripsi, String tanggal) async {
    Uri url = Uri.parse("http://192.168.1.80:3000/api/uploadFileAdmin");
    var hasilResponse = await http.post(url, body: {
      "id_kategori": idKategori,
      "judul": judul,
      "file": file,
      "deskripsi": deskripsi,
      "tanggal": tanggal,
    });
    var jsonData = jsonDecode(hasilResponse.body);
    return PostPostinganAdmin(
        id: jsonData['id'].toString(),
        idKategori: jsonData['id_kategori'].toString(),
        judul: jsonData['judul'].toString(),
        file: jsonData['file'].toString(),
        deskripsi: jsonData['deskripsi'].toString(),
        tanggal: jsonData['tanggal'].toString());
  }
}

class PostKategoriAdmin {
  String namaKategori;

  PostKategoriAdmin({required this.namaKategori});

  static Future<PostKategoriAdmin> postKategoriAdmin(
      String namaKategori) async {
    Uri url = Uri.parse("http://192.168.1.80:3000/api/postKategoriAdmin");
    var hasilResponse = await http.post(url, body: {"kategori": namaKategori});
    var jsonData = jsonDecode(hasilResponse.body);
    return PostKategoriAdmin(namaKategori: jsonData['kategori'].toString());
  }
}

class GetKategoriAdminDetail {
  String kategori;

  GetKategoriAdminDetail({required this.kategori});

  static Future<GetKategoriAdminDetail> getKategoriAdminDetail(
      String id) async {
    Uri url = Uri.parse("http://192.168.1.80:3000/api/getKategoriDetail/$id");
    var hasilResponse = await http.get(url);
    var jsonData = jsonDecode(hasilResponse.body);
    var user = jsonData["data"][0];
    return GetKategoriAdminDetail(kategori: user['kategori'].toString());
  }
}
