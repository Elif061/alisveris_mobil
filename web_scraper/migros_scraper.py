from selenium import webdriver
from selenium.webdriver.common.by import By
import time

# Tarayıcıyı başlat
driver = webdriver.Chrome()
driver.get("https://www.migros.com.tr/beslenme-yasam-tarzi-ptt-1")

# Ürün bilgilerini tutacak listeler
product_names = []
image_urls = []

try:
    time.sleep(5)

    # Çerez bildirimi varsa kapat
    try:
        kabul_buton = driver.find_element(By.XPATH, "//button[contains(text(), 'Tümünü Kabul Et')]")
        kabul_buton.click()
        print("Çerez bildirimi kapatıldı.")
    except:
        print("Çerez bildirimi yok veya otomatik kapandı.")

    input("\n🔻 Sayfayı gez, ürünler yüklensin. Hazırsan Enter'a bas → veriler çekilecek...\n")
    time.sleep(2)

    # Ürünleri bul
    urunler = driver.find_elements(By.CLASS_NAME, "product-link")
    print(f"\nToplam ürün: {len(urunler)}\n")

    for urun in urunler:
        try:
            ad = urun.get_attribute("title") or urun.text
        except:
            ad = "Ürün adı yok"

        try:
            resim = urun.find_element(By.TAG_NAME, "img").get_attribute("src")
        except:
            resim = "Resim yok"

        # Listeye ekle
        product_names.append(ad)
        image_urls.append(resim)

        # Konsola yazdır
        print("Ürün Adı:", ad)
        print("Resim:", resim)
        print("-" * 40)

    input("\n🟢 Ürünler çekildi. Enter'a basarsan tarayıcı kapanacak.")
finally:
    driver.quit()

# Liste dışarıdan erişilsin diye bu kısmı ekliyoruz
with open("migros_veri_temp.py", "w", encoding="utf-8") as f:
    f.write("product_names = " + str(product_names) + "\n")
    f.write("image_urls = " + str(image_urls) + "\n")
