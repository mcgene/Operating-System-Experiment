#include "kdata.h"

extern char incr();
extern void interupt();
extern void cprintf(char*,int);
extern void printf(char *s);
extern void cls();
extern void printChar(char ch);
extern void getChar();  
extern void printChar();
extern void show_Time();
extern void show_Date();
extern void printff(char*,int);
extern void ReadCommand();
extern void set_int09h();
extern void reset_int09h();
extern void iint();
extern void pr1();
extern void pr2();
extern void pr3();
extern void pr4();
extern void another_load(int segment,int offset);

char hour;
char minute;
char second;
char century;
char year;
char month;
char day;
int StringLen;
int dir;
char input;
char Buffer[1000];
char string[50];
char CMDline[50]="";
char storebuffer[100]="\rname size location\r\npro1 512b 200h\r\npro2 512b 400h\r\npro3 512b 600h\r\npro4 512b 800h\r\n";
char ccch='T';
int disp_pos=0;
char buffer1[100]=">>>:";
char welcome[20]="\rwelcome to geneOS\r\n";
char input;
int Segment = 0x2000;
void com_int();
void run( char *cmd);
void batchrun( char *s);
void itos(int n);
int strlen( char *s );
int strcmp(char *a, char *b);
void runPro1();
void runPro2();
void runPro3();
void runPro4();
void int37h_call(int ax,int dx,int cx);
void show();
void init();
void command();
int BCDdecode( int n );
void Transfor( int num );
void PrintTime();
void PrintDate();
void init_Pro();
void INT21H();
void bug();
void printInt( int reg );

void bug()
{
	Print("here");
}

void cmain(){
/*	char buf[15]="hello world!";  */
	interupt();
	cls();
	Print(welcome);
	Print("You can enter help to get help!\n\r");
	setClock();
	command();
	return; 
}

void gethelp()
{
	Print("pro1：run the first program \n\r");
	Print("pro2: run the second program\n\r");
	Print("pro3: run the third program \n\r");
	Print("pro4: run the fourth program \n\r");
	Print("init: initialize \n\r");
	Print("int: call interrupt \n\r");
	Print("run: create processes\n\r    Usage: run pro1\n\r    run pro1 pro2\n\r");
	Print("INT21H: call the funtion in Int21H \n\r");
}

void command()
{
	Print(buffer1);
	while(1)
	{
		ReadCommand();
		run(CMDline);
	}
}

void Delay()
{
	int i = 0;
	int j = 0;
	for( i=0;i<30000;i++ )
		for( j=0;j<30000;j++ )
		{
			j++;
			j--;
		}
}

void run(char *cmd)
{
	if( strcmp(cmd,"pro1\0"))
		runPro1();
	else if(strcmp(cmd,"pro2\0"))
		runPro2();
	else if(strcmp(cmd,"pro3\0"))
		runPro3();
	else if(strcmp(cmd,"pro4\0"))
		runPro4();
	else if(strcmp(cmd,"show\0")){
		show();
	}else if(strcmp(cmd,"init\0")){
		init();
	}else if(strcmp(cmd,"quit\0")){
		return;
	}else if(cmd[0] == 'r' && cmd[1] == 'u' && cmd[2] == 'n'){
		cls();
		batchrun(cmd);
		Delay();
		cls();
		Print(welcome);
	}else if(strcmp(cmd,"int\0")){
		com_int();
	}else if(strcmp(cmd,"help\0")){
		gethelp();
	}else if(strcmp(cmd,"INT21H\0")){
		INT21H();
	}else{
		Print(" input illegal\r\n");
	}
	Print("\n\r>>>:");
}


void printInfo()
{
	Print(storebuffer);
}

void runPro1(){
	/*set_int09h();*/
	/*pr1();*/
	another_load(2000,2);
	/*reset_int09h();*/
}

void runPro2()
{
	/*set_int09h();*/
	pr2();
	/*reset_int09h();*/
}

void runPro3()
{
	/*set_int09h();*/
	pr3();
	/*reset_int09h();*/
}

void runPro4()
{
	/*set_int09h();*/
	pr4();
	/*reset_int09h();*/
}

void show()
{
	printInfo();
}

void init()
{
	runPro1();
	runPro3();
}


void itos(int n)
{
	int cnt = 0;
	while( n > 0 )
	{
		string[cnt] = cnt % 10;
		cnt++;
		cnt /= 10;
	}
	string[cnt] = '\0';
}
int i = 1;
int strlen(char *s )
{
	i = 1;
	while( s[i-1] != '\0')
	{
		i++;
	}
	return i;
}

int strcmp(char* a, char* b)
{
	int cnt = 0;
	while(1)
	{
		if( a[cnt] == '\0' && b[cnt] == '\0')
			break;

		if(a[cnt] != b[cnt] || a[cnt]=='\0' || b[cnt]=='\0')
		{
			return 0;
		}

		cnt++;
	}
	return 1;
}

void strcpy(char* src, char *des, int bidx, int eidx)
{
	int i;
	for( i = bidx; i <= eidx; i++ )
	{
		des[i-bidx] = src[i];
	}
	des[i-bidx+1] = '\0';
}

