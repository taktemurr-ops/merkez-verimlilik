#!/usr/bin/env python3
"""shots/raw altındaki görselleri fastlane düzenine yerleştirir:
shots/store/android/<yerel>/images/{phoneScreenshots,tenInchScreenshots,featureGraphic.png}
shots/store/ios/<yerel>/{N_iphone67.png,N_ipad13.png}
Yerel klasör adları depodaki fastlane/metadata klasörlerinden alınır."""
import glob, os, shutil
from PIL import Image

ALIAS = {'he': ['he', 'iw'], 'nb': ['nb', 'no'], 'zh': ['zh'], 'fil': ['fil', 'tl']}
SIZES = {'phone': (1080, 1920), 'tablet': (1920, 1080), 'iphone': (1290, 2796), 'ipad': (2048, 2732), 'feature': (1024, 500)}


def locale_dir(platform, lang):
    base = f'fastlane/metadata/{platform}'
    dirs = sorted(d for d in os.listdir(base) if os.path.isdir(os.path.join(base, d)))
    for code in ALIAS.get(lang, [lang]):
        for d in dirs:
            if d.split('-')[0].lower() == code:
                return d
    return None


n = 0
missing = set()
for p in sorted(glob.glob('shots/raw/*.png')):
    name = os.path.basename(p)[:-4]
    parts = name.split('_')
    kind, lang = parts[0], parts[1]
    img = Image.open(p).convert('RGB')
    want = SIZES[kind]
    if img.size != want:
        img = img.resize(want, Image.LANCZOS)
    if kind in ('phone', 'tablet', 'feature'):
        d = locale_dir('android', lang)
        if d is None:
            missing.add(f'android:{lang}'); continue
        root = f'shots/store/android/{d}/images'
        if kind == 'feature':
            out = f'{root}/featureGraphic.png'
        else:
            out = f'{root}/{"phoneScreenshots" if kind == "phone" else "tenInchScreenshots"}/{parts[2]}_{lang}.png'
    else:
        d = locale_dir('ios', lang)
        if d is None:
            missing.add(f'ios:{lang}'); continue
        out = f'shots/store/ios/{d}/{parts[2]}_{"iphone67" if kind == "iphone" else "ipad13"}.png'
    os.makedirs(os.path.dirname(out), exist_ok=True)
    img.save(out, optimize=True)
    n += 1
print('ok', n, 'eksik yerel:', sorted(missing))
