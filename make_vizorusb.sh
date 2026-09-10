#!/usr/bin/env bash
# ============================================================
#  make_vizorusb.sh
#  Один скрипт на все ОС (Linux / Windows / macOS).
#  Создаёт на USB-флешке тюнинг-пейлоад "VizorUSB-N":
#    - окна H4CK-R00T при вставке
#    - смена разрешения экрана (по логике карты захвата)
#    - меню: троллинг / полезное
#    - даже если вынуть флешку - всё закрывается
#  Запуск:  bash make_vizorusb.sh [/путь/к/флешке]
#  На Windows запускать из Git Bash / WSL.
# ============================================================

set -e

# ---------- определение ОС ----------
detect_os() {
    if [ "$(uname -o 2>/dev/null)" = "Android" ] || [ -n "$PREFIX" ]; then
        echo "android"; return
    fi
    case "$(uname -s)" in
        Linux*)   echo "linux" ;;
        Darwin*)  echo "mac" ;;
        MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
        *)        echo "linux" ;;
    esac
}
HOST_OS="$(detect_os)"
echo ">>> Хост-ОС: $HOST_OS"

# ---------- выбор целевой папки ----------
TARGET=""
if [ -n "$1" ]; then
    TARGET="$1"
else
    # пробуем найти смонтированную флешку
    if [ "$HOST_OS" = "linux" ]; then
        TARGET="$(ls -dt /media/*/* 2>/dev/null | head -1 || true)"
    elif [ "$HOST_OS" = "android" ]; then
        TARGET="$(ls -dt /storage/*/ 2>/dev/null | grep -v emulated | head -1 || true)"
    elif [ "$HOST_OS" = "mac" ]; then
        TARGET="$(ls -dt /Volumes/* 2>/dev/null | head -1 || true)"
    else
        echo ">>> На Windows укажи путь к флешке: bash make_vizorusb.sh 'E:'"
        read -r -p ">>> Путь к флешке (например E: или /e/): " TARGET
    fi
fi

[ -z "$TARGET" ] && { echo "ОШИБКА: не указана папка назначения."; exit 1; }
[ -d "$TARGET" ] || { echo "ОШИБКА: $TARGET не существует."; exit 1; }

echo ">>> Цель: $TARGET"
mkdir -p "$TARGET/scripts/linux" "$TARGET/scripts/windows" "$TARGET/scripts/shared" "$TARGET/install"

# ---------- помощник записи файла ----------
w() { # w <подпапка> <имя> <режим>  ... содержимое из stdin
    local dir="$1" name="$2" mode="$3"
    mkdir -p "$TARGET/$dir"
    cat > "$TARGET/$dir/$name"
    chmod "$mode" "$TARGET/$dir/$name" 2>/dev/null || true
    echo "  + $dir/$name"
}

# ============================================================
# КОРЕНЬ
# ============================================================

w . autorun.inf 644 <<'EOF'
[autorun]
label=VizorUSB-N
icon=shell32.dll,4
OPEN=cmd.exe /c start.bat
action=%D0%97%D0%B0%D0%BF%D1%83%D1%81%D1%82%D0%B8%D1%82%D1%8C VizorUSB-N
DefaultLabel=%D0%97%D0%B0%D0%BF%D1%83%D1%81%D1%82%D0%B8%D1%82%D1%8C VizorUSB-N
shell\scripts=VizorUSB-N Scripts
shell\scripts\command=cmd.exe /c start.bat
shell\explore=Open Explorer
shell\explore\command=explorer.exe .
EOF

w . start.bat 755 <<'EOF'
@echo off
REM VizorUSB-N - Windows Launcher
chcp 65001 >nul 2>&1
set BASE=%~dp0

REM 1. watchdog (рестор разрешения ЗАРАНЕЕ в %TEMP% - флешка потом недоступна)
copy /y "%BASE%scripts\windows\res_restore.ps1" "%TEMP%\vizor_res_restore.ps1" >nul
start /min "" "%BASE%scripts\watchdog.bat" "%~d0"

REM 2. хакерские окна
call "%BASE%scripts\hack_windows.bat"

REM 3. смена разрешения (карта захвата)
call "%BASE%scripts\windows\02_reschange.bat"