int strsplit(char *src, char *des, char label, int begin)
{
	
	int i;
	int len = strlen(src);
	if( begin >= len)
		return -1;
	for( i = begin;src[i]!=label && i < len; i++ )
	{
		des[i-begin] = src[i];
	}
	des[i-begin] = '\0';
	
	return i+1;
}
/*
void batchrun( char *s)
{
	int len = strlen(s);
	int i = 0;
	for( i = 4; i < len;  )
	{
		i = strsplit(s,string,' ',i);
		if( i > 0)
			run(string);
	}
}
*/

void load_from_disk(char *s)
{
	if( s[0] == 'p' && s[1] == 'r' && s[2] == 'o' && s[3] > '0' && s[3] <= '9')
	{
		int j = s[3] - '0';
		another_load(currentSeg,j+1);
		createNewProcess();
	}else{
		Print("input illegal!!\n");
	}
}

void batchrun( char *s)/*eb20*/
{
	int len = strlen(s);
	int i = 0;
	for( i = 4; i < len;  )
	{
		i = strsplit(s,string,' ',i);
		if( i > 0)
			load_from_disk(string);
	}
}

void com_int()
{
	/*set_int09h();*/
	iint();
	/*reset_int09h();*/
}

void upper(char *dl)
{
	if( *dl <= 'z' && *dl > 'a')
		*dl = *dl + 'A' - 'a';
}

void int37h_call(int ax,int dx,int cx)
{
	int ah = ax / 256;
	int al = ax % 256;
	int dh = dx / 256;
	int dl = dx % 256;
	switch(ah){
		case 1:
			cls();
			break;
		case 2:
			getChar();
			break;
		case 3:
			printChar(dl);
			break;
		case 4:
			upper(&dl);
			break;
		case 5:
			Print(dx);
			break;
	}
	return;
}

void Print( char* word )
{
	while( *word != '\0' )
	{
		printChar( *word );
		word ++ ;
	}
}

void GetInput()
{
	int index = 0;
	getChar();
	printChar(input);
	while( input != '\n'&& input != '\r' )
	{
		Buffer[index] = input;
		index ++;
		getChar();
		printChar(input);
	}
	Buffer[index] = '\0';
	Print("\n");
	StringLen = index;
}

int BCDdecode(int n) {
    return n / 16 * 10 + n % 16;
}

void Transfor( int num )
{
	Buffer[0] = num/10 + '0';
	Buffer[1] = num%10 + '0';
	Buffer[2] = '\0';
}

void PrintTime()
{
	int hour1 = hour;
	int minute1 = minute;
	int second1 = second;

	Print("\nTime: ");
	Transfor( BCDdecode(hour1) );
	Print(Buffer);
	Print(":");

	Transfor( BCDdecode(minute1) );
	Print(Buffer);
	Print(":");

	Transfor( BCDdecode(second1) );
	Print(Buffer);
	print("\r\n");
}

void PrintDate()
{
	int century1 = century;
	int year1 = year;
	int month1 = month;
	int day1 = day;

	Print("\nDate: ");
	Transfor(BCDdecode(century1));
	Print(Buffer);

	Transfor( BCDdecode(year1) );
	Print(Buffer);
	Print("/");

	Transfor(BCDdecode(month1));
	Print(Buffer);
	Print("/");

	Transfor(BCDdecode(day1));
	Print(Buffer);
	print("\r\n");
}

void INT21H()
{
	cls();
	Print("1 : clear the windows \n\r");
	Print("2 : Get char(can't used directly)\n\r");
	Print("3 : Print char(can't used directly)\n\r");
	Print("4 : Upper a character\n\r");
	Print("5 : Print a string(can't used directly)\n\r");
	Print("6 : show OUCH!");
	Print("Please enter the function  number you want:\n\r");
	getChar();
	printChar(input);

	switch(input){
		case '1':
			cls();
			break;
		case '2':
			getChar();
			break;
		case '4':
			Print("Please enter a character:\n\r");
			getChar();
			upper(&input);
			printChar(input);
			break;
		case '6':
			Print("OUCH!!OUCH!!");
			break;
	}

}

void init_Pro()
{
	init_PCB(&pcb_list[0],0x1000,0x100);
	init_PCB(&pcb_list[1],0x2000,0x100);
	init_PCB(&pcb_list[2],0x3000,0x100);
	init_PCB(&pcb_list[3],0x4000,0x100);
	init_PCB(&pcb_list[4],0x5000,0x100);
	init_PCB(&pcb_list[5],0x6000,0x100);
}

void printInt( int reg )
{
	int temp = reg;
	char out[100];
	int num = 0;
	int i = 0;
	if(temp < 0){
		temp = -temp;
	}
	while( temp != 0 )
	{
		int remain = temp % 16;
		temp /= 16;
		if( remain < 10 && temp >= 0)
		{
			out[num] = remain + '0';
		}else if( remain >= 10 && remain < 16){
			out[num] = remain - 10 + 'A';
		}

		num += 1;
	}

	if(temp == 0 )
	{
		out[num] = '0';
		num++;
	}

	out[num] = '\n';
	out[num+1]='\r';
	out[num+2]='\0';
	
	for(i = 0; i < num / 2; i++)
	{
		char t = out[i];
		out[i] = out[num - 1 - i ];
		out[num - i - 1] = t;
	}
	if( reg < 0 )
		Print("-");
	Print(out);
	return;
}

