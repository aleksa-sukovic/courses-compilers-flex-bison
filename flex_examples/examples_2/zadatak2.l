Integer literali u jeziku PG formiraju se na sljedeci nacin: Oktalni literali - vodeca 0 i zatim nula ili više oktalnih cifara, najviše 12 cifara;
Heksadecimanil literali -  vodeca 0, zatim x ili X a zatim nula ili više heksadecimalnih cifara (0-9, a-f, A-F), najviše 8 cifara; 
Decimalni  literali jedna  nenulta decimalna cifra i zatim nula ili više decimalnih cifara, najviše 16 cifara 
	Napisati FLEX program koji ucitava sve aritmeticke izraze sastavljene od integer literala jezika PG i operatora +, -, *, i /. 
	Program zamjenjuje leksime integer literala  porukama OCT, DEC ili HEX. Na primjer, za ulaz 123-0x456+0336 daje sledeci izlaz: DEC-HEX+OCT.

