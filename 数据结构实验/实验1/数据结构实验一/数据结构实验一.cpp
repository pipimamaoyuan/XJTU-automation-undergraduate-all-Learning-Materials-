#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<string>

#define FALSE 0
#define OK 1
#define STACK_INIT_SIZE 100//存储空间初始分配量 
#define STACKINCREMENT 10//分配增量

typedef int Status;

typedef double ElemType;


typedef struct
{
	double* base;
	double* top;
	int stacksize;
}NumStack;

typedef struct
{
	char* base;
	char* top;
	int stacksize;
}OpeStack;

/*********************************************/
/*初始栈*/
Status InitNumStack(NumStack& s) {
	s.base = (ElemType*)malloc(STACK_INIT_SIZE * sizeof(ElemType));
	if (!s.base) {
		exit(1);//分配内存错误退出
	}
	s.top = s.base;
	s.stacksize = STACK_INIT_SIZE;//初始化数字栈容量
	return OK;
}

Status InitOpeStack(OpeStack& s) {
	s.base = (char*)malloc(STACK_INIT_SIZE * sizeof(char));
	if (!s.base) {
		exit(1);//分配内存错误退出
	}
	s.top = s.base;
	s.stacksize = STACK_INIT_SIZE;//初始化数字栈容量
	return OK;
}

/*获取栈顶元素*/
ElemType GetNumTop(NumStack s)  
{
	ElemType e;
	if (s.top == s.base) 
	{
		return 0;
	}
	e = *(s.top - 1);
	return e;
}

char GetOpeTop(OpeStack s)
{
	char e;
	if (s.top == s.base)
	{
		return 0;
	}
	e = *(s.top - 1);
	return e;
}

/*压栈*/
Status NumPush(NumStack& s, ElemType e) 
{ 

	if (s.top - s.base >= s.stacksize) //如果栈满，扩充空间 
	{
		s.base = (ElemType*)realloc(s.base, (s.stacksize + STACKINCREMENT) * sizeof(ElemType));
		if (!s.base) 
		{
			exit(1);
		}
		s.top = s.base + s.stacksize;
		s.stacksize += STACKINCREMENT;
	}
	*s.top++ = e;//赋值后栈顶指针+1 
	return OK;
}

Status OpePush(OpeStack& s, char e)
{

	if (s.top - s.base >= s.stacksize) //如果栈满，扩充空间 
	{
		s.base = (char*)realloc(s.base, (s.stacksize + STACKINCREMENT) * sizeof(char));
		if (!s.base)
		{
			exit(1);
		}
		s.top = s.base + s.stacksize;
		s.stacksize += STACKINCREMENT;
	}
	*s.top++ = e;//赋值后栈顶指针+1 
	return OK;
}

/*弹栈*/
Status NumPop(NumStack& s, double& e) 
{ 
	if (s.top == s.base) 
	{
		return FALSE;//栈空
	}

	e = *--s.top;//栈顶指针-1，给e赋值 
	return OK;
}

Status OpePop(OpeStack& s, char& e) 
{ 
	if (s.top == s.base) {
		return FALSE;
	}
	e = *--s.top;//栈顶指针-1，给e赋值 
	return OK;
}

/*判断运算符栈的栈顶元素a和读入元素b的优先级*/
char Precede(char a, char b) 
{ 
	if (a == '+' || a == '-') 
	{
		if (b == '+' || b == '-' || b == '>' || b == '#' || b == ')' || b == ']')
			return '>';
		else return '<';
	}
	if (a == '*' || a == '/' || a == '^') 
	{
		if (b == '(' || b == '[')
			return '<';
		else return '>';
	}
	if (a == '(') 
	{
		if (b == ')')
			return '=';
		else return '<';
	}
	if (a == '[') 
	{
		if (b == ']')
			return '=';
		else return '<';
	}
	if (a == '#') 
	{
		if (b == '#')
			return '=';
		else return '<';
	}
	return FALSE;
}//Precede

/*运算函数*/
double Operate(double a, char x, double b) 
{
	switch (x) 
	{
	case '+':
		return a + b;
	case '-':
		return a - b;
	case '*':
		return a * b;
	case '/':
		if (b != 0)
			return a / b;
		else
			printf("ERROR_03");//分子不能为0，跳出错误
		exit(0);
	case '^':
		return (float)pow(a, b);
	}
	return FALSE;
}

