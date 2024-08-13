#define _CRT_SECURE_NO_WARNINGS 1

#include<stdio.h>
#include<malloc.h>
#include<stdlib.h>

#define MAXSIZE 100 //定义串的最大长度

#define OK 1
#define ERROR 0  

#define TRUE 1
#define FALSE 0

#define OVERFLOW -2	  //指针空
#define CORRECT 3	  //正确的argc个数

#define BIG 1		  //strcompare判断 
#define EQUAL 0		  //strcompare判断 
#define SMALL -1      //strcompare判断 

#define Status int    //Status是函数的类型,其值是函数结果状态代码，如OK等

#define ADD 2		  //串从下标1处存放，附加值为串开辟更多空间

#define INIT 0		  //int类型初始化数值

typedef struct
{
	char* ch;
	int length;//总长度 
}String;//声明字符串结构体,base[0]用于存放字符串总长度

//求串长度
int str_len(char* str)
{
	if (!str)
	{
		return OVERFLOW;
	}

	int idx = INIT;

	while (str[idx])
	{
		idx++;
	}

	return idx;
}

//载入串的内容 
Status strAssign(char* target, String* str)
{
	if (!target|| !str)
		return OVERFLOW;

	int Len = str_len(target);//求解总长度
	int i = INIT;//初始化 

	str->ch[i] = Len;//第一位存放总长度，之后有效数据从1开始

	for (i = 1; i <= Len; i++)
	{
		str->ch[i] = target[i - 1];
	}

	str->length = Len;
	str->ch[i] = '\0';//加入结束符

	return OK;
}


//字典序比较串
int strCompare(String* stringa, String* stringb)
{
	if (!stringa || !stringb)
	{
		return OVERFLOW;
	}

	int idx = INIT;
	for (idx; idx < stringa->length || idx < stringb->length; idx++)
	{
		if (stringa->ch[idx] == stringb->ch[idx])
		{
			continue;
		}
		else if (stringa->ch[idx] > stringb->ch[idx])
		{
			return BIG;
		}
		else
		{
			return SMALL;
		}
	}
	if (stringa->length > stringb->length)
	{
		return BIG;
	}
	else if(stringa->length < stringb->length)
	{
		return SMALL;
	}
	return EQUAL;
	
}//进行比较，输入两个字符串，a>b返回BIG a=b返回EQUAL a<b返回SMALL


 //定义清空字符串操作
Status strClear(String* str)
{
	if (!str)
	{
		return OVERFLOW;
	}

	str->length = INIT;
	free(str->ch);

	str->ch = (char*)malloc(MAXSIZE * sizeof(char));

	return OK;
}

Status get_next(String* pattern, int* next)
{
	if (! pattern || ! pattern->ch)
	{
		return OVERFLOW;
	}

	int i = INIT;
	i = 1;//next的下标，从1开始
	next[i] = INIT;
	next[0] = pattern->length;

	int k = 0;//k为可以满足条件的最大长度值

	while (i < pattern->length)
	{
		if (k == 0 || pattern->ch[i] == pattern->ch[k])
		{
			i++;
			k++;
			next[i] = k;
		}

		else
		{
			k = next[k];//当不满足上述条件的时候，直接进行处理，让k取next[k]
		}		

	}

	return OK;
}


//KMP查找算法
int index_KMP(String* objective, String* pattern, int pos)
//objective为目标串，pattern为模式串，pos为起始比较位置
{
	if (!objective || !pattern)
	{
		return OVERFLOW;
		exit(OVERFLOW);
	}//指针检查

	if (pos<0 || pos>objective->length)
		return ERROR;//下标检查

	int* next = (int*)malloc((pattern->length + ADD) * sizeof(int));
	if (!next)
		return ERROR;//next数组下标从1开始
	for (int idx = 0; idx < pattern->length + ADD; idx++)
	{
		next[idx] = 0;
	}
	

	get_next(pattern, next);

	int i = pos;
	int k = 1;

	while (i <= objective->length && k <= pattern->length)
	{

		if (k == 0 || objective->ch[i] == pattern->ch[k])
		{
			++k;
			++i;
		}//如果为0或两个相等，那么向后移动一位，

		else
		{
			k = next[k];//如果匹配失败，直接进入next[k]位置进行匹配与判断
		}
	}

	free(next);

	if (k > pattern->length)
	{
		return i - pattern->length;
	}
	else
	{
		return -1;
	}
}



//初始化字符串结构体
Status InitString(String* str, int strLen)
{
	if (!str)
	{
		return OVERFLOW;
	}

	str->length = strLen;
	str->ch = (char*)malloc((str->length + ADD) * sizeof(char));
	return OK;
}



int main(int argc, char** argv)
{
	if (argc != CORRECT)
	{
		printf("ERROR_01");
		exit(0);
	}//命令行参数检查

	int ans = INIT,pos=INIT;//定义index_KMP返回值接受、查找开始位置
	String* objective = (String*)malloc(sizeof(String));

	if (!objective)
	{
		return OVERFLOW;
	}

	InitString(objective, str_len(argv[1]));//初始化目标串

	//重写strlen函数

	String* pattern = (String*)malloc(sizeof(String));

	if (!pattern)
	{
		return OVERFLOW;
	}

	InitString(pattern, str_len(argv[2]));//初始化模式串


	strAssign(argv[1], objective);//写入目标串
	strAssign(argv[2], pattern);//写入模式串

	ans=index_KMP(objective, pattern, pos);//KMP算法

	free(objective);
	free(pattern);


	if (ans > 0)
	{
		printf("%d", ans);
	}
	else
	{
		printf("-1");
	}

	return 0;
}