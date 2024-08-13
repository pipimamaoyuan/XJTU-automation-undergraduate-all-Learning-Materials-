#include<stdio.h>
#include<malloc.h>
#include<string.h>
#include<stdlib.h>
#define Maxleaf 30
#define Maxnode 1000
#define Max 100000
#define Maxsize 100
#define OK 1
#define error -1
typedef struct
{
    char ch;                     //定义字符型的结点名
    int weight;                  //定义一个整型权值变量
    int lchild, rchild, parent;    //定义左、右孩子及双亲指针
}hufmtree;
typedef struct
{
    char bits[Maxsize];          //定义一个字符型的数组存储结点的编码
    int start;                   //标志字符串起点
    char ch;                     //存储结点的名称
}codetype;
//哈夫曼树的创建
void huffman(hufmtree tree[], int n, char s2[], int Weigh[])
{
    int i, j, p1, p2;
    float small1, small2, f;
    char c;
    int m = 2 * n - 1;                 //总的结点数目
    for (i = 0; i < m; i++)             //结点信息的初始化
    {
        tree[i].parent = 0;
        tree[i].lchild = -1;
        tree[i].rchild = -1;
        tree[i].weight = 0;
    }
    for (i = 0; i < n; i++)             //输入叶子结点的结点名和权值
    {
        
        tree[i].ch = s2[i];
        tree[i].weight = Weigh[i];
    }
    //找出剩余结点中的权值最小的两个结点组合
    for (i = n; i < m; i++)
    {
        p1 = 0; p2 = 0;
        small1 = Max; small2 = Max;
        for (j = 0; j < i; j++)
            if (tree[j].parent == 0)            //如果该结点不存在双亲
                if (tree[j].weight < small1)        //结点的权值小于small1时
                {
                    small2 = small1;
                    small1 = tree[j].weight;
                    p2 = p1;
                    p1 = j;
                }
                else if (tree[j].weight < small2)   //结点的权值大于small1但是小于small2
                {
                    small2 = tree[j].weight;
                    p2 = j;
                }
        tree[p1].parent = i;
        tree[p2].parent = i;
        tree[i].lchild = p1;
        tree[i].rchild = p2;
        tree[i].weight = tree[p1].weight + tree[p2].weight;
    }
    printf("字符\t权重\t左孩子\t右孩子\t父母\n"); 
    for(i=0;i<n;i++)
    {
       printf("%c\t%d\t%d\t%d\t%d\n",tree[i].ch,tree[i].weight,tree[i].lchild,tree[i].rchild,tree[i].parent);
    }
}
//哈夫曼的编码函数
void huffmancode(codetype code[], hufmtree tree[], int n)
{
    int i, c, p;
    codetype cd;
    //从下往上遍历哈夫曼树，进行编码         
    for (i = 0; i < n; i++)
    {
        cd.start = n;              //编码的结束位置
        cd.ch = tree[i].ch;
        c = i;
        p = tree[i].parent;
        //当p是根结点的双亲时跳出循环      
        while (p != 0)
        {
            cd.start--;
            if (tree[p].lchild == c)         //如果是它的左孩子
                cd.bits[cd.start] = '0';     //则输出0
            else
                cd.bits[cd.start] = '1';     //否则就是右孩子输出1
            c = p;
            p = tree[p].parent;
        }
        code[i] = cd;
    }
}
void decode(hufmtree tree[], int m, char b[])     //译码函数
{
    int i, j = 0, k = 0;
    i = m - 1;
   
    while (b[j] != '\0')
    {
        if (b[j] == '0')                                         //如果编码是0
            i = tree[i].lchild;                                 //将该结点左孩子的序号赋给i
        else
        {
            if (b[j] == '1')
                i = tree[i].rchild;   //如果编码是1，将该结点右孩子的序号赋给i
        }
        if (tree[i].lchild == -1)         //如果该结点左孩子的序号等于-1，即根结点
        {
            printf("%c", tree[i].ch);    //输出该结点名
            i = m - 1;                        //回到根结点
        }
        j++;
    }

    if (tree[i].parent != 0)
    {
        printf("ERROR_3");
        exit(0);
    }
}

int get(int weigh[], char s[], char s2[], int Weigh[])
{
    int i = 0;
    int j = 0;
    int k = 0;
    while (s[i] != '\0')
    {
        if (s[i] >= 'a' && s[i] <= 'z')
            weigh[s[i] - 'a' + 1]++;
        if (s[i] == ' ')
            weigh[0]++;
        i++;
    }
    for (j = 1; j <= 26; j++)
    {
        if (weigh[j] != 0)
        {
            s2[k] = j + 'a' - 1;
            Weigh[k] = weigh[j];
            k++;
        }
    }
    if (weigh[0] != 0)
    {
        s2[k] = ' ';
        Weigh[k] = weigh[0];
        k++;
    }
    s2[k] = '\0';
    return k;
}

int main(int argc, char* argv[])
{
    if (argc != 3)
    {
        printf("ERROR_01");
        return error;
    }
    if (strlen(argv[1]) < 20)
    {
        printf("ERROR_02");
        return error;
    }
    int i, j, m;
    hufmtree tree[Maxnode];
    codetype code[Maxleaf];
    int weigh[50] = { 0 }, Weigh[50] = { 0 };
    char s2[50];
    int length = 0;
    length = get(weigh, argv[1], s2, Weigh);
    //getchar();
    //调用哈夫曼创建函数     
    huffman(tree, length, s2, Weigh);

    //调用哈夫曼编码函数
    huffmancode(code, tree, length);

    //输出结点对应的哈夫曼编码
    for (i = 0; i < length; i++)
    {
        printf("%c:", code[i].ch);
        for (j = code[i].start; j < length; j++)
            printf("%c", code[i].bits[j]);
        printf("\n");
    }
    m = 2 * length - 1;
    //译码
    decode(tree, m, argv[2]);
    return 0;
}
