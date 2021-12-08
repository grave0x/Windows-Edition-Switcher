@echo off

set "uiver=1.0"
title Windows Edition Switcher %uiver%
mode con cols=86 lines=30

net session >nul 2>&1
if %errorLevel% == 0 (
    GOTO pac
) else (
    ECHO This script requires administrator privileges.
    ECHO To do so, right-click on this script and select 'Run as administrator'
    GOTO end
)
:pac
set "te_cnt=0"
set "te=for /L %%n in (1 1 ^!te_cnt^!) DO echo ^!te[%%n]^!"
set "_te=for /f "tokens=4" %%t in ('dism /online /english /Get-TargetEditions ^| findstr /i /c:"Target Edition "')do set /a te_cnt+=1 && set "te[!te_cnt!]=%%t""
set "_eid=for /f "skip=2 tokens=2*" %%G in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID 2^>nul') do set "eid=%%H""
set "_pn=for /f "skip=2 tokens=2*" %%G in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName 2^>nul') do set "pn=%%H""
set "_pkc=for /f "tokens=4" %%a in ('cscript slmgr.vbs /dlv ^| findstr /i /c:"Product Key Channel"') do set "pkc=%%a""
set "_c1=if not '%choice%'=='' set choice=%choice:~0,1%"
set "_c2=if not '%choice%'=='' set choice=%choice:~0,2%"
set "ce=ECHO [4mCurrent edition[0m:"
set "ss=ECHO [4mSwitches supported[0m:"
set "secpk=GOTO switcheditioncpk"

for /f "tokens=4 delims=[]. " %%G in ('ver') do set osver=%%G
for /f "tokens=6 delims=[]. " %%L in ('ver') do set osbuild=%%L
if exist "%SystemRoot%\Servicing\Packages\Microsoft-Windows-Server*Edition~*.mum" (
    set ostype=Server
)
if not defined ostype set ostype=Client

%_eid%
if %osver% LSS 10 (
    ECHO   This Windows build version is not supported by this script.
    GOTO end
)
if [%ostype%]==[Server] (
    ECHO   Windows Server editions are not currently supported by this script.
    GOTO end
)
if %osbuild% LSS 19044 if [%eid%]==[EnterpriseS] (
    ECHO   This Windows LTSB/LTSC build version is not supported by this script.
    GOTO end
)

