<img align="left" style="vertical-align: middle" width="120" height="120" src="data/icon.png">

# Countdown

Track events until they happen or since they happened

###

[![Please do not theme this app](https://stopthemingmy.app/badge.svg)](https://stopthemingmy.app)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

![Light screenshot](data/shot.png#gh-light-mode-only)
![Dark screenshot](data/shot-dark.png#gh-dark-mode-only)

<p align="center"><a href='https://flathub.org/apps/details/io.github.lainsce.Countdown'><img width='240' alt='Download on Flathub' src='https://flathub.org/assets/badges/flathub-badge-en.png'/></a></p>

## 💝 Donations 

Would you like to support the development of this app to new heights? Then:

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/lainsce)

## 🛠️ Dependencies

Please make sure you have these dependencies first before building.

```bash
gtk4
libadwaita-1
libjson-glib
libgee-0.8
meson
vala
```

## 🏗️ Building

Simply clone this repo, then:

```bash
meson _build --prefix=/usr && cd _build
sudo ninja install
```
