import 'package:verimlilik_motoru/verimlilik_motoru.dart';
import 'package:flutter/material.dart';
import 'package:studio_core/apps/apps.dart';
import 'package:uyg_ajanda_ve_gunluk/uyg_ajanda_ve_gunluk.dart';
import 'package:uyg_aliskanlik_takibi/uyg_aliskanlik_takibi.dart';
import 'package:uyg_belge_tarayici/uyg_belge_tarayici.dart';
import 'package:uyg_cevrimdisi_ceviri/uyg_cevrimdisi_ceviri.dart';
import 'package:uyg_cizim_defteri/uyg_cizim_defteri.dart';
import 'package:uyg_ders_programi/uyg_ders_programi.dart';
import 'package:uyg_etiket_ve_envanter/uyg_etiket_ve_envanter.dart';
import 'package:uyg_fatura_fis_takip/uyg_fatura_fis_takip.dart';
import 'package:uyg_fatura_ve_teklif_hazirlayici/uyg_fatura_ve_teklif_hazirlayici.dart';
import 'package:uyg_film_ve_dizi_izleme_listesi/uyg_film_ve_dizi_izleme_listesi.dart';
import 'package:uyg_gorselden_metin/uyg_gorselden_metin.dart';
import 'package:uyg_hatirlatici/uyg_hatirlatici.dart';
import 'package:uyg_hedef_takibi/uyg_hedef_takibi.dart';
import 'package:uyg_kanban_panosu/uyg_kanban_panosu.dart';
import 'package:uyg_kartvizit_tarayici/uyg_kartvizit_tarayici.dart';
import 'package:uyg_kontrol_ve_alisveris_listesi/uyg_kontrol_ve_alisveris_listesi.dart';
import 'package:uyg_metin_araclari/uyg_metin_araclari.dart';
import 'package:uyg_not_defteri/uyg_not_defteri.dart';
import 'package:uyg_odev_takibi/uyg_odev_takibi.dart';
import 'package:uyg_okuma_listesi/uyg_okuma_listesi.dart';
import 'package:uyg_pano_gecmisi/uyg_pano_gecmisi.dart';
import 'package:uyg_pdf_goruntuleyici/uyg_pdf_goruntuleyici.dart';
import 'package:uyg_pomodoro/uyg_pomodoro.dart';
import 'package:uyg_proje_zaman_cizelgesi/uyg_proje_zaman_cizelgesi.dart';
import 'package:uyg_ses_kaydedici/uyg_ses_kaydedici.dart';
import 'package:uyg_sesten_yaziya_not/uyg_sesten_yaziya_not.dart';
import 'package:uyg_sifre_kasasi/uyg_sifre_kasasi.dart';
import 'package:uyg_sunum_zamanlayici_ve_teleprompter/uyg_sunum_zamanlayici_ve_teleprompter.dart';
import 'package:uyg_vardiya_planlayici/uyg_vardiya_planlayici.dart';
import 'package:uyg_yapilacaklar_listesi/uyg_yapilacaklar_listesi.dart';
import 'package:uyg_zaman_takibi/uyg_zaman_takibi.dart';
import 'package:uyg_zihin_haritasi/uyg_zihin_haritasi.dart';
import 'store_flavor.dart';

/// Verimlilik: 32 sade, çevrimdışı uygulama tek merkezde. Her uygulamanın
/// verisi ayrı saklanır; reklam yalnızca bir uygulamadan çıkarken ve en az
/// 3 dakika arayla gösterilir, bir işin ortasında asla.
final hubConfig = AppHubConfig(
  hubId: 'merkez-verimlilik',
  title: verHubTitle,
  tagline: verHubTagline,
  icon: Icons.task_alt_rounded,
  style: verHubStyle,
  categories: verCategories,
  tools: [
    notDefteriTool,
    yapilacaklarListesiTool,
    aliskanlikTakibiTool,
    pomodoroTool,
    kontrolVeAlisverisListesiTool,
    sesKaydediciTool,
    belgeTarayiciTool,
    pdfGoruntuleyiciTool,
    hatirlaticiTool,
    cizimDefteriTool,
    zihinHaritasiTool,
    metinAraclariTool,
    ajandaVeGunlukTool,
    faturaFisTakipTool,
    kanbanPanosuTool,
    zamanTakibiTool,
    faturaVeTeklifHazirlayiciTool,
    kartvizitTarayiciTool,
    gorseldenMetinTool,
    cevrimdisiCeviriTool,
    sestenYaziyaNotTool,
    okumaListesiTool,
    filmVeDiziIzlemeListesiTool,
    dersProgramiTool,
    odevTakibiTool,
    vardiyaPlanlayiciTool,
    sunumZamanlayiciVeTeleprompterTool,
    panoGecmisiTool,
    etiketVeEnvanterTool,
    sifreKasasiTool,
    hedefTakibiTool,
    projeZamanCizelgesiTool,
  ],
  featured: verFeatured,
  privacyUrl: 'https://github.com/taktemurr-ops/merkez-verimlilik/blob/main/PRIVACY.md',
);

void main() {
  registerStoreFlavor();
  bootstrapAppHub(hubConfig);
}
