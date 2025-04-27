import requests
from bs4 import BeautifulSoup
import csv

# Ürün listemiz
urunler = [
    ("muz", "https://www.migros.com.tr/muz-yerli-kg-p-1a01b70"),
    ("limon", "https://www.migros.com.tr/limon-kg-p-19ff462"),
    ("maydanoz", "https://www.migros.com.tr/maydanoz-adet-p-1af36a9"),
    ("domates", "https://www.migros.com.tr/domates-kg-p-1ac7780"),
    ("salatalık", "https://www.migros.com.tr/hiyar-kg-p-1ad3ad0"),
    ("biber", "https://www.migros.com.tr/biber-koy-usulu-kg-p-1ac1258"),
    ("avokado", "https://www.migros.com.tr/avokado-adet-p-1ab6614"),
    ("havuç", "https://www.migros.com.tr/havuc-beypazari-paket-kg-p-1ad36f9"),
    ("soğan", "https://www.migros.com.tr/sogan-kuru-yeni-mahsul-kg-p-1b13277"),
    ("çilek", "https://www.migros.com.tr/cilek-kg-p-19d3928"),
    ("elma", "https://www.migros.com.tr/elma-granny-smith-kg-p-19e0448"),
    ("mantar", "https://www.migros.com.tr/kultur-mantari-400-g-paket-p-1aeea13"),
    ("karpuz", "https://www.migros.com.tr/karpuz-kg-p-19ee6d8"),
    ("portakal", "https://www.migros.com.tr/portakal-kg-p-1a0a047"),
    ("ananas", "https://www.migros.com.tr/ananas-adet-p-1a3a1cb"),
    ("lahana", "https://www.migros.com.tr/lahana-kirmizi-kg-p-1aec179"),
    ("patates", "https://www.migros.com.tr/patates-kg-p-1afabf4"),
    ("fasulye", "https://www.migros.com.tr/fasulye-ayse-kadin-kg-p-1acf098"),
    ("patlıcan", "https://www.migros.com.tr/patlican-bostan-kg-p-1afd6c8"),
    ("marul", "https://www.migros.com.tr/marul-adet-p-1af0f99")
]

urun_listesi = []

# Ürünleri çekelim
for ad, link in urunler:
    print(f"🔍 Ürün aranıyor: {ad}")
    try:
        response = requests.get(link, headers={"User-Agent": "Mozilla/5.0"})
        soup = BeautifulSoup(response.content, "html.parser")

        urun_adi_tag = soup.find("h1")
        fiyat_tag = soup.find("span", class_="price-tag-new")
        resim_tag = soup.find("img", {"class": "product-image"})  # Eğer olmazsa genel img de deneriz

        if urun_adi_tag and fiyat_tag:
            urun_adi = urun_adi_tag.get_text(strip=True)
            fiyat = fiyat_tag.get_text(strip=True)
            resim = resim_tag["src"] if resim_tag else "-"

            urun_listesi.append({
                "Ürün Adı": urun_adi,
                "Fiyat": fiyat,
                "Resim URL": resim,
                "Kategori": "meyve-sebze"
            })

            print(f"✅ Bulundu: {urun_adi} - {fiyat}")
        else:
            raise Exception("Ürün bilgisi bulunamadı")
    
    except Exception as e:
        print(f"❌ {ad} için ürün çekilemedi. Hata: {e}")
        urun_listesi.append({
            "Ürün Adı": f"{ad} (ürün bulunamadı)",
            "Fiyat": "-",
            "Resim URL": "-",
            "Kategori": "meyve-sebze"
        })

# CSV dosyasına yazalım
with open("migros_meyve_sebze.csv", mode="w", newline="", encoding="utf-8") as dosya:
    alanlar = ["Ürün Adı", "Fiyat", "Resim URL", "Kategori"]
    yazici = csv.DictWriter(dosya, fieldnames=alanlar)

    yazici.writeheader()
    for urun in urun_listesi:
        yazici.writerow(urun)

print("\n🟢 Tüm ürünler 'migros_meyve_sebze.csv' dosyasına kaydedildi.")