:start
setlocal enabledelayedexpansion
CLS
ECHO.
ECHO.
ECHO                            [1m****************************[0m    
ECHO                            [1m* Windows Edition Switcher *[0m
ECHO                            [1m****************************[0m
%_pn% & %_eid% & %_pkc% & %_te%
CLS

:editions
%ce%
ECHO [1m%pn% (%eid%) [%pkc%][0m
ECHO.
%ss%
%te%
ECHO.
ECHO.

ECHO [4mSelect one of the following[0m:
ECHO 1. Home (Core)
ECHO 2. Professional
ECHO 3. Education
ECHO 4. Enterprise
ECHO 5. Exit
ECHO.

choice /c 12345 /n >nul 2>&1
if %errorlevel%==1 GOTO homeedition
if %errorlevel%==2 GOTO proedition
if %errorlevel%==3 GOTO eduedition
if %errorlevel%==4 GOTO enterpriseedition
if %errorlevel%==5 GOTO end

:homeedition
CLS
%ss%
%te%
ECHO.
ECHO           [1m - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ECHO          ^| Home (Core)                   ^| 1. [Retail] ^| 2. [Volume:GVLK] ^|
ECHO          ^| Home (Core) N                 ^| 3. [Retail] ^| 4. [Volume:GVLK] ^|
ECHO          ^| Home Single Language          ^| 5. [Retail] ^| 6. [Volume:GVLK] ^|
ECHO          ^| Home Country Specific (China) ^| 7. [Retail] ^| 8. [Volume:GVLK] ^|
ECHO            - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -[0m
ECHO.

:askhomeedition
set choice=
set /p choice=Enter Home edition number, [b]ack or [e]xit: 
ECHO.
%_c2%
if '%choice%'=='1' GOTO core
if '%choice%'=='2' GOTO gvlkcore
if '%choice%'=='3' GOTO coren
if '%choice%'=='4' GOTO gvlkcoren
if '%choice%'=='5' GOTO coresinglelanguage
if '%choice%'=='6' GOTO gvlkcoresinglelanguage
if '%choice%'=='7' GOTO corecountryspecific
if '%choice%'=='8' GOTO gvlkcorecountryspecific
if /i '%choice%'=='b' CLS & GOTO editions
if /i '%choice%'=='back' CLS & GOTO editions
if /i '%choice%'=='e' GOTO end
if /i '%choice%'=='exit' GOTO end
if not defined '%choice%' (
    ECHO Your choice is not valid. Please try again.
    GOTO askhomeedition
)
GOTO askhomeedition

:proedition
CLS
%ss%
%te%
ECHO.
ECHO           [1m - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ECHO          ^| Professional                 ^| 1.  [Retail] ^| 2.  [Volume:GVLK] ^|
ECHO          ^| Professional N               ^| 3.  [Retail] ^| 4.  [Volume:GVLK] ^|
ECHO          ^| Pro Single Language          ^| 5.  [Retail] ^|                   ^|
ECHO          ^| Pro Country Specific (China) ^| 7.  [Retail] ^|                   ^|
ECHO          ^| Professional Workstation     ^| 9.  [Retail] ^| 10. [Volume:GVLK] ^|
ECHO          ^| Professional Workstation N   ^| 11. [Retail] ^| 12. [Volume:GVLK] ^|
ECHO            - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -[0m
ECHO.

:askproedition
set choice=
set /p choice=Enter Professional edition number, [b]ack or [e]xit: 
ECHO.
%_c2%
if '%choice%'=='1' GOTO professional
if '%choice%'=='2' GOTO gvlkprofessional
if '%choice%'=='3' GOTO professionaln
if '%choice%'=='4' GOTO gvlkprofessionaln
if '%choice%'=='5' GOTO professionalsinglelanguage
if '%choice%'=='7' GOTO professionalcountryspecific
if '%choice%'=='9' GOTO professionalworkstation
if '%choice%'=='10' GOTO gvlkprofessionalworkstation
if '%choice%'=='11' GOTO professionalworkstationn
if '%choice%'=='12' GOTO gvlkprofessionalworkstationn
if /i '%choice%'=='b' CLS & GOTO editions
if /i '%choice%'=='back' CLS & GOTO editions
if /i '%choice%'=='e' GOTO end
if /i '%choice%'=='exit' GOTO end
if not defined '%choice%' (
    ECHO Your choice is not valid. Please try again.
    GOTO askproedition
)

:eduedition
CLS
%ss%
%te%
ECHO.
ECHO             [1m - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ECHO            ^| Education                ^| 1.  [Retail] ^| 2.  [Volume:GVLK] ^|
ECHO            ^| Education N              ^| 3.  [Retail] ^| 4.  [Volume:GVLK] ^|
ECHO            ^| Professional Education   ^| 5.  [Retail] ^| 6.  [Volume:GVLK] ^|
ECHO            ^| Professional Education N ^| 7.  [Retail] ^| 8.  [Volume:GVLK] ^|
ECHO            ^| Cloud Edition SE         ^| 9.  [Retail] ^| 10. [Volume:GVLK] ^|
ECHO            ^| Cloud Edition N SE       ^| 11. [Retail] ^| 12. [Volume:GVLK] ^|
ECHO            ^| Lean/CloudE S            ^| 13. [Retail] ^| 14. [Volume:GVLK] ^|
ECHO            ^| Lean/CloudE S N          ^| 15. [Retail] ^|                   ^|
ECHO              - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -[0m
ECHO.

:askeduedition
set choice=
set /p choice=Enter Education edition number, [b]ack or [e]xit: 
ECHO. 
%_c2%
if '%choice%'=='1' GOTO education
if '%choice%'=='2' GOTO gvlkeducation
if '%choice%'=='3' GOTO educationn
if '%choice%'=='4' GOTO gvlkeducationn
if '%choice%'=='5' GOTO professionaleducation
if '%choice%'=='6' GOTO gvlkprofessionaleducation
if '%choice%'=='7' GOTO professionaleducationn
if '%choice%'=='8' GOTO gvlkprofessionaleducationn
if '%choice%'=='9' GOTO cloudedition
if '%choice%'=='10' GOTO gvlkcloudedition
if '%choice%'=='11' GOTO cloudeditionn
if '%choice%'=='12' GOTO gvlkcloudeditionn
if '%choice%'=='13' GOTO cloude
if '%choice%'=='14' GOTO gvlkcloude
if '%choice%'=='15' GOTO clouden
if /i '%choice%'=='b' CLS & GOTO editions
if /i '%choice%'=='back' CLS & GOTO editions
if /i '%choice%'=='e' GOTO end
if /i '%choice%'=='exit' GOTO end
if not defined '%choice%' (
    ECHO Your choice is not valid. Please try again.
    GOTO askeduedition
)

:enterpriseedition
CLS
%ss%
%te%
ECHO.
ECHO           [1m - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ECHO          ^| Enterprise              ^| 1.  [OEM:NONSLP ] ^| 2.  [Volume:GVLK] ^| 
ECHO          ^| Enterprise N            ^| 3.  [Volume:GVLK] ^| 4.  [Volume:GVLK] ^|
ECHO          ^| Enterprise G            ^| 5.  [OEM:NONSLP ] ^| 6.  [Volume:GVLK] ^|
ECHO          ^| Enterprise G N          ^| 7.  [OEM:NONSLP ] ^| 8.  [Volume:GVLK] ^|
ECHO          ^| Enterprise LTSC (S)     ^| 9.  [Volume:MAK ] ^| 10. [Volume:GVLK] ^|
ECHO          ^| Enterprise N LTSC       ^| 11. [Volume:GVLK] ^| 12. [Volume:GVLK] ^|
ECHO          ^| Enterprise (ServerRdsh) ^| 13. [  Retail   ] ^| 14. [Volume:GVLK] ^|
ECHO          ^| IoT Enterprise          ^| 15. [  OEM:DM   ] ^|                   ^|
ECHO          ^| IoT Enterprise LTSC (S) ^| 17. [OEM:NONSLP ] ^|                   ^|
ECHO            - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -[0m
ECHO.

:askenterpriseedition
set choice=
set /p choice=Enter Enterprise edition number, [b]ack or [e]xit: 
ECHO. 
%_c2%
if '%choice%'=='1' GOTO enterprise
if '%choice%'=='2' GOTO gvlkenterprise
if '%choice%'=='3' GOTO enterprisen
if '%choice%'=='4' GOTO gvlkenterprisen
if '%choice%'=='5' GOTO enterpriseg
if '%choice%'=='6' GOTO gvlkenterpriseg
if '%choice%'=='7' GOTO enterprisegn
if '%choice%'=='8' GOTO gvlkenterprisegn
if '%choice%'=='9' GOTO enterprises_2021
if '%choice%'=='10' GOTO gvlkenterprises_2021
if '%choice%'=='11' GOTO enterprisesn_2021
if '%choice%'=='12' GOTO gvlkenterprisesn_2021
if '%choice%'=='13' GOTO serverrdsh
if '%choice%'=='14' GOTO gvlkserverrdsh
if '%choice%'=='15' GOTO iotenterprise
if '%choice%'=='17' GOTO iotenterprises
if /i '%choice%'=='b' CLS & GOTO editions
if /i '%choice%'=='back' CLS & GOTO editions
if /i '%choice%'=='e' GOTO end
if /i '%choice%'=='exit' GOTO end
if not defined '%choice%' (
    ECHO Your choice is not valid. Please try again.
    GOTO askenterpriseedition
)

:core
set "pk=YTMG3-N6DKC-DKB77-7M9GH-8HVX7"
%secpk%

:gvlkcore
set "pk=TX9XD-98N7V-6WMQ6-BX7FG-H8Q99"
%secpk%

:coren
set "pk=4CPRK-NM3K3-X6XXQ-RXX86-WXCHW"
%secpk%

:gvlkcoren
set "pk=3KHY7-WNT83-DGQKR-F7HPR-844BM"
%secpk%

:coresinglelanguage
set "pk=BT79Q-G7N6G-PGBYW-4YWX6-6F4BT"
%secpk%

:gvlkcoresinglelanguage
set "pk=7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH"
%secpk%

:corecountryspecific
set "pk=N2434-X9D7W-8PF6X-8DV9T-8TYMD"
%secpk%

:gvlkcorecountryspecific
set "pk=PVMJN-6DFY6-9CCP6-7BKTT-D3WVR"
%secpk%

:professional
set "pk=VK7JG-NPHTM-C97JM-9MPGT-3V66T"
%secpk%

:gvlkprofessional
set "pk=W269N-WFGWX-YVC9B-4J6C9-T83GX"
%secpk%

:professionaln
set "pk=2B87N-8KFHP-DKV6R-Y2C8J-PKCKT"
%secpk%

:gvlkprofessionaln
set "pk=MH37W-N47XK-V7XM9-C7227-GCQG9"
%secpk%

:professionalsinglelanguage
set "pk=G3KNM-CHG6T-R36X3-9QDG6-8M8K9"
%secpk%

:professionalcountryspecific
set "pk=HNGCC-Y38KG-QVK8D-WMWRK-X86VK"
%secpk%

:professionalworkstation
set "pk=DXG7C-N36C4-C4HTG-X4T3X-2YV77"
%secpk%

:gvlkprofessionalworkstation
set "pk=NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J"
%secpk%

:professionalworkstationn
set "pk=WYPNQ-8C467-V2W6J-TX4WX-WT2RQ"
%secpk%

:gvlkprofessionalworkstationn
set "pk=9FNHH-K3HBT-3W4TD-6383H-6XYWF"
%secpk%

:professionaleducation
set "pk=8PTT6-RNW4C-6V7J2-C2D3X-MHBPB"
%secpk%

:gvlkprofessionaleducation
set "pk=6TP4R-GNPTD-KYYHQ-7B7DP-J447Y"
%secpk%

:professionaleducationn
set "pk=GJTYN-HDMQY-FRR76-HVGC7-QPF8P"
%secpk%

:gvlkprofessionaleducationn
set "pk=YVWGF-BXNMC-HTQYQ-CPQ99-66QFC"
%secpk%

:education
set "pk=YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY"
%secpk%

:gvlkeducation
set "pk=NW6C2-QMPVW-D7KKK-3GKT6-VCFB2"
%secpk%

:educationn
set "pk=84NGF-MHBT6-FXBX8-QWJK7-DRR8H"
%secpk%

:gvlkeducationn
set "pk=2WH4N-8QGBV-H22JP-CT43Q-MDWWJ"
%secpk%

:enterprise
set "pk=XGVPP-NMH47-7TTHJ-W3FW7-8HV2C"
%secpk%

:gvlkenterprise
set "pk=NPPR9-FWDCX-D2C8J-H872K-2YT43"
%secpk%

:enterprisen
set "pk=WGGHN-J84D6-QYCPR-T7PJ7-X766F"
%secpk%

:gvlkenterprisen
set "pk=DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4"
%secpk%

:enterpriseg
set "pk=FV469-WGNG4-YQP66-2B2HY-KD8YX"
%secpk%

:gvlkenterpriseg
set "pk=YYVX9-NTFWV-6MDM3-9PT4T-4M68B"
%secpk%

:enterprisegn
set "pk=FW7NV-4T673-HF4VX-9X4MM-B4H4T"
%secpk%

:gvlkenterprisegn
set "pk=44RPN-FTY23-9VTTB-MP9BX-T84FV"
%secpk%

:enterprises_2021
set "pk=KCNVH-YKWX8-GJJB9-H9FDT-6F7W2"
%secpk%

:enterprises_2019
set "pk=43TBQ-NH92J-XKTM7-KT3KK-P39PB"
%secpk%

:gvlkenterprises_2021
set "pk=M7XTQ-FN8P6-TTKYV-9D4CC-J462D"
%secpk%

:enterprisesn_2019
set "pk=2D7NQ-3MDXF-9WTDT-X9CCP-CKD8V"
%secpk%

:enterprisesn_2021
set "pk=2D7NQ-3MDXF-9WTDT-X9CCP-CKD8V"
%secpk%

:gvlkenterprisesn_2021
set "pk=92NFX-8DJQP-P6BBQ-THF9C-7CG2H"
%secpk%

:gvlkenterprises_2016
set "pk=DCPHK-NFMTC-H88MJ-PFHPY-QJ4BJ"
%secpk%

:gvlkenterprisesn_2016
set "pk=QFFDN-GRT3P-VKWWX-X7T3R-8B639"
%secpk%

:gvlkenterprises_2015
set "pk=WNMTR-4C88C-JK8YV-HQ7T2-76DF9"
%secpk%

:gvlkenterprisesn_2015
set "pk=2F77B-TNFGY-69QQF-B8YKP-D69TJ"
%secpk%

:serverrdsh
set "pk=NJCF7-PW8QT-3324D-688JX-2YV66"
%secpk%

:gvlkserverrdsh
set "pk=CPWHC-NT2C7-VYW78-DHDB2-PG3GK"
%secpk%

:iotenterprise
set "pk=XQQYW-NFFMW-XJPBH-K8732-CKFFD"
%secpk%

:iotenterprises
set "pk=QPM6N-7J2WJ-P88HH-P3YRH-YY74H"
%secpk%

:cloudedition
set "pk=KY7PN-VR6RX-83W6Y-6DDYQ-T6R4W"
%secpk%

:gvlkcloudedition
set "pk=37D7F-N49CB-WQR8W-TBJ73-FM8RX"
%secpk%

:cloudeditionn
set "pk=K9VKN-3BGWV-Y624W-MCRMQ-BHDCD"
%secpk%

:gvlkcloudeditionn
set "pk=6XN7V-PCBDC-BDBRH-8DQY7-G6R44"
%secpk%

:cloude
set "pk=2HN6V-HGTM8-6C97C-RK67V-JQPFD"
%secpk%

:gvlkcloude
set "pk=NBTWJ-3DR69-3C4V8-C26MC-GQ9M6"
%secpk%

:clouden
set "pk=48FWV-TNW4T-CQ6F4-KVGQB-K3D3X"
%secpk%

:switcheditioncpk
ECHO Switching Windows edition...
changepk /ProductKey %pk%
if not [%errorlevel%]==[0] (
    GOTO fail
) else (
    GOTO finish
)
:fail
CLS
ECHO.
ECHO [91mFail^^![0m 
ECHO.
ECHO Press any key to select another edition...
ECHO.
PAUSE >nul
CLS
GOTO editions
:finish
CLS
ECHO.
echo [92mSuccess^^![0m
ECHO.
%_pn% & %_eid% & %_pkc%
ECHO [4mSwitched to[0m: 
ECHO [1m%pn% (%eid%) [%pkc%][0m
ECHO [1mProduct Key [%pk%][0m
ECHO.
ECHO Reboot to finalize edition switch.
:end
ECHO.
ECHO Press any key to exit.
PAUSE >nul
