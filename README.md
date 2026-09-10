# VizorUSB-N

Троллинг-флешка, собирается одним скриптом на любой ОС.
Вставил → окна хакера + смена разрешения + приколы. Вынул → всё закрылось, разрешение вернулось.

---

## 1. Что там собрать и как

В репозитории два билдера + описание. Оба создают на флешке одинаковые файлы:

| Файл | Для кого | Как запустить |
|---|---|---|
| `make_vizorusb.sh` | Linux / macOS / Windows (Git Bash/WSL) / Android (Termux) | `bash make_vizorusb.sh [/путь/к/флешке]` |
| `make_vizorusb.bat` | Windows 7/10/11 без Git Bash (двойной клик) | просто запустить или `make_vizorusb.bat E:` |
| `README.md` | — | это описание |

### make_vizorusb.sh (баш-сборщик)
1. Определяет ОС по `uname` (linux / mac / windows / android)
2. Если путь не передали аргументом — сам ищет флешку:
   - Linux: `/media/*/*`
   - macOS: `/Volumes/*`
   - Android: `/storage/*` (OTG)
   - Windows: **просит букву диска** (`E:`, `/e/`)
3. Создаёт папки `scripts/`, `scripts/linux/`, `scripts/windows/`, `install/`
4. Пишет каждый файл через `w` (катает содержимое из heredoc «дословно», без подстановок `$`)
5. Ставит права `chmod`: `.sh` — 755 (исполняемый), `.bat/.ps1/README` — 644

### make_vizorusb.bat (нативный Windows-сборщик)
- Работает на Win 7/10/11 **без Git Bash/WSL** — только `cmd` + встроенный `certutil`
- Все 24 файла пейлоада вшиты в бат как base64 (по 76 символов в строке)
- Сначала ищет флешку сам: `wmic logicaldisk where "drivetype=2" get deviceid` (съёмный диск)
- Не нашёл — спрашивает букву вручную
- Кладёт блока в `%TEMP%\vz.b64` → `certutil -decode` → файл на флешке → удаляет временный
- Проверено по байтам: base64 декодируется 1-в-1 в исходники

---

## 2. Что создаётся на флешке (24 файла)

### Корень флешки

| Файл | Что делает |
|---|---|
| `autorun.inf` | Windows-автозапуск: `OPEN=cmd.exe /c start.bat`. Иконка shell32, пункты контекстного меню |
| `start.bat` | Windows-лаунчер (см. ниже) |
| `start.sh` | Linux/macOS/Android-лаунчер (см. ниже) |
| `README.md` | короткое описание на самой флешке |

### Как работает `start.sh` (Linux/macOS/Android) — по шагам
1. `scripts/hack_linux.sh` — запускает 5 хакерских окон
2. `scripts/linux/02_reschange.sh` — меняет разрешение
3. `scripts/watchdog.sh` — запускается в фоне (`setsid`), следит за флешкой
4. `scripts/linux/01_prank.sh` — приколы

### Как работает `start.bat` (Windows)
1. Копирует `res_restore.ps1` в `%TEMP%` (чтобы рестор пережил вынимание флешки)
2. Запускает `scripts/watchdog.bat` в фоне (`start /min`)
3. `scripts/hack_windows.bat` — окна хакера
4. `scripts/windows/02_reschange.bat` — смена разрешения
5. `scripts/windows/01_prank.bat` — приколы

### `scripts/` — общее

| Файл | Что делает |
|---|---|
| `detect_os.sh` | Определяет ОС: Linux (читает `/etc/os-release`), macOS (`sw_vers`), Windows (uname), Android (`getprop`). Пишет `OS_NAME/OS_VERSION/OS_FAMILY` |
| `detect_os.bat` | То же на cmd: разбирает `ver` → Win 7/8/8.1/10/11 (якда ≤22000 = Win11) |
| `hack_linux.sh` | Открывает 5 окон H4CK: gnome-terminal → xterm → xfce4 → konsole → mate (первый, что есть). На macOS — окна `Terminal.app` через AppleScript. На Android — матрица прямо в Termux. Маркер процесса `H4CKFL4SH` для watchdog |
| `hack_screen.sh` | Содержимое хакерского окна: «UNAUTHORIZED ACCESS // VIZOR ROOTKIT», цикл `unlock --root --force`, `ACCESS GRANTED 0x…`, псевдо-листинг файлов зелёным `/proc/…/mem`, `/root/.ssh/id_rsa [HIT]` |
| `hack_windows.bat` | 6 окон cmd: 2 зелёного цвета (один на весь экран), красное, синее, матрица, и **2 окна `color 02`** с реальным `dir /s /b C:\Windows\*.dll / *.sys` — листинг файлов как на настоящем терминале |
| `watchdog.sh` | Фоновый сторож Linux: каждую секунду проверяет `mount | grep флешки`. Пропала → `pkill H4CKFL4SH`, читает `/tmp/vizor_res.txt` ИЗ ПАМЯТИ и возвращает разрешение через `xrandr`, завершается |
| `watchdog.bat` | То же на Windows: цикл `if exist %1autorun.inf`. Нет → запускает `%TEMP%\vizor_res_restore.ps1` (вернёт разрешение), убивает процессы с окнами H4CK/VIZOR-MENU |
| `res_restore.bat` | Обёртка для ручного возврата разрешения → гоняет `res_restore.ps1` |
| `shared/common.sh` | Пример общего скрипта: печатает дату/ОС |
| `shared/common.bat` | Вывод `%OS%` на cmd |

