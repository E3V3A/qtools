@  Апплет чтения слова идентификаци чипсета модема через команду 11
@
@ На входе:
@ R0 = адрес начала данного кода (точки start)
@ R1 = адрес ответного буфера
@
@

      .org    0	
      .byte   0,0 	  @ выравнивающие байты - отрезаются от объектного модуля
      .byte   0x11,0      @ код команды 11 и выравнивающий байт - это остается в объектном модуле

start: 
       PUSH	{R1}
       MOV	R0,LR		@ адрес обработчика команды 11 в загрузчике
       BIC	R0,#3           @ округляем по границе слова
       ADD	R3,R0,#0xFF	@ граница поиска образца
       LDR	R1,=0xDEADBEEF  @ образец для поиска
floop:                          
       LDR	R2,[R0],#4      @ очередное слово
       CMP	R2,R1           @ это образец?
       BEQ	found           @ да - нашли наконец
       CMP	R0,R3           @ доехали до границы?
       BCC	floop           @ нет - ищем дальше
@ Образец не найден             
       MOV	R0,#0           @ ответ 0 - образец не найден
       B	done            
@ Нашли образец
found:                          
       LDR	R0,[R0]         @ вынимаем код чипсета
done:             
       POP	{R1}
       STRB	R0,[R1,#1]      @ сохраняем код в байте ответа 1
       MOV	R0,#0xAA        @ AA - код ответа режима идентификации
       STRB	R0,[R1]         @ в байт 0
       MOV	R4,#2           @ размер ответа - 2 байта
       BX       LR              
                               