REM 4. меню
call "%BASE%scripts\menu.bat"
exit /b 0
EOF

w . start.sh 755 <<'EOF'
#!/bin/bash
# VizorUSB-N - универсальный лаунчер (Linux/macOS)
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. хакерские окна
bash "$BASE/scripts/hack_linux.sh" "$BASE"

# 2. смена разрешения (карта захвата)
bash "$BASE/scripts/linux/02_reschange.sh"

# 3. watchdog: вынул флешку -> всё закрылось
setsid bash "$BASE/scripts/watchdog.sh" "$BASE" </dev/null >/dev/null 2>&1 &

# 4. меню
bash "$BASE/scripts/menu.sh" "$BASE"
exit 0
EOF

# ============================================================
# SCRIPTS (общая логика)
# ============================================================

w scripts detect_os.sh 755 <<'EOF'
#!/bin/bash
# Определение ОС
OS_NAME="Unknown"; OS_VERSION=""; OS_FAMILY=""
case "$(uname -s)" in
    Linux*)
        OS_FAMILY="linux"
        if [ -f /etc/os-release ]; then . /etc/os-release; OS_NAME="$NAME"; OS_VERSION="$VERSION_ID";
        elif [ -f /etc/lsb-release ]; then . /etc/lsb-release; OS_NAME="$DISTRIB_ID"; OS_VERSION="$DISTRIB_RELEASE"; fi
        ;;
    Darwin*)
        OS_FAMILY="mac"
        OS_NAME="macOS"; OS_VERSION="$(sw_vers -productVersion 2>/dev/null || echo unknown)"
        ;;
    Android*)
        OS_FAMILY="android"; OS_NAME="Android"
        OS_VERSION="$(getprop ro.build.version.release 2>/dev/null || echo unknown)"
        ;;
    MINGW*|MSYS*|CYGWIN*)
        OS_FAMILY="windows"; OS_NAME="Windows"; OS_VERSION="$(uname -r)"
        ;;
esac
if [ -z "$OS_FAMILY" ] || [ "$(uname -o 2>/dev/null)" = "Android" ] || [ -n "$PREFIX" ]; then
    OS_FAMILY="android"; OS_NAME="Android"
    OS_VERSION="$(getprop ro.build.version.release 2>/dev/null || echo unknown)"
fi
export OS_NAME OS_VERSION OS_FAMILY
EOF

w scripts detect_os.bat 644 <<'EOF'
@echo off
setlocal EnableDelayedExpansion
for /f "tokens=4 delims= " %%v in ('ver') do set V=%%v
set V=!V:]
for /f "tokens=1,2,3 delims=." %%a in ("!V!") do ( set MAJ=%%a & set MIN=%%b & set BL=%%c )
set WIN_VER=unknown
if "%MAJ%"=="6" if "%MIN%"=="1" set WIN_VER=Windows 7
if "%MAJ%"=="6" if "%MIN%"=="2" set WIN_VER=Windows 8
if "%MAJ%"=="6" if "%MIN%"=="3" set WIN_VER=Windows 8.1
if "%MAJ%"=="10" set WIN_VER=Windows 10
if "%MAJ%"=="10" if "%MIN%"=="0" if %BL% GEQ 22000 set WIN_VER=Windows 11
echo Windows: !WIN_VER! ^| ПК: %COMPUTERNAME% ^| Юзер: %USERNAME%
endlocal
EOF

# ---------- хакерские окна ----------
w scripts hack_linux.sh 755 <<'EOF'
#!/bin/bash
# Открывает окна H4CK-R00T на Linux и macOS
BASE="$1"
SCREEN="$BASE/scripts/hack_screen.sh"
chmod +x "$SCREEN" 2>/dev/null

# Android (Termux): выводим матрицу прямо в терминал
if [ -n "$PREFIX" ] || [ "$(uname -o 2>/dev/null)" = "Android" ]; then
    bash "$SCREEN"
    exit 0
fi

# macOS: открываем окна Terminal.app через osascript
if [ "$(uname -s)" = "Darwin" ]; then
    for i in 1 2 3 4 5; do
        osascript -e "tell application \"Terminal\" to do script \"H4CKFL4SH=1 bash '$SCREEN'\"" >/dev/null 2>&1
        sleep 0.5
    done
    exit 0
