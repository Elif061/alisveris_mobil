import csv

resimler = [
    "https://images.migrosone.com/sanalmarket/product/05040604/05040604-8bd4d0.jpg",
    "https://images.migrosone.com/sanalmarket/product/05046461/05046461-86d90e.jpg",
    "https://images.migrosone.com/sanalmarket/product/17300004/17300004_1-adb25b.jpg",
    "https://images.migrosone.com/sanalmarket/product/09024117/09024117-21830b.jpg",
    "https://images.migrosone.com/sanalmarket/product/07045358/07045358-8cf0cf.jpg",
    "https://images.migrosone.com/sanalmarket/product/07209891/07209891-94eb82.jpg",
    "https://images.migrosone.com/sanalmarket/product/07045360/07045360-33152e.jpg",
    "https://images.migrosone.com/sanalmarket/product/07030618/7030618-633350.jpg",
    "https://images.migrosone.com/sanalmarket/product/10101787/10101787-9d09f1.jpg"
]

with open("migros_urunler.csv", mode="w", newline="", encoding="utf-8") as file:
    writer = csv.writer(file)
    writer.writerow(["ResimURL"])
    for url in resimler:
        writer.writerow([url])

print("✅ Veriler 'migros_urunler.csv' dosyasına kaydedildi.")
