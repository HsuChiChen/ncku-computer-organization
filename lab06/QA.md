# LAB6_ARC_IoTDK_Example_Code
[Updating] 助教已將自己寫的 4 題 Lab 的 Code 放在上方可供同學參考 (當然，助教寫的不一定是最好的寫法)  
[Updating] 助教已將 4 題 Questions 的解答打在下方，大家若有不懂的可以再來問助教～
* [Topic](#topic)
* [Source](#source)
* [Question Answer](#question-answer)
## Topic
* GPIO
* TIMER & INTERRUPT
* PWM
## Source
Video (including `GUIDE` & `LAB example`) : [Link](https://www.youtube.com/playlist?list=PLtOgiVU90A6_jJ7KYYybvQ1WFFaivElLi)  
PPT : Please go to [CASLab](https://caslab.ee.ncku.edu.tw/dokuwiki/course:co:109) Download
## Question Answer
* Q1 : Why do we need mask ?
* A1 :  
因為在合作或較大型的程式開發時，我們只確定我們要`寫的位置的值`是"可以動"的，`其他的位置的值`我們不知道是什麼所以"要保持原狀"(很多bits都是run time的時候才決定的所以不能動)  
若不經由mask直接寫val進reg(也就是將val寫進腳位的輸出資訊)的話，須先將reg的值讀取出來，改變我們要改變的位置的值後，再寫回去。  
其實他背後運作的原理(Q2的code)就是我上面講的那段，所以為了使用者方便這些繁瑣的步驟就被包裝成一個`write api`來供我們使用！  
  
* Q2 : Explain what the code do![](https://i.imgur.com/hIDovxP.png)
* A2 :  
`temp_val &= (~mask);` /\* 將我們要寫的位置的值清掉，保持其餘位置的值不變 \*/  
`val &= (mask);` /\* val留下我們要寫的位置的值，清除其餘位置的值 \*/  
所以這時  
temp_val 剩下需保持不動的位置的值  
val 剩下要改變的位置的值  
`io_gpio_write(ctx->dev_id, temp_val | val);` /\* 將不動的值跟要寫的值合起來寫回去 \*/  
  
* Q3 : Commend line#98 & Uncomment line#99, then run and check![](https://i.imgur.com/P8f2Ea5.png)
* A3 :  
line#98只打開IE Mode  
line#99打開了IE、及IP  
/////////////////////////////////////////////////////////////////////////////////////////////////////  
IP是狀態指示位，代表有一個尚未被CPU接受的Interrupt  
IP只要為1就會一直對CPU要求Interrupt，CPU可以決定要不要接受  
只要CPU不接受，IP就會一直為1  
若CPU接受，就會跳轉至ISR執行，而ISR做的第一件事就是清除IP(1->0)，代表處理了這個Interrupt  
**/ 若打開IE Mode，TIMER 每次數到Limit的時候就會將IP變為1 /**  
/////////////////////////////////////////////////////////////////////////////////////////////////////  
line#98 是每五秒就讓 (IP -> 1) ，CPU接受後進入ISR執行所以在進入ISR之前會先執行印出aaaaa...aaaaa五次  
line#99 也是每五秒就讓 (IP -> 1)，但一開始就將IP設為1，所以一開始就會直接進入ISR執行，而不會先印出aaaaa...aaaaa  
  
* Q4 : Comment line#70 & #71, then run and check![](https://i.imgur.com/wFmpvKM.png)
* A4 :  
line#70, #71 是在將TIMER0的中斷優先度設置成最高  
/////////////////////////////////////////////////////////////////////////////////////////////////////  
中斷優先度分為4個等級 -4(highest) ~ -1(lowest)  
中斷優先度高的中斷可以中斷優先度低的中斷  
大於時(>)可以中斷其他中斷，小於等於(<=)時不行  
ex : -4 可以中斷 -3、-2、-1  
ex : -2 只能中斷 -1  
/////////////////////////////////////////////////////////////////////////////////////////////////////  
![](https://i.imgur.com/uzBx8YQ.png)  
`系統毫秒`是靠 TIMER0 每1毫秒產生一個中斷去更新  
**( 大家有興趣可以去以下路徑查看 : embarc_osp-master\board\iotdk\common\iotdk_timer.c  
觀看順序 : iotdk_timer_init => iotdk_timer_isr => board_timer_update )**  
`系統時間` = `系統毫秒` + `TIME0當前數到的system cycle去換算微秒`  
**/ 所以今天若在其他 ISR 裡，要是TIMER0的中段優先度沒有比該ISR高的話，`系統毫秒`就不會更新 /**  
**!!! 但是，`系統時間`會一直更新，因為TIMER0一直在數，數到1毫秒就歸0重數 !!!**  
/////////////////////////////////////////////////////////////////////////////////////////////////////  
此範例在 t1_isr (TIMER1的中斷處理程序)裡有一行`board_delay_ms(6000, 0);` /\* 也就是暫停6秒 \*/  
`board_delay_ms(ms, 0);`   
![](https://i.imgur.com/2brGt5q.png)  
是藉由 : (一直呼叫`系統時間`) - (呼叫此function時的`系統時間`) 來做delay的判斷  
所以要是TIMER0的中斷優先度小於等於(<=)TIMER1的中斷優先度，`系統毫秒`將不會得到更新。  
!!! 但是，`系統時間`會一直更新，因為TIMER0一直在數，數到1毫秒就歸0重數 !!!  
所以假設呼叫`board_delay_ms(6000, 0);`時TIMER0數到了0.5毫秒的system cycles，那麼TIMER0繼續數到1毫秒歸0的時候，跟0.5毫秒的system cycles相減就會是一個負數，可是這個資料型態是`unsigned integer`，所以就會等於是一個超大的正數！當然也就超過了6秒  
也就是說TIMER0數不到1毫秒就得到了超過6秒的delay，所以一瞬間就跳過了這個delay繼續執行。  
**/ 這邊會有1個嚴重的 warning 就是：若是呼叫此函式的時候TIMER0剛好是數到0，那麼程式將會永遠停在這裡！ /**  