fi

launch() {
    if command -v gnome-terminal &>/dev/null; then
        gnome-terminal -- bash -c "H4CKFL4SH=1 bash '$SCREEN'" &
    elif command -v xterm &>/dev/null; then
        xterm -bg black -fg green -title 'H4CK-R00T' -e bash -c "H4CKFL4SH=1 bash '$SCREEN'" &
    elif command -v xfce4-terminal &>/dev/null; then
        xfce4-terminal --title 'H4CK-R00T' -e "bash -c 'H4CKFL4SH=1 bash \"$SCREEN\"'" &
    elif command -v konsole &>/dev/null; then
        konsole -e bash -c "H4CKFL4SH=1 bash '$SCREEN'" &
    elif command -v mate-terminal &>/dev/null; then
        mate-terminal -e "bash -c 'H4CKFL4SH=1 bash \"$SCREEN\"'" &
    fi
}
for i in 1 2 3 4 5; do launch; sleep 0.6; done
exit 0
EOF

w scripts hack_screen.sh 755 <<'EOF'
#!/bin/bash
# Содержимое хакерских окон
printf '\e[2J\e[0;0H\e[32m'
printf '=============================================\n'
printf '   UNAUTHORIZED ACCESS  // VIZOR ROOTKIT\n'
printf '=============================================\n'
i=0
while :; do
    i=$((i + 1))
    printf 'root@h4ck:~# unlock --root --force [%s]\n' "$i"
    sleep 0.2
    printf '  [+] ACCESS GRANTED 0x%04X\n' $((RANDOM % 65536))
    printf '  [+] PING mainframe ...      %s ms\n' $((RANDOM % 100 + 1))
    sleep 0.3
    printf 'root@h4ck:~# bypass --security --level full [%s]\n' "$i"
    printf '  [!] CRITICAL Bypassed -> %s%%\n' $((RANDOM % 100))
    printf '  [!] unlock root >>> OK\n'
    sleep 0.25
    printf 'root@h4ck:~# whoami -> root#VIZOR\n'
    sleep 0.3
done
EOF

w scripts hack_windows.bat 644 <<'EOF'
@echo off
chcp 65001 >nul 2>&1
start "H4CK-R00T" cmd /k "color 0A && title H4CK-R00T && cls && echo ============================================= && echo    UNAUTHORIZED ACCESS // VIZOR ROOTKIT && echo ============================================= && for /l %%i in (1,1,99) do @( echo root@h4ck:~# unlock --root --force [%%i] ^& echo   [+] ACCESS GRANTED 0x%%random%% ^& ping -n 2 127.0.0.1 ^>nul )"
start "H4CK-R00T" /MAX cmd /k "color 0C && title H4CK-R00T && cls && echo [!!!] SYSTEM COMPROMISED && for /l %%i in (1,1,99) do @( echo root@h4ck:~# decrypt_mainframe %%random%% bytes ^& ping -n 2 127.0.0.1 ^>nul )"
start "H4CK-R00T" cmd /k "color 09 && title H4CK-R00T && cls && echo root@h4ck:~# ss -tlnp && for /l %%i in (1,1,99) do @( echo PORT %%random%% :: OPEN ^& ping -n 2 127.0.0.1 ^>nul )"
start "H4CK-R00T" /MAX cmd /k "color 0A && title H4CK-R00T && cls && echo H4CKMATRIX && for /l %%i in (1,1,99) do @( echo %%random%% ^& echo %%random%% ^& ping -n 2 127.0.0.1 ^>nul )"
exit /b 0
EOF

# ---------- watchdog: следит за флешкой ----------
w scripts watchdog.sh 755 <<'EOF'
#!/bin/bash
# Если флешку вынули -> закрыть окна h4ck и вернуть разрешение.
# Рестор делается ИЗ ПАМЯТИ (/tmp), т.к. флешка уже размонтирована.
BASE="$1"

mounted() { mount 2>/dev/null | grep -qs " $BASE "; }
mounted || exit 0
while mounted; do sleep 1; done

pkill -f H4CKFL4SH 2>/dev/null
sleep 0.5

