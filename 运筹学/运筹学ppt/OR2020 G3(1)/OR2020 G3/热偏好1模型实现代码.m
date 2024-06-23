n=37; %元素个数
a1=0;b1=0;a2=0;b2=0; %1上2下，a红b绿
accuracy=0;
for i=1:1:n-1
     for j=i+1:1:n
         a10=0;b10=0;a20=0;b20=0;
         if S1(i,2)==S1(j,2)
             continue;
         end
         k0=(S1(i,1)-S1(j,1))/(S1(i,2)-S1(j,2));
         b0=S1(i,1)-k0*S1(i,2);
         if k0<=0 || k0>10
             continue;
         end
         for i=1:1:n
             c=k0*S1(i,2)+b0;
             if S1(i,1)>c  %点在直线上方
                 if S1(i,3)==-1
                     a10=a10+1;
                 else
                     b10=b10+1;
                 end
             else
                 if S1(i,3)==-1
                     a20=a20+1;
                 else
                     b20=b20+1;
                 end
             end
         end
         accuracy0=(b10+a20)/n;
         forecast0=(a10+b10)/n;
         if accuracy0>accuracy && forecast0>=0.25
             accuracy=accuracy0;
             forecast=forecast0;
             k=k0;
             b=b0;
         end
         if accuracy0==accuracy && forecast0>forecast
             accuracy=accuracy0;
             forecast=forecast0;
             k=k0;
             b=b0;
         end
     end
end
k
b
accuracy
forecast
accuracy=0;
forecast=0;
for i=1:1:n
         a10=0;b10=0;a20=0;b20=0;a30=0;b30=0;
         b2=S1(i,1)-k*S1(i,2);
         if b2==b
             continue;
         end
         for j=1:1:n
             c1=k*S1(j,2)+b;
             c2=k*S1(j,2)+b2;
             if S1(j,1)>c1 && S1(j,1)>c2  %点在直线上方
                 if S1(j,3)==-1
                     a10=a10+1;
                 else
                     b10=b10+1;
                 end
             elseif S1(j,1)<c1 && S1(j,1)<c2
                 if S1(j,3)==-1
                     a20=a20+1;
                 else
                     b20=b20+1;
                 end
             else
                 if S1(j,3)==-1
                     a30=a30+1;
                 else
                     b30=b30+1;
                 end
             end
         end
         accuracy0=(b10+a20)/(a10+b10+a20+b20);
         forecast0=(a10+b10+a20+b20)/n;
         if accuracy0>accuracy && forecast0>=0.25
             accuracy=accuracy0;
             forecast=forecast0;
             b22=b2;
             a3=a30;
             b3=b30;
         end
         if accuracy0==accuracy && forecast0>forecast
             accuracy=accuracy0;
             forecast=forecast0;
             b22=b2;
             a3=a30;
             b3=b30;
         end
end
b22
accuracy
forecast
a3/(a3+b3)
b3/(a3+b3)