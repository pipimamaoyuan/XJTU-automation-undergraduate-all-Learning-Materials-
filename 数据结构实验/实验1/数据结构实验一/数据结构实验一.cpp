#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<string>

#define FALSE 0
#define OK 1
#define STACK_INIT_SIZE 100//�洢�ռ��ʼ������ 
#define STACKINCREMENT 10//��������

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
/*��ʼջ*/
Status InitNumStack(NumStack& s) {
	s.base = (ElemType*)malloc(STACK_INIT_SIZE * sizeof(ElemType));
	if (!s.base) {
		exit(1);//�����ڴ�����˳�
	}
	s.top = s.base;
	s.stacksize = STACK_INIT_SIZE;//��ʼ������ջ����
	return OK;
}

Status InitOpeStack(OpeStack& s) {
	s.base = (char*)malloc(STACK_INIT_SIZE * sizeof(char));
	if (!s.base) {
		exit(1);//�����ڴ�����˳�
	}
	s.top = s.base;
	s.stacksize = STACK_INIT_SIZE;//��ʼ������ջ����
	return OK;
}

/*��ȡջ��Ԫ��*/
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

/*ѹջ*/
Status NumPush(NumStack& s, ElemType e) 
{ 

	if (s.top - s.base >= s.stacksize) //���ջ��������ռ� 
	{
		s.base = (ElemType*)realloc(s.base, (s.stacksize + STACKINCREMENT) * sizeof(ElemType));
		if (!s.base) 
		{
			exit(1);
		}
		s.top = s.base + s.stacksize;
		s.stacksize += STACKINCREMENT;
	}
	*s.top++ = e;//��ֵ��ջ��ָ��+1 
	return OK;
}

Status OpePush(OpeStack& s, char e)
{

	if (s.top - s.base >= s.stacksize) //���ջ��������ռ� 
	{
		s.base = (char*)realloc(s.base, (s.stacksize + STACKINCREMENT) * sizeof(char));
		if (!s.base)
		{
			exit(1);
		}
		s.top = s.base + s.stacksize;
		s.stacksize += STACKINCREMENT;
	}
	*s.top++ = e;//��ֵ��ջ��ָ��+1 
	return OK;
}

/*��ջ*/
Status NumPop(NumStack& s, double& e) 
{ 
	if (s.top == s.base) 
	{
		return FALSE;//ջ��
	}

	e = *--s.top;//ջ��ָ��-1����e��ֵ 
	return OK;
}

Status OpePop(OpeStack& s, char& e) 
{ 
	if (s.top == s.base) {
		return FALSE;
	}
	e = *--s.top;//ջ��ָ��-1����e��ֵ 
	return OK;
}

/*�ж������ջ��ջ��Ԫ��a�Ͷ���Ԫ��b�����ȼ�*/
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

/*���㺯��*/
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
			printf("ERROR_03");//���Ӳ���Ϊ0����������
		exit(0);
	case '^':
		return (float)pow(a, b);
	}
	return FALSE;
}

/*�������ƥ�亯��*/
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

/*���ʽ�Ϸ���麯��*/
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
	}//��λĩλ���ܳ��������
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
	}//�����������������
	BracketCheck(s);//�������ƥ��
}

/*������ʽ����*/
double evaluate(std::string expression)
{
	expression += '#';//���������־����
	char currentchar, nextchar;//��ǰ�����ַ�����һ�������ַ�
	int itr; //����ֵ
	int len = (int)expression.length();//�ַ�������

	NumStack Num;
	OpeStack Ope;
	InitOpeStack(Ope);
	InitNumStack(Num);

	OpePush(Ope, '#');//�����ջѹ�������

	itr = 1;//��ֵ����ֵ
	currentchar = expression[0];//��ֵ��ǰ�ַ�
	while (currentchar != '#' || GetOpeTop(Ope) != '#')//������Numsջ������
	{
		/****************������֣���λ����С���жϣ�����ת��ѹջ*************/

		float integer = 0, decimal = 0;//����С���ֱ����
		if ((currentchar >= '0' && currentchar <= '9') || currentchar == '.')
		{

			while (currentchar >= '0' && currentchar <= '9') // ��������������
			{
				integer = integer * 10 + (currentchar - '0');
				currentchar = expression[itr++];
			}//��������

			if (currentchar == '.') //С������
			{
				currentchar = expression[itr++];
				if (currentchar < '0' || currentchar > '9')
				{
					printf("ERROR_02"); exit(0);
				}//С����������֣�����

				else
				{
					while (currentchar >= '0' && currentchar <= '9')
					{
						int m = 1;
						decimal = decimal + (currentchar - '0') * (float)pow(10, (-m));//С��λ����
						m++;
						currentchar = expression[itr++];
						if (currentchar == '.')
						{
							printf("ERROR_02"); exit(0);
						}//�ظ������
					}
				}
			}
			integer = integer + decimal;//����С��������ֵ
			NumPush(Num, integer);//������ջ
		}
		/****************************************************************/


		/************************�����������ж����㼶*******************/
		else if (currentchar == '+' || currentchar == '-' || currentchar == '*' || currentchar == '/' || currentchar == '(' || currentchar == ')' || currentchar == '[' || currentchar == ']' || currentchar == '^' || currentchar == '#')
		{
			switch (Precede(GetOpeTop(Ope), currentchar))
			{
			case '<':OpePush(Ope, currentchar); currentchar = expression[itr++]; break;
				//������ѹջ
			case '=':OpePop(Ope, nextchar); currentchar = expression[itr++]; break;
				//��������ջ
			case '>':
				OpePop(Ope, nextchar);//��������ջ
				ElemType a, b;
				NumPop(Num, b);
				NumPop(Num, a);
				NumPush(Num, Operate(a, nextchar, b));
				break;
				//���ֵ�ջ����ֵa,b��������ѹջ
			}
		}
		/*********************�������*************************/



		/******************��⵽�Ƿ������******************/
		else
		{
			printf("ERROR_02");
			exit(0);
		}
		/****************************************************/
	}
	//������������н����Ϊ����ջ������
	return GetNumTop(Num);
}

/*������*/
int main(int argc, char* argv[])
{
	if (argc != 2)
	{
		printf("ERROR_1");
		exit(0);
	}//�ж������в����Ƿ���ȷ

	std::string expression= argv[1];//����ʽexpression���������в���תΪ�ַ���

	ligit(expression);//���ʽ�Ϸ����

	double ans = evaluate(expression);//������

	printf("%g",ans);//��ʽ�����ĩβ��0
}