if [ -f /tmp/vizor_res.txt ]; then
    IFS='|' read -r VZ_OUT VZ_CUR < /tmp/vizor_res.txt
    if [ -n "$VZ_OUT" ] && command -v xrandr >/dev/null; then
        xrandr --output "$VZ_OUT" --mode "$VZ_CUR" --scale 1x1 2>/dev/null
    fi
    rm -f /tmp/vizor_res.txt
fi

kill -TERM "$(cat /tmp/vizor_menu.pid 2>/dev/null)" 2>/dev/null
rm -f /tmp/vizor_menu.pid
exit 0
EOF

w scripts watchdog.bat 644 <<'EOF'
@echo off
rem Если флешку вынули - закрыть окна и вернуть разрешение из %TEMP%
chcp 65001 >nul 2>&1
:loop
if not exist "%1autorun.inf" goto die
ping -n 2 127.0.0.1 >nul
goto loop
:die
if exist "%TEMP%\vizor_res_restore.ps1" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP%\vizor_res_restore.ps1"
)
powershell -NoProfile -Command "Get-Process | Where-Object { $_.MainWindowTitle -match 'H4CK|VIZOR-MENU' } | Stop-Process -Force" 2>nul
exit /b 0
EOF

w scripts res_restore.bat 644 <<'EOF'
@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0windows\res_restore.ps1"
exit /b 0
EOF

# ---------- меню ----------
w scripts menu.sh 755 <<'EOF'
#!/bin/bash
BASE="$1"
echo $$ > /tmp/vizor_menu.pid
while true; do
    clear
    echo "============================================"
    echo "      VIZORUSB-N   VYBERI REGIM"
    echo "============================================"
    echo "  1) TROLLING    (prilokoly)"
    echo "  2) POLEZNOE    (info / nastroyka)"
    echo "  3) VYKHOD"
    echo "============================================"
    read -r -p "> " CHOICE
    case "$CHOICE" in
        1)
            bash "$BASE/scripts/linux/01_prank.sh"
            read -r -p "Enter..."
            ;;
        2)
            bash "$BASE/scripts/linux/system_info.sh"
            bash "$BASE/scripts/linux/quick_setup.sh"
            read -r -p "Enter..."
            ;;
        3)
            rm -f /tmp/vizor_menu.pid
            bash "$BASE/scripts/linux/03_resrestore.sh" 2>/dev/null
            exit 0
            ;;
    esac
done
EOF

w scripts menu.bat 644 <<'EOF'
@echo off
chcp 65001 >nul 2>&1
title VIZOR-MENU
set BASE=%~dp0..
:menu
cls
echo ============================================
echo     VIZORUSB-N   VYBERI REGIM
echo ============================================
echo   1) TROLLING   (prilokoly)
echo   2) POLEZNOE   (info / nastroyka)
echo   3) VYKHOD
echo ============================================
set /p ch=^>
if "%ch%"=="1" goto troll
if "%ch%"=="2" goto useful
if "%ch%"=="3" goto quit
goto menu
:troll
call "%BASE%\scripts\windows\01_prank.bat"
pause
goto menu
:useful
call "%BASE%\scripts\windows\system_info.bat"
pause
goto menu
:quit
call "%BASE%\scripts\res_restore.bat"
exit /b 0
EOF

# ============================================================
# SHARED
# ============================================================
w scripts/shared common.sh 755 <<'EOF'
#!/bin/bash
echo "=== Common (shared) ==="
echo "[$(date '+%Y-%m-%d %H:%M:%S')] common.sh loaded on $(uname -s)"
EOF

w scripts/shared common.bat 644 <<'EOF'
@echo off
echo === Common (shared) ===
echo loaded on %OS%
EOF

# ============================================================
# LINUX
# ============================================================
w scripts/linux 01_prank.sh 755 <<'EOF'
#!/bin/bash
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
if [ -f "$BASE/OFF" ]; then exit 0; fi
clear
echo "PRANK MODE | Активен"
echo -e "\e[32m"
for i in $(seq 1 25); do printf '0x%04X %s\n' $((RANDOM % 65536)) "$(od -An -N2 -tx1 /dev/urandom 2>/dev/null | tr -d ' ')"; sleep 0.05; done
echo -e "\e[0m"
if command -v zenity &>/dev/null; then
    case $((RANDOM % 3)) in
        0) (zenity --warning --width=300 --text="Обнаружена чрезмерная харизма пользователя!" &) ;;
        1) (zenity --info --width=300 --text="Флешка знает твои секреты" &) ;;
        2) (zenity --warning --text="Linux подозревает, что ты любишь cats" &) ;;
    esac
