flex t1.l
bison -d t1.y
gcc lex.yy.c t1.tab.c -o app