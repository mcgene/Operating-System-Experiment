extern char incr();
extern void interupt();
extern void cprintf(char*,int);
extern void printf(char *s);
extern void cls();
extern void printChar(char ch);
extern void getChar();  
extern void printff(char*,int);
extern void ReadCommand();
extern void set_int09h();
extern void reset_int09h();
extern void iint();
extern void pr1();
extern void pr2();
extern void pr3();
extern void pr4();


char string[50];
char CMDline[50]="";
char buffer[100]="\rname size location\r\npro1 512b 200h\r\npro2 512b 400h\r\npro3 512b 600h\r\npro4 512b 800h\r\n";
char ccch='T';
int disp_pos=0;
char buffer1[100]="\rPlease enter command(pro1/pro2/pro3/pro4/show/init/int):\r\n>:";
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

void show();

void init();
void command();

void cmain(){
/*	char buf[15]="hello world!";  */
	interupt();
	printff(welcome,strlen(welcome));
	command();
	return; 
}

void command()
{
	printff(buffer1,strlen(buffer1));
	while(1)
	{
		ReadCommand();
		run(CMDline);
	}
}

void run(char *cmd)
{
	if( strcmp(cmd,"pro1"))
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
		cmain();
	}else if(cmd[0] == 'r' && cmd[1] == 'u' && cmd[2] == 'n'){
		batchrun(cmd);
	}else if(strcmp(cmd,"int\0")){
		com_int();
	}
	else{
		printff("input illegal\r\n",15);
		printff("\r\n>:",4);
	}
}


void printInfo()
{
	printff(buffer,strlen(buffer));
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