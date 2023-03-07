@echo off
setlocal EnableDelayedExpansion

set exclude=".git"
for /F "delims=" %%a in ('DIR /Ad /S "H:\Vortex Mods\diablo2resurrected\mods"') do (
   if "!exclude:/%%~Na/=!" equ "%exclude%" echo %%a
)