fi
if command -v termux-toast &>/dev/null; then
    case $((RANDOM % 3)) in
        0) termux-toast "Обнаружена чрезмерная харизма пользователя!" ;;
        1) termux-toast "Флешка знает твои секреты" ;;
        2) termux-toast "Обнаружен сменный носитель" ;;
    esac
fi
exit 0
EOF

w scripts/linux 02_reschange.sh 755 <<'EOF'
#!/bin/bash
# Смена разрешения по логике карты захвата (Linux/macOS)
# На mac (нет xrandr) просто молча выходит.
TARGET_RES="${TARGET_RES:-800x600}"
STATE_FILE=/tmp/vizor_res.txt
command -v xrandr >/dev/null || exit 0
[ -n "$DISPLAY" ] || exit 0
OUT=$(xrandr --query 2>/dev/null | awk '/ connected/{print $1; exit}')
CUR=$(xrandr --query 2>/dev/null | awk '/\*/{print $1; exit}')
[ -n "$OUT" ] && [ -n "$CUR" ] || exit 0
if [ ! -f "$STATE_FILE" ]; then
    echo "$OUT|$CUR" > "$STATE_FILE"
fi
if ! xrandr --output "$OUT" --mode "$TARGET_RES" 2>/dev/null; then
    xrandr --output "$OUT" --scale 0.5x0.5 --mode "$CUR" 2>/dev/null
fi
exit 0
EOF

w scripts/linux 03_resrestore.sh 755 <<'EOF'
#!/bin/bash
STATE_FILE=/tmp/vizor_res.txt
command -v xrandr >/dev/null || exit 0
[ -f "$STATE_FILE" ] || exit 0
IFS='|' read -r OUT CUR < "$STATE_FILE"
[ -n "$OUT" ] && [ -n "$CUR" ] && xrandr --output "$OUT" --mode "$CUR" --scale 1x1 2>/dev/null
rm -f "$STATE_FILE"
exit 0
EOF

w scripts/linux system_info.sh 755 <<'EOF'
#!/bin/bash
echo "=== System Info (Linux/macOS) ==="
echo "--- OS ---"
cat /etc/os-release 2>/dev/null | grep -E "^(NAME|VERSION)=" || sw_vers 2>/dev/null || echo unknown
echo "--- Kernel ---"
uname -a
[ -f /proc/cpuinfo ] && grep "model name" /proc/cpuinfo | head -1
[ -f /proc/meminfo ] && grep MemTotal /proc/meminfo
echo "--- Disks ---"
df -h 2>/dev/null | head -8 || lsblk 2>/dev/null
EOF

w scripts/linux quick_setup.sh 755 <<'EOF'
#!/bin/bash
echo "=== Quick Setup ==="
if command -v apt &>/dev/null; then sudo apt update -qq 2>/dev/null; echo "apt: OK";
elif command -v pacman &>/dev/null; then sudo pacman -Sy --noconfirm 2>/dev/null; echo "pacman: OK";
elif command -v brew &>/dev/null; then echo "brew есть (обновление пропущено)"; fi
echo "Done."
EOF

# ============================================================
# WINDOWS
# ============================================================
w scripts/windows 01_prank.bat 644 <<'EOF'
@echo off
setlocal enabledelayedexpansion
if exist "%~dp0..\..\OFF" exit /b 0
echo PRANK MODE ^| Active
start "" cmd /k "color 0A & title H4CKED & echo PROCESSING... & for /l %%i in (1,1,15) do @echo 0x!random! %%i && ping -n 2 127.0.0.1 >nul"
powershell -NoProfile -Command "Start-Sleep -Milliseconds 500; $ws=New-Object -ComObject WScript.Shell; 1..3|ForEach-Object{ $ws.SendKeys('PRIVET GLAVNYI GEROI! '); Start-Sleep -Milliseconds 300 }; exit" >nul 2>&1
set /a N=%random% %% 2 + 1
if "%N%"=="1" start "" calc.exe
endlocal
EOF

