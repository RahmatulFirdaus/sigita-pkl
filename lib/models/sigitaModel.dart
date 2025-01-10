import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';  


class UpdatePhoneProfile {
  Future<String?> updatePhone(String id, String phone) async {
    var url = Uri.parse("https://b60a-125-164-96-28.ngrok-free.app/api/updatePhone/$id");
    var hasilResponse = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "phone": phone,
      }),
    );
    var jsonData = jsonDecode(hasilResponse.body);
    return jsonData['pesan'].toString();
  }
}

class UpdatePasswordProfile {
  Future<String?> updatePassword(String id, String password) async {
    var url = Uri.parse("https://b60a-125-164-96-28.ngrok-free.app/api/updatePassword/$id");
    var hasilResponse = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "password": password,
      }),
    );
    var jsonData = jsonDecode(hasilResponse.body);
    return jsonData['pesan'].toString();
  }
}


class GetUser {
  String id;
  String userId;
  String nama;
  String kodePerawat;
  String phone;

  GetUser({
    required this.nama,
    required this.kodePerawat,
    required this.phone,
    required this.id,
    required this.userId
  });

  static Future<GetUser> getUser() async {
    const storage = FlutterSecureStorage();
    var url = Uri.parse("https://b60a-125-164-96-28.ngrok-free.app/api/identitas");
    var token = await storage.read(key: 'token');
    var hasilResponse = await http.get(url,
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'}
        );
    
    // Pastikan response berhasil
    if (hasilResponse.statusCode == 200) {
      var jsonData = jsonDecode(hasilResponse.body);
      var user = jsonData["data"][0]; // Ambil data user pertama

      return GetUser(
        id: user['id'].toString(),
        userId: user['user_id'].toString(),
        nama: user['nama'].toString(),
        kodePerawat: user['kode_perawat'],
        phone: user['phone'],
      );
    } else {
      throw Exception('Failed to load user data');
    }
  }
}


class LoginSigita {
  static Future<String?> login(String username, String password) async {
      const storage = FlutterSecureStorage();
      final response = await http.post(
        Uri.parse('https://b60a-125-164-96-28.ngrok-free.app/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String token = data['data']['token'];
        final String role = data['data']['role'];

        // Simpan token ke storage
        await storage.write(key: 'token', value: token);

        return role;
      } else {
        final errorMessage = jsonDecode(response.body)['pesan'];
        return errorMessage;
      }
    } catch (e) {
      final errorMessage = jsonDecode(response.body)['pesan'];
        return errorMessage;
    }
  }
}


class GetSigita {
  String id, title, content, date, category, jumlah, file, idKategori;

  GetSigita({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.category,
    required this.jumlah,
    required this.file,
    required this.idKategori,
  });

  // Mengambil data tanpa validasi
  static Future<List<GetSigita>> connApi(String id) async {
    Uri url = Uri.parse("http://b60a-125-164-96-28.ngrok-free.app/api/getPostingan/$id");
    var hasilResponse = await http.get(url);
    var jsonData = jsonDecode(hasilResponse.body);
    var dataList = jsonData["data"] as List;
    return dataList.map((user) {
      return GetSigita(
        id: user['id'].toString(),
        idKategori: user['id_kategori'].toString(),
        title: user['judul'],
        file: user['file'],
        content: user['deskripsi'],
        date: user['tanggal'],
        category: user['kategori'],
        jumlah: user['jmlh'].toString(),
      );
    }).toList();
  }

  static Future<GetSigita> connApiDetail(String id) async {
    Uri url = Uri.parse("http://b60a-125-164-96-28.ngrok-free.app/api/getPostinganDetail/$id");
    var hasilResponse = await http.get(url);
    var jsonData = jsonDecode(hasilResponse.body);
    var user = jsonData["data"][0];
    return GetSigita(
      id: user['id'].toString(),
      idKategori: user['id_kategori'].toString(),
      title: user['judul'],
      file: user['file'],
      content: user['deskripsi'],
      date: user['tanggal'].toString(),
      category: user['kategori'],
      jumlah: user['jmlh'].toString(),
    );
  }
}

