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
void Print(char* word);
void init();
void command();
int BCDdecode( int n );
void Transfor( int num );
void PrintTime();
void PrintDate();
void INT21H();

void cmain(){
/*	char buf[15]="hello world!";  */
	interupt();
	cls();
	Print(welcome);
	Print("You can enter help to get help!\n\r");
	command();
	return; 
}

void gethelp()
{
	Print("pro1 \n\r");
	Print("pro2 \n\r");
	Print("pro3 \n\r");
	Print("pro4 \n\r");
	Print("init \n\r");
	Print("show \n\r");
	Print("int \n\r");
	Print("run \n\r");
	Print("INT21H \n\r");
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
		batchrun(cmd);
	}else if(strcmp(cmd,"int\0")){
		com_int();
	}else if(strcmp(cmd,"help\0")){
		gethelp();
	}else if(strcmp(cmd,"INT21H\0")){
		INT21H();
	}
	else{
		Print(" input illegal\r\n");
	}
	Print("\n\r>>>:");
}


void printInfo()
{
	Print(storebuffer);
}

void runPro1(){
	set_int09h();
	pr1();
	reset_int09h();
}

void runPro2()
{
	set_int09h();
	pr2();
	reset_int09h();
}

void runPro3()
{
	set_int09h();
	pr3();
	reset_int09h();
}

void runPro4()
{
	set_int09h();
	pr4();
	reset_int09h();
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

void com_int()
{
	set_int09h();
	iint();
	reset_int09h();
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