### `scripts/linux/`

| Файл | Что делает |
|---|---|
| `01_prank.sh` | Приколы: матрица из `0x…` + рандом, всплывашки через zenity («Обнаружена чрезмерная харизма», «Флешка знает твои секреты»…), тост `termux-toast` на Android. Выходит, если есть файл `OFF` |
| `02_reschange.sh` | Смена разрешения. Сохраняет текущее `ВЫХОД|РАЗРЕШЕНИЕ` в `/tmp/vizor_res.txt` (не перезаписывает), ставит `TARGET_RES` (по умолчанию 800x600); режима нет → визуальный скейл `--scale 0.5` |
| `03_resrestore.sh` | Возврат разрешения из `/tmp/vizor_res.txt` через `xrandr --mode CUR --scale 1x1`, чистит файл |

### `scripts/windows/`

| Файл | Что делает |
|---|---|
| `01_prank.bat` | Приколы: окно «H4CKED PROCCESSING...», автонабор текста через `WScript.Shell SendKeys` («PRIVET GLAVNYI GEROI!»), рандомно открывает калькулятор |
| `02_reschange.bat` | Задаёт `TARGET_W=800 TARGET_H=600` и зовёт PowerShell |
| `res_change.ps1` | Через WinAPI (`EnumDisplaySettings` + `ChangeDisplaySettings`) сохраняет оригинал в `%TEMP%\vizor_res.txt` и ставит 800x600 |
| `res_restore.ps1` | Читает `%TEMP%\vizor_res.txt` и возвращает исходное разрешение (разница: умеет вернуть и частоту) |

### `install/`

| Файл | Что делает |
|---|---|
| `linux-autorun.sh` | **Один раз, с sudo.** Находит UUID флешки (`lsblk`), пишет `/usr/local/bin/vizor-autorun.sh` (ждёт монтирования → запускает `start.sh` для GUI-пользователя с DISPLAY), создаёт udev-правило `/etc/udev/rules.d/99-vizor-usb.rules` по UUID и `sudoers.d/vizor-usb`. После этого флешка запускается **сама** при вставке |
| `uninstall-linux.sh` | Удаляет правило, помощник и sudoers → автозапуск снят |
| `windows-autorun.bat` | **От админа.** Определяет версию Windows (Win7/10/11), ставит `NoDriveTypeAutoRun=0` и включает AutoPlay. Печатает пошаговую инструкцию под версию |

---

## 3. Жизненный цикл прикола

```
вставил флешку
   │
   ├─ Linux: udev (если install запускался) → start.sh
   ├─ Windows: autorun.inf/AutoPlay → start.bat
   └─ вручную: ./start.sh  или  start.bat
   │
   ├─ 5 окон H4CK-R00T (или 6 на Windows)      ← hack_linux/hack_windows
   ├─ разрешение 1680x1050 → 800x600           ← 02_reschange
   ├─ приколы (матрица/тосты/калькулятор)       ← 01_prank
   │
вынул флешку
   │
   ├─ watchdog замечает, что mount пропал
   ├─ pkill H4CKFL4SH → окна закрылись
   └─ xrandr/PowerShell → разрешение вернулось
```

Все приколы — процессы в памяти. После перезагрузки ПК следов нет.

---

## 4. Настройка

| Что | Где изменить |
|---|---|
| Разрешение (Linux) | `TARGET_RES` в `scripts/linux/02_reschange.sh` |
| Разрешение (Windows) | `TARGET_W`/`TARGET_H` в `scripts/windows/02_reschange.bat` |
| Всегда выключить приколы | создать пустой файл `OFF` в корне флешки |

## 5. Безопасность

Всё обратимо: окна закрываются, разрешение возвращается. Ничего не ломает, не крадёт, не шпионит.