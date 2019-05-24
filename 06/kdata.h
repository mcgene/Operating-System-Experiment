#define MAX_NrPCB 8
int CurrentPCBno = 0; /*当前进程号*/
int processNum = 0; /*进程计数*/
int currentSeg = 0x2000; /*当前段地址,添加一个进程+1000h*/
int SP_OFF = 0x100; 	 /*栈顶*/
int isProgramRunning = 0; /*标记是否进入用户态，用于第一次进行时间中断的*/
/*#define Debug 1*/
void Print(char *mess);
typedef enum PCB_Status{READY,EXIT,RUNING, BLOCKING}PCB_Status;

typedef struct RegisterImage{
	int SS;
	int GS;
	int FS;
	int ES;
	int DS;
	int DI;
	int SI;
	int BP;
	int SP;
	int BX;
	int DX;
	int CX;
	int AX;
	int IP;
	int CS;
	int Flags;
}RegisterImage;

typedef struct PCB{
	RegisterImage regImg;/***registers will be saved in this struct automactically by timer interrupt***/
	/******/
	int ID;
	PCB_Status status;
}PCB;

/*进程表定义*/
PCB pcb_list[MAX_NrPCB];


/*获取当前进程表的地址*/
PCB* getCurrentPCB(){
	#ifdef Debug
	Print("geting\r\n");
	switch(CurrentPCBno){
		case 0:
			Print("AAAAAAAAAAAAAAAAAAAA\r\n");
			break;
		case 1:
			Print("BBBBBBBBBBBBBBBBBBBB\r\n");
			break;
		case 2:
			Print("CCCCCCCCCCCCCCCCCCCCCC\r\n");
			break;
		case 3:
			Print("DDDDDDDDDDDDDDDDDD\r\n");
			break;
	}
	#endif

	return &pcb_list[CurrentPCBno];
}

/*保存当前pcb*/
void SaveCurrentPCB(int ax,int cx, int dx, int bx, int sp, int bp, int si, int di, int ds ,int es,int fs,int gs, int ss,int ip, int cs,int fl)
{
	if(isProgramRunning == 0)
		return;
	#ifdef Debug
	Print("saving\r\n");
	#endif
	pcb_list[CurrentPCBno].status = BLOCKING;
	pcb_list[CurrentPCBno].regImg.AX = ax;
	pcb_list[CurrentPCBno].regImg.BX = bx;
	pcb_list[CurrentPCBno].regImg.CX = cx;
	pcb_list[CurrentPCBno].regImg.DX = dx;

	pcb_list[CurrentPCBno].regImg.DS = ds;
	pcb_list[CurrentPCBno].regImg.ES = es;
	pcb_list[CurrentPCBno].regImg.FS = fs;
	pcb_list[CurrentPCBno].regImg.GS = gs;
	pcb_list[CurrentPCBno].regImg.SS = ss;

	pcb_list[CurrentPCBno].regImg.IP = ip;
	pcb_list[CurrentPCBno].regImg.CS = cs;
	pcb_list[CurrentPCBno].regImg.Flags = fl;
	
	pcb_list[CurrentPCBno].regImg.DI = di;
	pcb_list[CurrentPCBno].regImg.SI = si;
	pcb_list[CurrentPCBno].regImg.SP = sp;
	pcb_list[CurrentPCBno].regImg.BP = bp;
}

void Schedule(){
	#ifdef Debug
	Print("scheduling\r\n");
	#endif
	if(isProgramRunning == 0)
		return;
	CurrentPCBno = CurrentPCBno+1;
	if(CurrentPCBno == processNum)
		CurrentPCBno = 0;

	pcb_list[CurrentPCBno].status = RUNING;
	#ifdef Debug
	switch(CurrentPCBno){
		case 0:
			Print("is AAA\r\n");
			break;
		case 1:
			Print("is BBBBB\r\n");
			break;
		case 2:
			Print("is CCCCCCC\r\n");
			break;
		case 3:
			Print("is DDDDDDDDDDD\r\n");
			break;
	}
	#endif
	return;
}

/*初始化pcb*/
void initPCB(PCB *pcb, int id, int seg, int off)
{
	pcb->ID = id;
	pcb->status = READY;
	pcb->regImg.GS = 0xb800;
	pcb->regImg.CS = seg;
	pcb->regImg.SS = seg;
	pcb->regImg.ES = seg;
	pcb->regImg.DS = seg;
	pcb->regImg.FS = seg;
	pcb->regImg.IP = off;
	pcb->regImg.DI = 0;
	pcb->regImg.SI = 0;
	pcb->regImg.BP = 0;
	pcb->regImg.SP = off - 4;
	pcb->regImg.BX = 0;
	pcb->regImg.AX = 0;
	pcb->regImg.CX = 0;
	pcb->regImg.DX = 0;
	pcb->regImg.Flags = 512;
}

/*创建新的进程，在载入用户程序时创建*/
void createNewProcess(){
	#ifdef Debug
	Print("creating\r\n");
	#endif
	if(processNum < MAX_NrPCB){
		initPCB( &pcb_list[processNum] ,processNum, currentSeg, SP_OFF);
		currentSeg += 0x1000;
		processNum++;
	}
	else
	    ;/*进程数太多*/
}
