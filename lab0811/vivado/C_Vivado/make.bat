@ECHO OFF

if not exist "%ARM_CROSS_COMPILER_PATH%" (
	echo Cannot find ARM cross compiler.
	echo Please assign path of Cross compiler to environment variable ARM_CROSS_COMPILER_PATH
	pause & exit
)

echo [AS]	init.s
"%ARM_CROSS_COMPILER_PATH%\arm-none-eabi-as" -march=armv4 init.s -o init.o
IF ERRORLEVEL 1 ( pause & exit )
echo [CC]	main_function.c
"%ARM_CROSS_COMPILER_PATH%\arm-none-eabi-gcc" -march=armv4 main_function.c -O2 -c -o main_function.o
IF ERRORLEVEL 1 ( pause & exit )
echo [CC]	isr.c
"%ARM_CROSS_COMPILER_PATH%\arm-none-eabi-gcc" -march=armv4 isr.c -O2 -c -o isr.o
IF ERRORLEVEL 1 ( pause & exit )
echo [LD]	code.axf
"%ARM_CROSS_COMPILER_PATH%\arm-none-eabi-ld" init.o main_function.o isr.o -o code.axf --script=ld_4.script
IF ERRORLEVEL 1 ( pause & exit )
echo [CV]	testcode.txt
if EXIST testcode.txt (
	del /F /Q testcode.txt
)
"%ARM_CROSS_COMPILER_PATH%\arm-none-eabi-objdump" -d code.axf > code.txt
for /f "tokens=2 skip=1" %%i in ('%ARM_CROSS_COMPILER_PATH%\arm-none-eabi-objdump -d code.axf ^| findstr /R ":."') do (
	echo %%i>>testcode.txt
)

rem -----------------------------------------------------
SETLOCAL
SETLOCAL ENABLEDELAYEDEXPANSION
IF ERRORLEVEL 1 ( pause & exit )
if not exist testcode.txt ( 
	echo Cannot find testcode.txt
	pause & exit
)
if exist lab.coe ( del lab.coe )
echo [CV]	lab.coe
set /A pre=-1
set /A firstgot=0
echo memory_initialization_radix=16;>>lab.coe
for /f %%i in ( testcode.txt ) do (
  if not !pre! == -1 (
	if !firstgot! == 0 (
		set /a firstgot=1
		echo memory_initialization_vector=!pre!,>> lab.coe
	) else (
		echo !pre!,>> lab.coe
	)
  )
  set pre=%%i
)
echo %pre%;>> lab.coe
ENDLOCAL
rem -----------------------------------------------------

del /Q *.o
echo Done.
pause