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
if exist testcode.txt ( del /F /Q testcode.txt )
"%ARM_CROSS_COMPILER_PATH%\arm-none-eabi-objdump" -d code.axf > code.txt
for /f "tokens=2 skip=1" %%i in ('%ARM_CROSS_COMPILER_PATH%\arm-none-eabi-objdump -d code.axf ^| findstr /R ":."') do (
	echo %%i>>testcode.txt
)
del /Q *.o
echo Done.
pause