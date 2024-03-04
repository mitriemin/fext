# Ferrari Extended (FEXT)
This is comprehensive module for realme GT2 Pro (ferrari), it can be used with another OPPO/OnePlus/realme devices with SM8450 (8 Gen 1) and SM8475 (8 Gen+ 1). FEXT's goal is give max performance and comfort without overheat
## Contacts
[@mitriemin_Stuffs](https://t.me/mitriemin_Stuffs)
## Requirements
- Magisk by topjohnwu or KSU by tiann
- 8 Gen 1 or 8 Gen+ 1
- realme UI 4.0 and higher
## Overheating
Known issue 8 Gen 1 is overheating. My module fix it. What we have alternative?

- [perf limit xiaomi 12](https://github.com/Magisk-Modules-Alt-Repo/perf-limit-xiaomi-12)
- Frigus Thermal

Perf limit, is only lock max freqs. It can't full fix overheating, but downgrade performance.

Frigus Thermal incorrect work, because it check CPU temperature sensors, what can show very big jumping (±10°C/m).

My module check CPU temp like Frigus, but correct value and then select one of limit for freqs like perf limit. But it doesn't all. I changed some kernel settings for better cooling device. It's all help FEXT show lowest temp in hard scenes and save performance bigger then MTK 8200 Ultra, SD870, Tensor G2
## Scrolling
Second major issue 8 Gen 1 is freezing and lagging scroll. Discussion of the problem has begun September 2023 in 4PDA in thematic thread. My module trys fix it, you choose good or not. I calibrated touch like iPhone 14 Pro Max. Maybe in future updates i will change something.
## Else
FEXT v1 has:
- RAM Management 
- ZRAM 4 GB

Check changelog about other features, what i can add in next version
