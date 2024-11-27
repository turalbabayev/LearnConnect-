# LearnConnect - Modern Video Tabanlı Eğitim Platformu

**LearnConnect**, kullanıcıların kurslara kaydolabileceği, videoları izleyebileceği ve çevrimdışı olarak da içeriklere erişim sağlayabileceği modern bir eğitim platformudur. Bu proje, kullanıcı dostu bir deneyim ve performansı ön planda tutarak geliştirilmiştir.

---

## 📱 Uygulama Özellikleri

### Kullanıcı İşlemleri
- **Kullanıcı Kayıt ve Giriş:** Kullanıcılar e-posta ve şifre ile kayıt olabilir ve giriş yapabilir.
- **Kullanıcı Şifre Sıfırlama:** Kullanıcılar e-posta ile şifre sıfırlama bağlantısı gönderebilir.
- **Profil Görüntüleme ve Güncelleme:** Kullanıcılar profil bilgilerini görüntüleyebilir ve düzenleyebilir.

### Kurs Yönetimi
- **Kurs Listeleme:** Tüm kurslar bir liste halinde gösterilir.
- **Kurslara Kayıt:** Kullanıcılar istediği kurslara kolayca kayıt olabilir.
- **Favoriler (Watchlist) - Ekstra Özellik:** Kullanıcılar kursları favorilere ekleyebilir.
- **Kategorilere Göre Filtreleme ve Arama - Ekstra Özellik:** Kurslar kategori ve anahtar kelimeye göre filtrelenebilir ve aranabilir.

### Video Oynatıcı
- **Ders Videolarını İzleme:** Kullanıcılar kaydolduğu kursların ders videolarını izleyebilir.
- **Video Hız Kontrolü: - Ekstra Özellik** Kullanıcılar kaydolduğu kursların videolarını 1x,1.5x,2x şeklinde izleyebilir.
- **İlerleme Kaydı:** Video izleme ilerlemesi local olarak kaydedilir ve kaldığı yerden devam edilebilir.
- **Offline Video İzleme - Ekstra Özellik:** Kullanıcılar videoları indirip internetsiz ortamda izleyebilir.

### Dark Mode Desteği
- **Karanlık Mod:** Kullanıcılar uygulamanın karanlık modunu aktif edebilir.

### Ekstra Özellikler
- **Bildirimler - Ekstra Özellik:** Uygulama içi local olarak bildirimler gönderilir(kurs kaydı vs.). Daha sonra bildirimleri Bildirimler sayfasından görüntüleyebilir..

---

## 🛠️ Kullanılan Teknolojiler ve Mimari

### Teknolojiler
- **Dil:** Swift
- **Mimari:** MVVM
- **Veritabanı:** SQLite
- **Backend:** Firebase (Authentication)
- **Video Oynatıcı:** AVPlayer
- **Reactive Programming:** RxSwift

### Kullanılan Kütüphaneler
- **RxSwift:** Reactive programlama.
- **Firebase SDK:** Kullanıcı kimlik doğrulama ve veri yönetimi.
  
---

## 📦 Kurulum Adımları

### 1. Gereksinimler
- **Xcode 14+**
- **Swift 5.0+**
- **CocoaPods** veya **Swift Package Manager**

### 2. Projeyi Klonlayın
```bash
git clone https://github.com/turalbabayev/LearnConnect.git
cd LearnConnect
```

## 3. Firebase Kurulumu

### Firebase Console'da Proje Oluşturma

1. [Firebase Console](https://console.firebase.google.com/) üzerinden yeni bir proje oluşturun.
2. iOS uygulaması ekleyin ve gerekli bilgileri doldurun (Bundle ID vb.).
3. `GoogleService-Info.plist` dosyasını indirin.

> **Not:** Bu dosya gizli olduğu için repository'ye eklenmemiştir. Lütfen kendi Firebase projenizden bu dosyayı indirin ve proje dizinine manuel olarak ekleyin.

---

### Firebase Servislerini Aktif Etme

1. **Authentication** sekmesinden "Email/Password" seçeneğini etkinleştirin.

## 4. Bağımlılıkları Yükleyin

### CocoaPods

```bash
pod install
```

### Swift Package Manager (SPM)

1. Xcode üzerinden:
   - `File > Swift Packages > Add Package Dependency` menüsüne gidin.
2. Aşağıdaki kütüphaneleri ekleyin:
   - [RxSwift](https://github.com/ReactiveX/RxSwift): https://github.com/ReactiveX/RxSwift
   - [Firebase](https://github.com/firebase/firebase-ios-sdk): https://github.com/firebase/firebase-ios-sdk

## 5. Projeyi Çalıştırın

1. `LearnConnect.xcworkspace` dosyasını Xcode'da açın.
2. Gerçek cihaz veya simülatörde projeyi başlatın.

## 🧪 Unit Testler

### 1. Arama Fonksiyonu Testi
Arama fonksiyonu, farklı senaryolar altında test edilmiştir:
- Boş giriş testi.
- Var olmayan bir kelime testi.
- Mevcut bir kurs testi.

---

### 2. Benzersiz Kategorileri Listeleme Testi
Kategoriler arasında herhangi bir tekrar olmadığından emin olmak için birim testler gerçekleştirilmiştir.

---

### Testleri Çalıştırmak İçin:
`Command + U`



