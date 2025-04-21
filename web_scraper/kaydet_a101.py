import csv
from a101_veri_temp import urunler

# CSV dosyasına yaz
with open("a101_urunler.csv", mode="w", newline="", encoding="utf-8") as dosya:
    alanlar = ["Ürün Adı", "Fiyat", "Resim URL"]
    yazici = csv.DictWriter(dosya, fieldnames=alanlar)

    yazici.writeheader()
    for urun in urunler:
        yazici.writerow({
            "Ürün Adı": urun["ad"],
            "Fiyat": urun["fiyat"],
            "Resim URL": urun["resim"]
        })

print("✅ A101 ürünleri başarıyla 'a101_urunler.csv' dosyasına kaydedildi.")
