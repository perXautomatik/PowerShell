takeown /f **full\_folder\_path** /r /d y

#Please change **full\_folder\_path** with path of the folder you want to take ownership control.
#3- After that run the command given below.

icacls **full\_folder\_path** /grant %username%:F /t /q

#Note: -If you want to give full permission to Administrator on system then run the command given below.

ICACLS **full\_folder\_path** /grant administrators:F