class PostSigita {
  String idPostingan;
  String idIdentitas, komentar;

  PostSigita({
    required this.idPostingan,
    required this.idIdentitas,
    required this.komentar,
  });

  static Future<PostSigita> postSigita(
      String idPostingan, String idIdentitas, String komentar) async {
    Uri url = Uri.parse("https://b60a-125-164-96-28.ngrok-free.app/api/simpanKomentar");
    var hasilResponse = await http.post(
      url,
      body: {
        "id_postingan": idPostingan,
        "id_identitas": idIdentitas,
        "komentar": komentar,
      },
    );
    var jsonData = jsonDecode(hasilResponse.body);
    return PostSigita(
      idPostingan: jsonData['id_postingan'].toString(),
      idIdentitas: jsonData['id_identitas'].toString(),
      komentar: jsonData['komentar'].toString(),
    );
  }
}

class GetFile {
  String pdf;

  GetFile({required this.pdf});

  static Future<GetFile> getFile(String id) async {
    Uri url = Uri.parse("http://b60a-125-164-96-28.ngrok-free.app/api/getDownloadFile/$id");
    var hasilResponse = await http.get(url);
    var jsonData = jsonDecode(hasilResponse.body);
    var user = jsonData["data"];
    return GetFile(pdf: user['file']);
  }
}

class PermissionFile {
  String idPostingan, idIdentitas;

  PermissionFile({
    required this.idPostingan,
    required this.idIdentitas
  });

  static Future<PermissionFile> postDownload(
      String idPostingan, String idIdentitas) async {
    Uri url = Uri.parse("https://b60a-125-164-96-28.ngrok-free.app/api/downloadModul");
    var hasilResponse = await http.post(
      url,
      body: {
        "id_postingan": idPostingan,
        "id_identitas": idIdentitas,
      },
    );
    var jsonData = jsonDecode(hasilResponse.body);
    return PermissionFile(
      idPostingan: jsonData['id_postingan'].toString(),
      idIdentitas: jsonData['id_identitas'].toString(),
    );
  }
}

class GetKategori {
  String kategori, id;

  GetKategori({required this.kategori, required this.id});

  static Future<List<GetKategori>> getKategori() async {
    Uri url = Uri.parse("http://b60a-125-164-96-28.ngrok-free.app/api/getKategori");
    var hasilResponse = await http.get(url);
    var jsonData = jsonDecode(hasilResponse.body);
    var dataList = jsonData["data"] as List;
    return dataList.map((user) {
      return GetKategori(
        id: user['id'].toString(),
        kategori: user['kategori'].toString(),
      );
    }).toList();
  }
}

class GetKomentar {
  String nama, kode_perawat, phone, komentar, tanggal;

  GetKomentar({
    required this.nama,
    required this.kode_perawat,
    required this.phone,
    required this.komentar,
    required this.tanggal,
  });

  static Future<List<GetKomentar>> getKomentar(String id) async {
    Uri url = Uri.parse("http://b60a-125-164-96-28.ngrok-free.app/api/getKomentar/$id");
    var hasilResponse = await http.get(url);
    var jsonData = jsonDecode(hasilResponse.body);
    var dataList = jsonData["data"] as List;
    return dataList.map((user) {
      return GetKomentar(
        nama: user['nama'].toString(),
        kode_perawat: user['kode_perawat'].toString(),
        phone: user['phone'].toString(),
        komentar: user['komentar'].toString(),
        tanggal: user['tanggal'].toString(),
      );
    }).toList();
  }
}

class GetPesan {
  String pesan;

  GetPesan({required this.pesan});

  static Future<GetPesan> getPesan(String id) async {
    Uri url = Uri.parse("http://b60a-125-164-96-28.ngrok-free.app/api/getKomentar/$id");
    var hasilResponse = await http.get(url);
    var jsonData = jsonDecode(hasilResponse.body);
    var user = jsonData["pesan"];
    return GetPesan(pesan: user);
  }
}
