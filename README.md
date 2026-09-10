# VizorUSB-N

Проктор для USB: один скрипт собирает на флешке систему с авто-запуском троллинга на Linux / Windows / macOS / Android (Termux).

## Что делает

При вставке флешки на ПК жертвы:
1. Открываются 5 хакерских окон **H4CK-R00T** («unlock root», матрица, псевдо-взлом)
2. Разрешение экрана меняется на **800x600** (по логике карты захвата)
3. Открывается меню: **1) троллинг  2) полезное  3) выход**
4. Если вынуть флешку — окна закрываются и разрешение возвращается обратно (watchdog, рестор из памяти)

Управление троллингом: создай файл `OFF` в корне флешки → приколы выключены.

## Запуск (один скрипт на все ОС)

```bash
bash make_vizorusb.sh [/путь/к/флешке]
```

- **Linux / macOS** — обычная консоль
- **Windows** — Git Bash или WSL: `bash make_vizorusb.sh 'E:'`
- **Android** — Termux + USB OTG: `bash make_vizorusb.sh /storage/XXXX-XXXX`

Пример:
```bash
bash make_vizorusb.sh /media/randomuser/USB1G
```

## Что создаётся на флешке

```
USB-FLESH-N/
├── autorun.inf              # Windows автозапуск
├── start.bat                # Windows лаунчер
├── start.sh                 # Linux/macOS/Android лаунчер
├── install/
│   ├── linux-autorun.sh     # автозапуск через udev (sudo) — вставил и заработало
│   ├── uninstall-linux.sh   # снятие автозапуска
│   └── windows-autorun.bat  # включение AutoPlay (админ)
└── scripts/
    ├── detect_os.sh/.bat    # определение ОС
    ├── hack_linux.sh        # окна H4CK на Linux/macOS/Android
    ├── hack_screen.sh       # содержимое хакерских окон
    ├── hack_windows.bat     # окна H4CK на Windows
    ├── watchdog.sh/.bat     # вынул флешку → всё закрылось + рестор разрешения
    ├── menu.sh/.bat         # меню: троллинг / полезное
    ├── res_restore.bat      # вернуть разрешение (Windows)
    ├── shared/              # общие скрипты
    ├── linux/
    │   ├── 01_prank.sh      # приколы (матрица, zenity, termux-toast)
    │   ├── 02_reschange.sh  # смена разрешения (TARGET_RES)
    │   ├── 03_resrestore.sh # возврат разрешения
    │   ├── system_info.sh
    │   └── quick_setup.sh
    └── windows/
        ├── 01_prank.bat     # приколы (SendKeys, окна, calc)
        ├── 02_reschange.bat # смена разрешения (TARGET_W/TARGET_H)
        ├── res_change.ps1   # PowerShell ChangeDisplaySettings
        ├── res_restore.ps1  # PowerShell restore
        ├── system_info.bat
        └── quick_setup.bat
```

## Автозапуск (чтобы заработало само при вставке)

**Linux** (один раз, с sudo — создаёт udev-правило по UUID флешки):
```bash
sudo bash install/linux-autorun.sh
```
Потом вытащи и вставь флешку заново.

**Windows:**
```
Запустить install\windows-autorun.bat от Администратора
```
В окне AutoPlay при вставке выбрать «Запустить VizorUSB-N» → Всегда.
(Windows 10/11 полностью блокирует авто-запуск скриптов с USB — это максимум.)

## Настройки

| Что | Где |
|---|---|
| Разрешение (Linux) | `TARGET_RES` в `scripts/linux/02_reschange.sh` |
| Разрешение (Windows) | `TARGET_W`/`TARGET_H` в `scripts/windows/02_reschange.bat` |
| Выключить приколы | создать в корне флешки файл `OFF` |

## Безопасность

Всё обратимо и безвредно:
- окна H4CK можно просто закрыть (Ctrl+W / Alt+F4 / `pkill -f hack_screen`)
- разрешение возвращается при вынимании флешки или пунктом 3 в меню
- ничего не ломает, не крадёт, не шпионит