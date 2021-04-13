all: compiler.l	table.c
	yacc -d compiler.y
	flex compiler.l 
	gcc lex.yy.c y.tab.c table.c -ly -ll -o compiler