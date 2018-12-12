Integer literali u jeziku LL zadaju se u obliku <cifre>_<baza>. 
Podrazumijevana je baza 10, ali su baze 2 (binarna), 8 (oktalna) i 16 (hex) takode dozvoljene. 
Binarni literali sastoje se od jedne ili više binarnih cifara iza kojih slijedi niz _2 (npr. 10110_2). 
Oktalni literali sastoje se od jedne ili više oktalnih cifara iza kojih slijedi niz _8 (npr. 1234567_8). 
Heksadecimalmi literali sastoje se od jedne ili više heksadecimalnih cifara iza kojih slijedi niz _16 (npr. 123456789ABCDEF_16). 
Decimalni literali sastoje se od jedne ili više dekadnih cifara iza kojih opcionalno slijedi niz _10 (npr. 123456789_10 ili 123456789).
	Napisati FLEX program koji ucitava sve aritmeticke izraze sastavljene od integer literala jezika LL i operatora +, -, *, % i /. 
	Program zamjenjuje leksime integer literala  porukama BIN, OCT, DEC ili HEX. 
	Na primjer, za ulaz 123-456_16+336_8*101_2 daje sledeci izlaz: DEC-HEX+OCT*BIN. 

