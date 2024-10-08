# stackCalc
Този код дефинира визуализация на паметта за инструкции (instruction memory) с 21 позиции и използва JavaScript API за създаване и актуализиране на графични елементи на HTML5 canvas с помощта на библиотеката Fabric.js. Ето подробно обяснение на всяка част от кода:

1. /instr_mem[20:0]
Това указва, че имаме йерархия на 21 инстанции на паметта за инструкции (инструкционна памет), обозначена като instr_mem[20:0]. Всяка инстанция представлява една инструкция в паметта.
2. \viz_js блок
Започва блокът за визуализация с помощта на \viz_js. В този блок се дефинират визуалните елементи и логиката за тяхното рендиране (показване) и обновяване.
3. all: {}
Свойството all се използва, за да дефинира действия и елементи, които са общи за всички 21 инстанции на паметта. Това позволява централизирано управление на общите визуални обекти и логика.
a. init() (в all)
Тази функция инициализира общ текстов елемент за всички инстанции, който ще се показва над паметта за инструкции.
imem_header е текстов обект, който показва "Postfix Expression:" с различни визуални настройки (шрифт, размер, тегло на шрифта, цвят).
Return: Връща обект, който съдържа imem_header, за да бъде използван по-късно в визуализацията.
b. render() (в all)
Тази функция се изпълнява на всяка симулационна стъпка, за да подчертае текущата инструкция в паметта.
let pc = '|example$pc'.asInt(1): Извлича стойността на програмния брояч (pc), преобразуван в цяло число.
this.highlighted_addr = pc: Записва текущата стойност на програмния брояч в променливата highlighted_addr.
instance и instance1: Определят текущата инструкция и предишната инструкция въз основа на pc и задават различни цветове за техните фонове.
Текущата инструкция се оцветява в светлосиньо (#b0ffff).
Предишната инструкция се оцветява в светложълто (#fcf3cf).
Цел: Тази функция визуализира коя инструкция е активна и коя е била последно изпълнена, подчертавайки съответните кутии.
4. box: {strokeWidth: 0}
Свойството box дефинира координатната система за компонента. В този случай strokeWidth: 0 указва, че няма граница (рамка) около компонентите.
5. where0: {left: -150, top: 40}
Това определя позицията на първата инстанция от паметта спрямо координатите left и top. Тя ще бъде изместена на 150 пиксела вляво и 40 пиксела надолу от началната точка.
6. layout: {left: 50}
Свойството layout указва, че инстанциите на паметта за инструкции ще бъдат подредени хоризонтално с 50 пиксела разстояние между всяка инстанция.
7. init() (за отделните инстанции)
В този init() се инициализират два графични обекта за всяка отделна инстанция:
instr_str: Текстов обект, който ще се използва за показване на съответната инструкция.
instr_asm_box: Правоъгълник с жълт фон (#fcf3cf), който служи като фон за текстовия обект.
Return: Връща обекти instr_str и instr_asm_box, които ще бъдат използвани при визуализацията на всяка инстанция.
8. render() (за отделните инстанции)
Тази функция се изпълнява, за да покаже текста на инструкцията в текущата инстанция.
let instr_str = '$instr_strs'.asString("?"): Извлича текста на текущата инструкция от симулацията (чрез instr_strs) и го задава като текст за обекта instr_str.
this.getObjects().instr_str.set({text: ${instr_str}}): Актуализира текста на визуалния обект instr_str с извлечената стойност.
Цялостно обяснение:
Кодът създава визуализация на паметта за инструкции с 21 инстанции, като за всяка инструкция има правоъгълник с текст.
Използва се библиотеката Fabric.js за рендиране на текстовите обекти и правоъгълниците.
init() създава графичните обекти, а render() обновява съдържанието на тези обекти по време на симулацията.
all се използва за централизирано създаване и управление на общи елементи, докато индивидуалните init() и render() се използват за всяка инстанция на паметта.
