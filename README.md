# 🧶 Craft Tracker

Annemin el işi takip uygulaması — Flutter ile geliştirilmiş, Google Drive yedekleme destekli kişisel iş takip aracı.

## ✨ Özellikler

- 📋 El işi projelerini ekleme, düzenleme ve takip etme
- 💰 Fiyat ve ödeme durumu takibi
- 🌈 Mevsimsel tema desteği (İlkbahar, Yaz, Sonbahar, Kış)
- ☁️ Google Drive ile otomatik yedekleme/geri yükleme
- 🌍 Çoklu dil desteği (TR, EN, DE, FR, ES, PT, IT)
- 🎨 ShadCN UI ile modern arayüz

## 🚀 Kurulum

### Gereksinimler

- Flutter SDK `^3.8.1`
- Android Studio / VS Code
- Firebase projesi (Google Sign-In için)

### 1. Repoyu klonla

```bash
git clone https://github.com/KULLANICI_ADIN/craft-tracker.git
cd craft-tracker
```

### 2. Bağımlılıkları yükle

```bash
flutter pub get
```

### 3. Firebase / Google Services yapılandırması

`android/app/google-services.example.json` dosyasını kopyalayıp gerçek değerlerle doldurun:

```bash
cp android/app/google-services.example.json android/app/google-services.json
```

Firebase Console'dan kendi `google-services.json` dosyanızı indirip `android/app/` altına koyabilirsiniz.

### 4. Ortam değişkenleri (Environment Config)

`lib/core/config/env.example.dart` dosyasını kopyalayıp gerçek key'lerinizi girin:

```bash
cp lib/core/config/env.example.dart lib/core/config/env.dart
```

`env.dart` dosyasındaki `googleServerClientId` değerini Google Cloud Console'daki OAuth Web Client ID ile değiştirin.

### 5. Uygulamayı çalıştır

```bash
flutter run
```

## 📁 Proje Yapısı

```
lib/
├── core/
│   ├── config/          # Ortam değişkenleri (env.dart)
│   ├── database/        # SQLite veritabanı yardımcıları
│   ├── di/              # Dependency Injection (GetIt)
│   ├── error/           # Hata sınıfları
│   ├── routing/         # GoRouter yapılandırması
│   ├── services/        # Google Drive servisi
│   └── theme/           # Mevsimsel tema sistemi
├── features/
│   ├── auth/            # Kimlik doğrulama
│   ├── settings/        # Ayarlar
│   ├── sync/            # Google Drive senkronizasyon
│   └── works/           # İş takibi (CRUD)
└── main.dart
```

## 🔒 Güvenlik

Aşağıdaki dosyalar `.gitignore` ile korunmaktadır ve repo'ya **dahil edilmez**:

| Dosya | Açıklama |
|-------|----------|
| `android/app/google-services.json` | Firebase yapılandırması |
| `lib/core/config/env.dart` | OAuth Client ID vb. |
| `*.jks`, `*.keystore` | Android imzalama anahtarları |
| `key.properties` | İmzalama yapılandırması |

> ⚠️ Bu dosyaları asla public bir repo'ya commit etmeyin!

## 📦 Kullanılan Paketler

| Paket | Açıklama |
|-------|----------|
| `flutter_bloc` | State management |
| `get_it` | Dependency Injection |
| `go_router` | Navigation / Routing |
| `sqflite` | Yerel SQLite veritabanı |
| `google_sign_in` | Google oturum açma |
| `googleapis` | Google Drive API |
| `shadcn_ui` | Modern UI bileşenleri |
| `easy_localization` | Çoklu dil desteği |
| `firebase_core` | Firebase altyapısı |
| `flutter_animate` | Animasyonlar |
| `confetti` | Konfeti efektleri 🎉 |

## 📄 Lisans

Bu proje kişisel kullanım amaçlıdır.