w scripts/windows 02_reschange.bat 644 <<'EOF'
@echo off
set TARGET_W=800
set TARGET_H=600
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0res_change.ps1" %TARGET_W% %TARGET_H%
exit /b 0
EOF

w scripts/windows res_change.ps1 644 <<'EOF'
param([int]$W, [int]$H)
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
namespace WAPI {
  [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Ansi)]
  public struct DEVMODE {
    [MarshalAs(UnmanagedType.ByValTStr, SizeConst=32)] public string dmDeviceName;
    public short dmSpecVersion; public short dmDriverVersion; public short dmSize;
    public short dmDriverExtra; public int dmFields; public int dmPositionX; public int dmPositionY;
    public int dmDisplayOrientation; public int dmDisplayFixedOutput; public short dmColor;
    public short dmDuplex; public short dmYResolution; public short dmTTOption; public short dmCollate;
    [MarshalAs(UnmanagedType.ByValTStr, SizeConst=32)] public string dmFormName;
    public short dmLogPixels; public int dmBitsPerPel; public int dmPelsWidth; public int dmPelsHeight;
    public int dmDisplayFlags; public int dmDisplayFrequency; public int dmICMMethod; public int dmICMIntent;
    public int dmMediaType; public int dmDitherType; public int dmReserved1; public int dmReserved2;
    public int dmPanningWidth; public int dmPanningHeight;
  }
  public class U {
    [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern bool EnumDisplaySettings(string dev, int mode, ref DEVMODE dm);
    [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int ChangeDisplaySettings(ref DEVMODE dm, int flags);
  }
}
'@
$dm = New-Object WAPI.DEVMODE
$dm.dmSize = [System.Runtime.InteropServices.Marshal]::SizeOf([type][WAPI.DEVMODE])
[WAPI.U]::EnumDisplaySettings($null, -1, [ref]$dm) | Out-Null
if (-not (Test-Path "$env:TEMP\vizor_res.txt")) {
    "$($dm.dmPelsWidth);$($dm.dmPelsHeight);$($dm.dmDisplayFrequency)" | Out-File "$env:TEMP\vizor_res.txt" -Encoding ascii
}
$dm.dmPelsWidth = $W
$dm.dmPelsHeight = $H
[WAPI.U]::ChangeDisplaySettings([ref]$dm, 0) | Out-Null
EOF

w scripts/windows res_restore.ps1 644 <<'EOF'
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
namespace WAPI {
  [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Ansi)]
  public struct DEVMODE {
    [MarshalAs(UnmanagedType.ByValTStr, SizeConst=32)] public string dmDeviceName;
    public short dmSpecVersion; public short dmDriverVersion; public short dmSize;
    public short dmDriverExtra; public int dmFields; public int dmPositionX; public int dmPositionY;
    public int dmDisplayOrientation; public int dmDisplayFixedOutput; public short dmColor;
    public short dmDuplex; public short dmYResolution; public short dmTTOption; public short dmCollate;
    [MarshalAs(UnmanagedType.ByValTStr, SizeConst=32)] public string dmFormName;
    public short dmLogPixels; public int dmBitsPerPel; public int dmPelsWidth; public int dmPelsHeight;
    public int dmDisplayFlags; public int dmDisplayFrequency; public int dmICMMethod; public int dmICMIntent;
    public int dmMediaType; public int dmDitherType; public int dmReserved1; public int dmReserved2;
    public int dmPanningWidth; public int dmPanningHeight;
  }
  public class U {
    [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern bool EnumDisplaySettings(string dev, int mode, ref DEVMODE dm);
    [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int ChangeDisplaySettings(ref DEVMODE dm, int flags);
  }
}
'@
$saveFile = "$env:TEMP\vizor_res.txt"
if (-not (Test-Path $saveFile)) { exit }
$line = Get-Content $saveFile | Select-Object -First 1
if (-not $line) { exit }
$p = $line.Split(';'); if ($p.Length -lt 2) { exit }
$dm = New-Object WAPI.DEVMODE
$dm.dmSize = [System.Runtime.InteropServices.Marshal]::SizeOf([type][WAPI.DEVMODE])
[WAPI.U]::EnumDisplaySettings($null, -1, [ref]$dm) | Out-Null
$dm.dmPelsWidth = [int]$p[0]; $dm.dmPelsHeight = [int]$p[1]
if ($p.Length -gt 2) { $dm.dmDisplayFrequency = [int]$p[2] }
[WAPI.U]::ChangeDisplaySettings([ref]$dm, 0) | Out-Null
Remove-Item $saveFile -ErrorAction SilentlyContinue
EOF

w scripts/windows system_info.bat 644 <<'EOF'
@echo off
echo === System Info (Windows) ===
systeminfo | findstr /B "OS"
wmic cpu get Name /value 2>nul | findstr "Name="
ipconfig | findstr /I "IPv4"
wmic logicaldisk get DeviceID,Size /value 2>nul | findstr "DeviceID Size="
EOF

w scripts/windows quick_setup.bat 644 <<'EOF'
@echo off
echo === Quick Setup (Windows) ===
del /q /f /s "%TEMP%\*" 2>nul
echo Temp cleaned.
echo Done.
pause
EOF

# ============================================================
# INSTALL
# ============================================================
w install linux-autorun.sh 755 <<'EOF'
#!/bin/bash
# Настройка автозапуска на Linux (udev) - один раз с sudo
if [ "$(id -u)" -ne 0 ]; then echo "Запускай: sudo bash $0"; exit 1; fi
SCRIPT_PATH="$(readlink -f "$0")"
USB_DIR="$(dirname "$(dirname "$SCRIPT_PATH")")"
USB_DEV="$(findmnt -no SOURCE "$USB_DIR" 2>/dev/null)"
UUID="$(lsblk -no UUID "$USB_DEV" 2>/dev/null || blkid -s UUID -o value "$USB_DEV" 2>/dev/null)"
UID_NUM="$(ls /run/user/ 2>/dev/null | grep -E '^[0-9]+$' | head -1)"
GUI_USER="$(getent passwd "$UID_NUM" | cut -d: -f1)"
DISP=":$(ls /tmp/.X11-unix/ 2>/dev/null | head -1 | sed 's/X//')"
[ -z "$DISP" ] && DISP=":0"
[ -z "$UUID" ] && { echo "UUID не найден"; exit 1; }

cat > /usr/local/bin/vizor-autorun.sh <<XEOF
#!/bin/bash
UUID="$UUID"; GUI_USER="$GUI_USER"; DISP="$DISP"
for i in \$(seq 1 15); do
    M="\$(lsblk -no MOUNTPOINTS /dev/disk/by-uuid/\$UUID 2>/dev/null)"
    [ -n "\$M" ] && break; sleep 1
done
[ -f "\$M/start.sh" ] || exit 0
sudo -u "\$GUI_USER" env DISPLAY="\$DISP" nohup bash "\$M/start.sh" >/dev/null 2>&1 &
exit 0
XEOF
chmod 755 /usr/local/bin/vizor-autorun.sh
cat > /etc/udev/rules.d/99-vizor-usb.rules <<XEOF
ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_UUID}=="$UUID", RUN+="/usr/local/bin/vizor-autorun.sh"
XEOF
udevadm control --reload-rules 2>/dev/null
echo "$GUI_USER ALL=(ALL) NOPASSWD: /usr/local/bin/vizor-autorun.sh" > /etc/sudoers.d/vizor-usb
chmod 440 /etc/sudoers.d/vizor-usb
echo "=== Готово: вставь флешку ещё раз - всё запустится само ==="
echo "Удаление: sudo bash $USB_DIR/install/uninstall-linux.sh"
EOF

w install uninstall-linux.sh 755 <<'EOF'
#!/bin/bash
if [ "$(id -u)" -ne 0 ]; then echo "Запускай: sudo bash $0"; exit 1; fi
rm -f /usr/local/bin/vizor-autorun.sh /etc/udev/rules.d/99-vizor-usb.rules /etc/sudoers.d/vizor-usb
udevadm control --reload-rules 2>/dev/null
echo "Автозапуск удалён."
EOF

w install windows-autorun.bat 644 <<'EOF'
@echo off
REM Настройка автозапуска в зависимости от версии
REM Win7 / Win10 / Win11 работают по-разному (ниже)
net session >nul 2>&1
if errorlevel 1 ( echo. & echo ЗАПУСТИ от Администратора! & pause & exit /b 1 )

REM ----- определение версии Windows -----
set WIN_VER=unknown
for /f "tokens=4 delims= " %%v in ('ver') do set V=%%v
set V=%V:]
for /f "tokens=1,2,3 delims=." %%a in ("%V%") do ( set MAJ=%%a & set MIN=%%b & set BL=%%c )
if "%MAJ%"=="6" if "%MIN%"=="1" set WIN_VER=Windows 7
if "%MAJ%"=="6" if "%MIN%"=="3" set WIN_VER=Windows 8.1
if "%MAJ%"=="10" set WIN_VER=Windows 10
if "%MAJ%"=="10" if "%MIN%"=="0" if %BL% GEQ 22000 set WIN_VER=Windows 11

