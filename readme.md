# Computer Organization
Time : 2020 fall (first half semester of sophomore)

## lecture
>more info in lec/*pdf

|subject|teacher|
|:-:|:-:|
|[計算機組織](http://class-qry.acad.ncku.edu.tw/syllabus/online_display.php?syear=0109&sem=1&co_no=E221700&class_code=2)|[陳中和](https://caslab.ee.ncku.edu.tw/)|

<br>

## Code
>more info in doc/*docx
- [lab01](#lab01)
- [lab02](#lab02)
- [lab03](#lab03)
- [lab04](#lab04)
- [lab05](#lab05)
- [lab06](#lab06)
- [lab07](#lab07)
- [lab08](#lab08)
- [lab09](#lab09)
- [lab10](#lab10)

<br>

## Environment
1. OS
- `Ubuntu v18.04`
- `Windows 10`
2. Software
- `riscv-gnu-toolchain(cross compiler)`, `Python3`
- `Modelsim`

<br>

## How to Run
>more info in env/*pdf
#### In Ubuntu v18.04
1. assembly code to object file
```
riscv32-unknown-elf-as -mabi=ilp32 add.s -o add.o
```

2. link object file to elf file
```
riscv32-unknown-elf-ld -b elf32-littleriscv -T link.ld add.o -o add.elf
```

3. generate a file for debugging
```
riscv32-unknown-elf-objdump -dC add.elf > add.dump
```

4. transform elf file to binary
```
riscv32-unknown-elf-objcopy -O binary add.elf add.bin
```

5. Convert binary to Memory Initialization File
```
python3 bin2mem.py --bin add.bin
```
#### In Windows 10
6. open modelsim
```
modelsim
```
7. change to your file location<br>
`file -> change Directory`

8. new project<br>
`new -> project`

9. add source code<br>
`Add Existing File -> import source code`

10. compile and simulate source code<br>
`click estbench.sv -> compile -> simulate`

11. choose testbench
`work -> tb_core_ut disable "Enable optimization"`

12. add signal to wave
`signal you want to observe right click and add signal`

13. run all
`click run all`

14. check memory result
`view -> memory list`

15. check memory result
`Goto : 要看的memory位置`


<br>

## lab01
將教授上課講的RISC-V的一些基礎指令(addi,add,li,beq,jal,sw,lw)實作，把C語言轉成組合語言，挑戰題我們則是把題目敘述轉成C語言再轉成組合語言。另外還有環境與tool的基本使用:熟悉Virtualbox在Windows開Linux、Modelsim查看暫存器與記憶體的操作

## lab02
本次實驗一樣是寫組合語言，不過相比起來，這次是有照著規定去編程，像`RV32I`暫存器個別都有規定-`x1/ra(Return address)`、`x2/sp(Stack pointer)`、`x8/s0(frame pointer)`......哪顆暫存器真的不能亂存，像目標暫存器不能為`x0`，因為`x0`要恆為`0`。

## lab03
學習Verilog，了解`ALU`、`Decoder`運作原理。

## lab04
當RISC-V遇到Interrupt(or Internal (Exception), External)時，Interrupt Handler與Interrupt Service Routine執行、處理的步驟，也稍微運用到了mask。

## lab05
`LLVM(Low Level Virtual Machine)`**模組化的編譯器**強大的功能，讓我們能修改`RISC-V`的`backend`，藉由類似`RISC-V R-type`定址格式，決定此架構下的機器語言指令對應的運算數。而挑戰題藉由比較兩個LLVM組合語言的檔案讓我們了解到程式優化前後的差別。

## lab06
1. GPIO 
    - switch
    - blinky
2. Timer
    - observation
    - blinky
3. PWM
    - breathing light
    - colorful light

## lab07
- 超音波測距
- I2C_LCD顯示器

## lab08
了解目前市場主流`SOC`的匯流排架構`AMBA`之各項基本觀念與`AMBA2.0-AHB`之實際操作，實驗一寫C Code利用`Tube`這個`Slave`印出字體；實驗二在`Bus`上掛外部記憶體，並寫入自己的學號查看Modelsim驗證其結果；實驗三在`Bus`位置0x20000000上掛GPIO，並寫自己所屬組別用FPGA驗證其結果。

## lec09
了解`Master`存取`bus`的優先權界定，由於只有一個`bus`對上多個`Master`發出的訊號，就需要有`Mux`去選要哪個訊號，其中`Arbiter`的仲裁機制又可分
- Lab1做的`Fixed Priority`，每個`Master`的priority在設計系統時就先決定好了，才會出現當優先度高的`Master`不斷使用`bus`時就會dominate，其他的Master用不到，優點是在優先權高且極需用到bus的master可容易拿到bus
- lab3做的`Round Robin Priority`，拿到bus使用權的Master，在下一次仲裁時priority會變最低，優點是每一個 Master有較平均的bus使用權。最後lab是Timer在一定時間後叫醒Master01-03的Request讓他們去爭奪寫入Tube，也是我們卡最久的，因為對接線上沒有充分了解。

## lec10
介紹了新的組合**控制邏輯單元Interrupt Controller**，當一個Device產生中斷(External I/O)後，需經過`Interrupt Controller`的轉發訊號成`IRQ`，訊號才能到達CPU的ISR。(Interrupt Controller會**回應**該Device訊號Ack，表示Device的中斷已經被傳達)。而Lab2則新增一個來自FPGA板上的Switch Interrupt。