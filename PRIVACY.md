# Gizlilik Politikası · Privacy Policy — Verimlilik / Productivity

_Son güncelleme / Last updated: 2026-11-26_

## Türkçe
- Uygulamalar internet olmadan çalışır. Notlar, görevler, kayıtlar, çizimler, belgeler ve ayarlar yalnızca **cihazınızda** saklanır; sunucumuz yoktur.
- Hesap, ad, e-posta veya kişi listesi **istemeyiz ve toplamayız**. Kartvizit tarayıcı rehberinize erişmez; vCard'ı siz paylaşırsınız.
- **Kamera** yalnızca belge, kartvizit, görselden metin ve QR etiket tarama sırasında kullanılır. Metin tanıma (Google ML Kit) cihazda yapılır; görüntü yüklenmez.
- **Mikrofon** yalnızca siz ses kaydı ya da dikte başlattığınızda kullanılır. Ses kayıtları cihazda kalır.
- **Sesten yazıya**, telefonunuzun sistem konuşma tanıma hizmetini kullanır. "Yalnızca cihazda" ayarı (varsayılan açık) kapatılırsa bu hizmet sesi işlemek için internete gönderebilir; bu, telefonunuzun üreticisinin/işletim sisteminin politikasına tabidir.
- **Çevrimdışı çeviri**, onayınızla dil paketlerini (yaklaşık 30 MB) Google ML Kit üzerinden bir kez indirir; çevrilen metin cihazdan çıkmaz.
- **Pano geçmişi** panoyu arka planda okumaz; yalnızca "Panodan yapıştır"a bastığınızda okur.
- **Bildirimler** yalnızca hatırlatıcı ve odak zamanlayıcısı için kullanılır.
- Fatura/fiş ve fatura-teklif uygulamaları bilgilendirme amaçlıdır; resmî e-Fatura, muhasebe kaydı veya mali danışmanlık değildir.
- Reklamlar Google AdMob tarafından gösterilir. İlk açılışta bir kez seçim yaparsınız ("Kabul et" / "Yalnızca gerekli"); gereken bölgelerde Google'ın rıza formu ayrıca gösterilir. Seçiminizi Profil → Reklam ayarlarından değiştirebilirsiniz. Reklam bir işin ortasında asla gösterilmez.
- Uygulama içi satın almalar Google Play / App Store üzerinden yapılır; ödeme bilgilerinizi görmeyiz.
- Profil → "Tüm verilerimi sil" ile cihazdaki tüm verileri silebilirsiniz.
- Kumar, şans oyunu veya 18+ içerik yoktur.

## English
- The apps work offline. Notes, tasks, recordings, drawings, documents and settings are stored **only on your device**; we run no server.
- We do **not** ask for or collect accounts, names, e-mail or contacts. The business card scanner never reads your contacts; you share the vCard yourself.
- The **camera** is used only while scanning documents, business cards, text or QR labels. Text recognition (Google ML Kit) runs on the device; images are not uploaded.
- The **microphone** is used only when you start a recording or dictation. Recordings stay on the device.
- **Voice to text** uses your phone's system speech service. If "on device only" (on by default) is turned off, that service may send audio over the internet for processing, under your phone maker's/OS policy.
- The **offline translator** downloads language packs (about 30 MB) once via Google ML Kit, with your consent; translated text never leaves the device.
- **Clipboard history** never reads the clipboard in the background; it reads it only when you tap "Paste from clipboard".
- **Notifications** are used only for reminders and the focus timer.
- The receipt and invoice/quote apps are for information only; they are not an official e-invoice, bookkeeping record or financial advice.
- Ads are served by Google AdMob. On first launch you choose once ("Accept" / "Essential only"); where required, Google's consent form is also shown. Change it any time in Profile → Ad settings. Ads never interrupt a task.
- In-app purchases are processed by Google Play / App Store; we never see payment details.
- Profile → "Delete all my data" removes everything stored on the device.
- No gambling, games of chance or 18+ content.