echo.
echo ==========================================
echo   Обнаружено: %WIN_VER%
echo ==========================================

REM ----- общие действия для 7/10/11 -----
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveTypeAutoRun /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveTypeAutoRun /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v DisableAutoplay /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] NoDriveTypeAutoRun = 0 (автозапуск разрешён)
echo [OK] AutoPlay включены
echo.

if "%WIN_VER%"=="Windows 7" (
    echo --- Windows 7: автозапуск РАБОТАЕТ из коробки ---
    echo     autorun.inf сработает сразу при вставке.
    echo     Ничего больше не нужно. Вставь флешку.
) else if "%WIN_VER%"=="Windows 10" (
    echo --- Windows 10: автозапуск скриптов заблокирован ---
    echo     Реестр уже снял блокировку. Теперь:
    echo     1) Вытащи и вставь флешку
    echo     2) В окне AutoPlay выбери: "Запустить VizorUSB-N"
    echo     3) Отметь галочку: "Всегда делать это"
    echo     Меню Autorun появится и при ручном запуске star.bat.
) else if "%WIN_VER%"=="Windows 11" (
    echo --- Windows 11: автозапуск жёстко ограничен ---
    echo     НЕЛЬЗЯ отключить полностью. Порядок:
    echo     1) Вытащи и вставь флешку
    echo     2) В окне AutoPlay выбери: "Запустить VizorUSB-N" -> Всегда
    echo     3) Если окно не появилось - Параметры-Система-Уведомления
    echo        "Стандартные настройки автозапуска" - включи Автозапуск
    echo     Запасной вариант: один раз запусти start.bat вручную
) else (
    echo Неизвестная версия Windows. Запусти start.bat вручную.
)

