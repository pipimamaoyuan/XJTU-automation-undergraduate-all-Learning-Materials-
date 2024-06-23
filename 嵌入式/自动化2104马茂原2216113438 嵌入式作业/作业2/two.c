#include<stdio.h>

int main()
{
	int i;
	int a[4];
	int b[4]={0,1,2,3};
	int c[4]={4,5,6,7};
	for(i=0;i<2;i++)
		{
			a[i*2]=b[i*2]*c[i*2];
			a[i*2+1]=b[i*2+1]*c[i*2+1];
		}
	return 0;
}
