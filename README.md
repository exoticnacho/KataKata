# 💬 KataKata: Aplikasi Pembelajaran Bahasa Interaktif 🚀

Selamat datang di repositori resmi aplikasi **KataKata**! Sebuah aplikasi *mobile* yang dibangun dengan **Flutter** dan **Firebase** untuk membuat pembelajaran kosakata menjadi pengalaman yang *fun*, terstruktur, dan efektif.

## ✨ Fitur Utama

Kami menawarkan serangkaian fitur untuk mendukung proses belajar bahasa Anda:

* **Pembelajaran Berjenjang (Lessons):** Pelajaran terstruktur yang dibagi berdasarkan *Stage* (Level) progresif. 📈
* **Glosarium Pribadi:** Tempat Anda menyimpan dan mengelola semua kata-kata baru yang telah dipelajari atau perlu diulas. 📚
* **Mini-Games:** Tingkatkan retensi memori dengan permainan interaktif seperti **Flashcard** 🃏 dan latihan **Pronunciation** (Pengucapan). 🎤
* **Sistem Gamifikasi:** Lacak progres Anda dengan **XP**, **Level**, dan **Streak** harian! 📊
* **Autentikasi Aman:** Menggunakan Firebase Authentication untuk pengelolaan akun pengguna yang tepercaya. 🔑

---

## 💻 Teknologi dan Dependensi

| Kategori | Teknologi | Keterangan |
| :--- | :--- | :--- |
| **Framework Utama** | **Flutter** | Pengembangan UI lintas platform yang cepat. |
| **Backend** | **Firebase Firestore** | Database utama untuk data konten (questions, flashcards) dan data pengguna (progres, statistik). |
| **Auth** | **Firebase Authentication** | Menyediakan layanan otentikasi. |
| **Animasi** | **Lottie** | Digunakan untuk animasi dinamis (misalnya, `assets/lottie/confetti.json`). |

---

## ⚙️ Panduan Instalasi dan Menjalankan Proyek

### 1. Prasyarat

Pastikan Anda telah menginstal **Flutter SDK** dan memiliki konfigurasi lingkungan pengembangan yang benar.

### 2. Kloning Repositori

```bash
git clone https://github.com/exoticnacho/KataKata
cd KataKata
```

### 3. Konfigurasi Firebase 🔥

Proyek ini memerlukan koneksi yang benar ke layanan Google Firebase Anda:

1.  Dapatkan *file* **`google-services.json`** dari Firebase Console dan letakkan di direktori `android/app/`.
2.  Pastikan *file* konfigurasi Dart **`lib/firebase_options.dart`** telah dibuat dan terisi dengan detail proyek Anda.

### 4. Instalasi dan Run

Jalankan perintah berikut di direktori proyek:

```bash
# Ambil semua paket dan dependensi yang diperlukan
flutter pub get

# Jalankan aplikasi di perangkat atau emulator
flutter run
```
