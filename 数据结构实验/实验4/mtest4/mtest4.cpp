#include<stdio.h>
#include<iostream>
#include<string.h>
#define INF 1000 //代表权值无穷大 
#define MAXVEX 13 
#define true 1
#define false 0
#define ERROR -1
using namespace std;
typedef struct
{
    string V[MAXVEX];      //顶点数组 
    int E[MAXVEX][MAXVEX]; //权值数组 
}Graph;
void Dijkstra(Graph G, int v0, int p[][MAXVEX], int Dij[])
{
    int v = 0, k = 0, i = 0, j = 0, min = 0;
    int final[MAXVEX];
    for (v = 0; v < MAXVEX; v++)
    {
        final[v] = false;//未被访问 
        Dij[v] = G.E[v0][v];
        for (k = 0; k < MAXVEX; k++)
            p[v][k] = ERROR;//初始化 
        if (Dij[v] < INF)
        {
            p[v][0] = v0; p[v][1] = v;
        }
    }
    Dij[v0] = 0;
    final[v0] = true;//已访问 
    for (i = 1; i < MAXVEX; i++)
    {
        min = INF;
        for (k = 0; k < MAXVEX; k++)
            if (!final[k] && Dij[k] < min)
            {
                v = k;
                min = Dij[k];
            }
        final[v] = true;//已访问 
        for (k = 0; k < MAXVEX; k++)
        {
            if (!final[k] && min < INF && G.E[v][k] < INF && (min + G.E[v][k] < Dij[k]))
            {

                Dij[k] = min + G.E[v][k];
                for (j = 0; j < MAXVEX; j++)
                {
                    p[k][j] = p[v][j];
                    if (p[k][j] == ERROR)
                    {
                        p[k][j] = k;
                        break;
                    }
                }

            }
        }
    }
}

//创建图 
Graph Create(Graph XJTU)
{
    int i, j;
    for (i = 0; i < MAXVEX; i++)
        for (j = 0; j < MAXVEX; j++)
            XJTU.E[i][j] = INF;
    for (i = 0; i < MAXVEX; i++)
        XJTU.V[i] = "";

    XJTU.E[0][1] = 18; XJTU.E[0][10] = 22;
    XJTU.E[1][2] = 19; XJTU.E[1][1] = 18; XJTU.E[1][7] = 27;
    XJTU.E[2][1] = 19; XJTU.E[2][3] = 23; XJTU.E[2][8] = 32; XJTU.E[2][10] = 4;
    XJTU.E[3][2] = 23; XJTU.E[3][4] = 15; XJTU.E[3][7] = 4; XJTU.E[3][11] = 4;
    XJTU.E[4][3] = 15; XJTU.E[4][5] = 21; XJTU.E[4][9] = 8;
    XJTU.E[5][4] = 21; XJTU.E[5][6] = 30;
    XJTU.E[6][5] = 30; XJTU.E[6][9] = 14; XJTU.E[6][11] = 21; XJTU.E[6][12] = 20;
    XJTU.E[7][1] = 27; XJTU.E[7][3] = 4;
    XJTU.E[8][2] = 32; XJTU.E[8][9] = 4;
    XJTU.E[9][8] = 4; XJTU.E[9][4] = 8; XJTU.E[9][6] = 14;
    XJTU.E[10][0] = 22; XJTU.E[10][2] = 4;
    XJTU.E[11][3] = 4; XJTU.E[11][6] = 21; XJTU.E[11][12] = 43; XJTU.E[12][11] = 43; XJTU.E[12][6] = 20;  //鍒濆鍖栭偦鎺ョ煩闃?
    XJTU.V[0] = "北门"; XJTU.V[1] = "饮水思源"; XJTU.V[2] = "腾飞塔";
    XJTU.V[3] = "图书馆"; XJTU.V[4] = "教学主楼"; XJTU.V[5] = "活动中心";
    XJTU.V[6] = "南门"; XJTU.V[7] = "传送门1"; XJTU.V[8] = "传送门4";
    XJTU.V[9] = "宪梓堂"; XJTU.V[10] = "传送门3"; XJTU.V[11] = "传送门2"; XJTU.V[12] = "西迁馆";
    return XJTU;
}
int main(int argc, char* argv[])
{
    int Path = 0;
    // 判断命令行参数个数 
    if (argc != 3)
    {
        printf("ERROR_01");
        return ERROR;
    }
    Graph XJTU;
    //初始化图 
    XJTU = Create(XJTU);
    int i = 0, k = 0;
    int flag1 = 0, flag2 = 0;  //标志位 
    int begin = 0, end = 0;
    int num = 0;
    for (i = 0; i < MAXVEX; i++)
    {
        if (argv[1] == XJTU.V[i])
        {
            begin = i;
            flag1 = 1;
        }
        if (argv[2] == XJTU.V[i])
        {
            end = i;
            flag2 = 1;
        }
    }
    //判断输入是否有效 
    if (flag1 * flag2 != 1)
    {
        printf("ERROR_02");
        return ERROR;
    }
    int road[MAXVEX][MAXVEX] = { 0 };
    int mindistance[MAXVEX] = { 0 };
    Dijkstra(XJTU, begin, road, mindistance);
    for (k = 0; k < MAXVEX; k++)
    {
        if (road[end][k] == ERROR)
        {
            num = k;
            break;
        }
    }
    for (i = 0; i < num - 1; i++)
    {
        Path = road[end][i];
        //cout<<XJTU.V[Path]<<" ";//（输出路径） 
    }
    printf("%d", mindistance[end]);
    return 0;
}
