extern char incr();
extern void cprintf();
extern void printf();
extern void cls();
extern void printChar(char ch);
extern void getChar();  
extern void port_out(int port, char value);  
extern void printff(char*,int);
extern void pr1();
extern void pr2();
extern void pr3();
extern void pr4();


char string[50];
char CMDline[50]="";
char buffer[100]="\rname size location\r\npro1 512b 200h\r\npro2 512b 400h\r\npro3 512b 600h\r\npro4 512b 800h\r\n";
char ccch='T';
int disp_pos=0;
char buffer1[100]="\rPlease enter command(pro1/pro2/pro3/pro4/show/init):\r\n>:";
char welcome[20]="\rwelcome to geneOS\r\n";

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
	cls();
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
	else if(strcmp(cmd,"pro2"))
		runPro2();
	else if(strcmp(cmd,"pro3"))
		runPro3();
	else if(strcmp(cmd,"pro4"))
		runPro4();
	else if(strcmp(cmd,"show")){
		show();
	}else if(strcmp(cmd,"init")){
		init();
	}else if(strcmp(cmd,"quit")){
		cmain();
	}else if(cmd[0] == 'r' && cmd[1] == 'u' && cmd[2] == 'n'){
		batchrun(cmd);
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
	pr1();
}

void runPro2()
{
	pr2();
}

void runPro3()
{
	pr3();
}

void runPro4()
{
	pr4();
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
	for( i = begin;src[i]!=label && i < len; i++ )
	{
		des[i-begin] = src[i];
	}
	des[i-begin+1] = '\0';
	return i+1;
}

void batchrun( char *s)
{
	int len = strlen(s);
	int i = 0;
	for( i = 4; i < len;  )
	{
		i = strsplit(s,string,' ',i);
		run(string);
	}
}