echo.
pause
EOF

# ============================================================
# README
# ============================================================
w . README.md 644 <<'EOF'
# VizorUSB-N

Троллинг-флешка: вставил → окна H4CK-R00T + смена разрешения + меню.
Вынул → всё закрывается и разрешение возвращается.

## Один скрипт на все ОС

```bash
bash make_vizorusb.sh [/путь/к/флешке]
```

- Linux, macOS: обычный bash
- Windows: Git Bash или WSL (`bash make_vizorusb.sh 'E:'`)

## Автозапуск
- **Linux**: `sudo bash install/linux-autorun.sh` (udev), потом вставь заново
- **Windows**: `install\windows-autorun.bat` от админа
  (установщик сам определит версию: Win7 - автозапуск сразу,
   Win10/11 - снимает блокировку + выбор в окне AutoPlay "Всегда")

## Смена разрешения
`TARGET_RES` (Linux) в `scripts/linux/02_reschange.sh`,
`TARGET_W/TARGET_H` (Windows) в `scripts/windows/02_reschange.bat`.

## Отключить приколы
Создай файл `OFF` в корне флешки.

## Безопасность
Всё обратимо: окна закрываются, разрешение возвращается при вынимании
или через меню (3). Ничего не ломает и не шпионит.
EOF

# ============================================================
# ФИНАЛ
# ============================================================
echo ""
echo "=============================================="
echo "  VizorUSB-N создан в: $TARGET"
echo "  Вставь флешку и вставь заново (или запусти start.sh / start.bat)"
echo "  Автозапуск: install/linux-autorun.sh или install/windows-autorun.bat"
echo "=============================================="