/*检查括号匹配函数*/
void BracketCheck(std::string s) 
{   
	OpeStack e;
	char x;
	InitOpeStack(e);
	int len = (int)s.length();//strlen(s);
	int i = 0;
	for (i = 0; i < len; i++) 
	{
		switch (s[i]) 
		{
		case '(':
		case '[':
			OpePush(e, s[i]);
			break;
		case ')':
			if (GetOpeTop(e) != '(')
			{
				printf("ERROR_02"); exit(0);
			}
			else OpePop(e, x);
			break;
		case ']':
			if (GetOpeTop(e) != '[')
			{
				printf("ERROR_02"); exit(0);
			}
			else OpePop(e, x);
			break;
		}
	}
	if (GetOpeTop(e) != 0)
	{
		printf("ERROR_02"); exit(0);
	}
}

/*表达式合法检查函数*/
void ligit(std::string s)
{
	int len = (int)s.length();
	const char calculator[6] = { '+','-','*','/','^','.' };
	for (int i = 0; i < 6; i++)
	{
		if (s[0] == calculator[i] || s[len - 1] == calculator[i])
		{
			printf("ERROR_02"); 
			exit(0);
		}
	}//首位末位不能出现运算符
	for (int i = 0; i < len - 1; i++)
	{
		if 
			(
			(s[i + 1] == '+' || s[i + 1] == '-' || s[i + 1] == '*' || s[i + 1] == '/' || s[i + 1] == '^' || s[i + 1] == '.')
			&& (s[i] == '+' || s[i] == '-' || s[i] == '*' || s[i] == '/' || s[i] == '^' || s[i] == '.')
			)
		{
			printf("ERROR_02");
			exit(0);
		}
	}//运算符不能连续出现
	BracketCheck(s);//检查括号匹配
}

/*计算表达式函数*/
double evaluate(std::string expression)
{
	expression += '#';//加入结束标志符号
	char currentchar, nextchar;//当前操作字符和下一个操作字符
	int itr; //迭代值
	int len = (int)expression.length();//字符串长度

	NumStack Num;
	OpeStack Ope;
	InitOpeStack(Ope);
	InitNumStack(Num);

	OpePush(Ope, '#');//运算符栈压入结束符

	itr = 1;//赋值迭代值
	currentchar = expression[0];//赋值当前字符
	while (currentchar != '#' || GetOpeTop(Ope) != '#')//条件：Nums栈不空且
	{
		/****************如果数字，多位数与小数判断，整体转换压栈*************/

		float integer = 0, decimal = 0;//整数小数分别计算
		if ((currentchar >= '0' && currentchar <= '9') || currentchar == '.')
		{

			while (currentchar >= '0' && currentchar <= '9') // 读入连续的数字
			{
				integer = integer * 10 + (currentchar - '0');
				currentchar = expression[itr++];
			}//整数计算

			if (currentchar == '.') //小数点检测
			{
				currentchar = expression[itr++];
				if (currentchar < '0' || currentchar > '9')
				{
					printf("ERROR_02"); exit(0);
				}//小数点后无数字，出错

				else
				{
					while (currentchar >= '0' && currentchar <= '9')
					{
						int m = 1;
						decimal = decimal + (currentchar - '0') * (float)pow(10, (-m));//小数位计算
						m++;
						currentchar = expression[itr++];
						if (currentchar == '.')
						{
							printf("ERROR_02"); exit(0);
						}//重复点出现
					}
				}
			}
			integer = integer + decimal;//计算小数整数和值
			NumPush(Num, integer);//数字入栈
		}
		/****************************************************************/


		/************************如果运算符，判断运算级*******************/
		else if (currentchar == '+' || currentchar == '-' || currentchar == '*' || currentchar == '/' || currentchar == '(' || currentchar == ')' || currentchar == '[' || currentchar == ']' || currentchar == '^' || currentchar == '#')
		{
			switch (Precede(GetOpeTop(Ope), currentchar))
			{
			case '<':OpePush(Ope, currentchar); currentchar = expression[itr++]; break;
				//操作符压栈
			case '=':OpePop(Ope, nextchar); currentchar = expression[itr++]; break;
				//操作符弹栈
			case '>':
				OpePop(Ope, nextchar);//操作符弹栈
				ElemType a, b;
				NumPop(Num, b);
				NumPop(Num, a);
				NumPush(Num, Operate(a, nextchar, b));
				break;
				//数字弹栈，赋值a,b，运算结果压栈
			}
		}
		/*********************运算完成*************************/



		/******************检测到非法运算符******************/
		else
		{
			printf("ERROR_02");
			exit(0);
		}
		/****************************************************/
	}
	//运算结束，如有结果，为数字栈顶数字
	return GetNumTop(Num);
}

/*主函数*/
int main(int argc, char* argv[])
{
	if (argc != 2)
	{
		printf("ERROR_1");
		exit(0);
	}//判断命令行参数是否正确

	std::string expression= argv[1];//存表达式expression，将命令行参数转为字符串

	ligit(expression);//表达式合法检查

	double ans = evaluate(expression);//计算结果

	printf("%g",ans);//格式输出，末尾无0
}