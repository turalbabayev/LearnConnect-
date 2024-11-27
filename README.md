# LearnConnect - Modern Video Tabanlı Eğitim Platformu

**LearnConnect**, kullanıcıların kurslara kaydolabileceği, videoları izleyebileceği ve çevrimdışı olarak da içeriklere erişim sağlayabileceği modern bir eğitim platformudur.

---

## 🎯 İçindekiler
- [📱 Uygulama Özellikleri](#-uygulama-özellikleri)
- [🛠️ Kullanılan Teknolojiler ve Mimari](#️-kullanılan-teknolojiler-ve-mimari)
- [📦 Kurulum Adımları](#-kurulum-adımları)
- [🧪 Unit Testler](#-unit-testler)
- [🌟 Uygulama Görselleri](#-uygulama-görselleri)
- [🎥 Demo Video](#-demo-video)
- [🤝 Katkıda Bulunma](#-katkıda-bulunma)
- [📧 İletişim](#-iletişim)

## 📱 Kullanıcı İşlemleri
- ✉️ **Kullanıcı Kayıt ve Giriş:** Kullanıcılar e-posta ve şifre ile kayıt olabilir ve giriş yapabilir.
- 🔑 **Kullanıcı Şifre Sıfırlama:** Kullanıcılar e-posta ile şifre sıfırlama bağlantısı gönderebilir.
- 👤 **Profil Görüntüleme ve Güncelleme:** Kullanıcılar profil bilgilerini görüntüleyebilir ve düzenleyebilir.

---

## 📚 Kurs Yönetimi
- 📋 **Kurs Listeleme:** Tüm kurslar bir liste halinde gösterilir.
- 📌 **Kurslara Kayıt:** Kullanıcılar istediği kurslara kolayca kayıt olabilir.
- ⭐ **Favoriler (Watchlist) - Ekstra Özellik:** Kullanıcılar kursları favorilere ekleyebilir.
- 🔍 **Kategorilere Göre Filtreleme ve Arama - Ekstra Özellik:** Kurslar kategori ve anahtar kelimeye göre filtrelenebilir ve aranabilir.

---

## 🎥 Video Oynatıcı
- ▶️ **Ders Videolarını İzleme:** Kullanıcılar kaydolduğu kursların ders videolarını izleyebilir.
- ⏩ **Video Hız Kontrolü - Ekstra Özellik:** Kullanıcılar kaydolduğu kursların videolarını 1x, 1.5x, 2x şeklinde izleyebilir.
- 💾 **İlerleme Kaydı:** Video izleme ilerlemesi local olarak kaydedilir ve kaldığı yerden devam edilebilir.
- 📥 **Offline Video İzleme - Ekstra Özellik:** Kullanıcılar videoları indirip internetsiz ortamda izleyebilir.

---

## 🌑 Dark Mode Desteği
- 🌙 **Karanlık Mod:** Kullanıcılar uygulamanın karanlık modunu aktif edebilir.

---

## 🌟 Ekstra Özellikler
- 🔔 **Bildirimler - Ekstra Özellik:** 
  - 📤 Uygulama içi local olarak bildirimler gönderilir (örneğin: kurs kaydı). 
  - 🗂️ Bildirimler daha sonra **Bildirimler Sayfası** üzerinden görüntülenebilir.


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

## 🌟 Uygulama Görselleri
### 🌟 Light Mode

<div style="display: flex; justify-content: space-between;">

<img src="https://endorfinmed.com/wp-content/uploads/2024/11/SplashScreen.png" alt="Splash Screen" width="22%" />
<img src="https://endorfinmed.com/wp-content/uploads/2024/11/onboarding1.png" alt="Onboarding1" width="22%" />
<img src="https://endorfinmed.com/wp-content/uploads/2024/11/onboarding2.png" alt="Onboarding2" width="22%" />
<img src="https://endorfinmed.com/wp-content/uploads/2024/11/onboarding3.png" alt="Onboarding3" width="22%" />

</div>
<div style="display: flex; justify-content: space-between;">

<img src="https://endorfinmed.com/wp-content/uploads/2024/11/login.png" alt="Login Page" width="22%" />
<img src="https://endorfinmed.com/wp-content/uploads/2024/11/register.png" alt="Register Page" width="22%" />
<img src="https://endorfinmed.com/wp-content/uploads/2024/11/resetpass.png" alt="Reset Password" width="22%" />
<img src="https://endorfinmed.com/wp-content/uploads/2024/11/successRegister.png" alt="Success Register" width="22%" />

</div>
<div style="display: flex; justify-content: space-between;">

<img src="https://endorfinmed.com/wp-content/uploads/2024/11/home.png" alt="Home Page" width="22%" />
<img src="https://endorfinmed.com/wp-content/uploads/2024/11/courseDetail.png" alt="Course Page" width="22%" />
<img src="https://endorfinmed.com/wp-content/uploads/2024/11/courseRegister.png" alt="Course Register" width="22%" />
<img src="https://endorfinmed.com/wp-content/uploads/2024/11/videoplayer-1.png" alt="Course Play" width="22%" />

</div>
<div style="display: flex; justify-content: space-between;">

<img src="https://endorfinmed.com/wp-content/uploads/2024/11/profile.png" alt="Profile Page" width="22%" />
<img src="https://endorfinmed.com/wp-content/uploads/2024/11/editProfile.png" alt="Edit Profile" width="22%" />
<img src="https://endorfinmed.com/wp-content/uploads/2024/11/profilefull.png" alt="Course Register" width="22%" />
<img src="https://endorfinmed.com/wp-content/uploads/2024/11/courseFavTogle.png" alt="Favorite Toggle" width="22%" />

</div>
<div style="display: flex; justify-content: space-between;">

<img src="https://endorfinmed.com/wp-content/uploads/2024/11/mycourse.png" alt="My Courses" width="22%" />
<img src="https://endorfinmed.com/wp-content/uploads/2024/11/myfav.png" alt="My Fav" width="22%" />
<img src="https://endorfinmed.com/wp-content/uploads/2024/11/notification.png" alt="Notification Page" width="22%" />

</div>

### 🌟 Dark Mode
<div style="display: flex; justify-content: space-between;">

<img src="https://endorfinmed.com/wp-content/uploads/2024/11/homedark.png" alt="Home Page Dark" width="22%" />
<img src="https://endorfinmed.com/wp-content/uploads/2024/11/mycoursesdark.png" alt="My Courses Dark" width="22%" />
<img src="https://endorfinmed.com/wp-content/uploads/2024/11/myfavdark.png" alt="My Fav Dark" width="22%" />
<img src="https://endorfinmed.com/wp-content/uploads/2024/11/myprofiledark.png" alt="My Profile Dark" width="22%" />
<img src="https://endorfinmed.com/wp-content/uploads/2024/11/notificationdark.png" alt="Notification Dark" width="22%" />
</div>

## 🤝 Katkıda Bulunma
Bu projeye katkıda bulunmak için bir **pull request** oluşturabilir veya bir **issue** açabilirsiniz.

---

## 📧 İletişim
**Geliştirici:** Tural Babayev  
**E-posta:** [turalbabayev@turalbabayev.com.tr](mailto:turalbabayev@turalbabayev.com.tr)  
**GitHub:** [Tural Babayev](https://github.com/turalbabayev)  
**Linkedin:** [Tural Babayev](https://github.com/turalbabayev](https://www.linkedin.com/in/turalbabayev/))  
