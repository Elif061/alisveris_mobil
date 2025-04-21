from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
import time
import json

# Tarayıcı ayarları
options = Options()
options.add_experimental_option("detach", True)  # Tarayıcı açık kalsın
driver = webdriver.Chrome(options=options)

# A101 Market ürünler sayfasını aç
driver.get("https://www.a101.com.tr/market/")
time.sleep(5)

print("\n🔻 Sayfa otomatik olarak aşağı kaydırılıyor, ürünler yüklensin...\n")

# 🔁 Sayfa tamamen aşağı kaydırılsın
SCROLL_PAUSE_TIME = 2
last_height = driver.execute_script("return document.body.scrollHeight")

while True:
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    time.sleep(SCROLL_PAUSE_TIME)
    new_height = driver.execute_script("return document.body.scrollHeight")
    if new_height == last_height:
        break
    last_height = new_height

# Ürün kartlarını çek
urun_kartlari = driver.find_elements(By.CSS_SELECTOR, "article.flex.product-container.bg-white")

print(f"\nToplam ürün: {len(urun_kartlari)}\n")

urun_listesi = []

for kart in urun_kartlari:
    try:
        ad = kart.find_element(By.CSS_SELECTOR, "h3.text-sm.font-semibold.line-clamp-2").text.strip()
    except:
        ad = "Ürün adı alınamadı"

    try:
        fiyat = kart.find_element(By.CSS_SELECTOR, "span.text-lg.font-bold.text-primary").text.strip()
    except:
        fiyat = "Fiyat alınamadı"

    try:
        img = kart.find_element(By.CSS_SELECTOR, "img").get_attribute("src")
    except:
        img = "Görsel yok"

    urun_listesi.append({
        "ad": ad,
        "fiyat": fiyat,
        "resim": img
    })

# Geçici veriyi kaydet
with open("a101_veri_temp.py", "w", encoding="utf-8") as f:
    f.write(f"urunler = {json.dumps(urun_listesi, ensure_ascii=False, indent=2)}")

print("\n🟢 Ürünler başarıyla çekildi ve 'a101_veri_temp.py' dosyasına kaydedildi.")
input("\nKapatmak için Enter'a bas...")
driver.quit()