## Ek: Veri akışı ve güvenlik / Addendum: data flows and security

### Türkçe
- **Yedekleme:** Android'in kendi yedeklemesi açıksa uygulama verileri (ilerleme, ayarlar, kayıtlar) Google hesabınızdaki şifreli cihaz yedeğine dahil olabilir; bunu cihaz ayarlarından kapatabilirsiniz.
- **Şifre Kasası:** Kasa yalnızca şifreli hâlde (Argon2id + AES-256-GCM) saklanır ve yedeklenir; ana şifre hiçbir yerde tutulmaz. Biyometrik açma anahtarı yalnızca bu cihazın güvenli deposunda kalır, yedeğe ve başka cihaza taşınmaz. Kasa ekranında ekran görüntüsü ve ekran kaydı engellenir.
- **Doğrulama Kodları (2FA):** Gizli anahtarlar cihazın güvenli deposunda (Android Keystore / iOS Anahtar Zinciri) tutulan anahtarla AES-GCM ile şifrelenir; kodlar cihazda üretilir, hiçbir sunucuya gönderilmez. Kamera yalnızca QR kodu tararken kullanılır. Dışa aktarma yalnızca sizin belirlediğiniz parolayla şifreli yedek olarak yapılır.
- **PDF İmzala ve Doldur:** Belgeler ve imzanız cihazda işlenir ve yalnızca sizin seçtiğiniz yere kaydedilir/paylaşılır. Bu bir nitelikli elektronik imza (e-imza) değildir; çizilen imza görüntüsü belgeye eklenir.
- **Odak Kilidi (Android):** Seçtiğiniz uygulamaların ön plana gelip gelmediğini anlamak için "Kullanım erişimi" izni ve uyarı ekranı için "Diğer uygulamaların üzerinde göster" izni istenir; yalnızca odak oturumu sırasında kullanılır, kullanım verisi kaydedilmez ve cihazdan çıkmaz. iOS ve web'de yalnızca zamanlayıcı çalışır (sistem başka uygulamaları engellemeye izin vermez).
- **Özgeçmiş Oluşturucu:** Bilgileriniz yalnızca cihazda saklanır; PDF cihazda üretilir. Bazı yazı sistemleri (Çince, Japonca, Korece, Hintçe, Tayca vb.) için yazı tipi ilk kullanımda Google Fonts'tan bir kez indirilir; bu indirmede özgeçmiş içeriği gönderilmez.

### English
- **Backup:** If Android's own backup is on, app data (progress, settings, records) may be included in the encrypted device backup in your Google account; you can turn this off in the device settings.
- **Password Vault:** The vault is stored and backed up only in encrypted form (Argon2id + AES-256-GCM); the master password is never stored. The biometric unlock key stays in this device's secure storage and is never backed up or moved. Screenshots and screen recording are blocked on the vault screen.
- **Authenticator Codes (2FA):** Secret keys are encrypted with AES-GCM using a key held in the device's secure storage (Android Keystore / iOS Keychain); codes are generated on the device and never sent to any server. The camera is used only while scanning a QR code. Export is only an encrypted backup protected by a password you choose.
- **PDF Sign & Fill:** Documents and your signature are processed on the device and saved/shared only where you choose. This is not a qualified electronic signature; the drawn signature image is placed on the document.
- **Focus Lock (Android):** "Usage access" is requested to tell whether the apps you picked come to the foreground, and "Display over other apps" for the reminder screen; both are used only during a focus session, usage data is not stored and never leaves the device. On iOS and web only the timer works (the system does not allow blocking other apps).
- **Resume Builder:** Your details stay on the device; the PDF is created on the device. For some scripts (Chinese, Japanese, Korean, Hindi, Thai, etc.) a font is downloaded once from Google Fonts on first use; no resume content is sent with that download.

İletişim / Contact: (yayıncı e-posta adresi / publisher e-mail)
