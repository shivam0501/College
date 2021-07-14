#include<iostream.h>
#include<conio.h>
int i,j,start,flag,r[4],g[4],d[11];
void display()
{for(int k=0;k<=3;k++)
 {cout<<r[k]<<" ";
 }cout<<"\n";
}
void xor()
{for(int k=0;k<=3;k++)
 {if(r[k]==g[k])
    r[k]=0;
  else
    r[k]=1;
 }
}
void decr()
{i=0;
 while(r[i]==0&&i<=3)
   i++;
}
void formr()
{int move;
 for(j=0;j<=3 && start<=10;j++)
 {if(i>=4)
   move=d[start++];
  else
   move=r[i++];
  r[j]=move;
 }
 if(j==4)
   flag=0;
 else
   flag=1;
}
void calc()
{while(flag==0)
 {xor(); decr(); formr(); display();
 }
}
void main()
{clrscr(); flag=0;
 //Entering data;
 cout<<"Enter the 8 bit data\n";
 for(i=0;i<=7;i++)
   cin>>d[i];
 cout<<"Enter the 4 bit generator\n";
 for(i=0;i<=3;i++)
   cin>>g[i];
 //appending 3 zeroes
 d[8]=d[9]=d[10]=0;
 for(i=0;i<=3;i++)
   r[i]=d[i];
 start=4;  calc();
 for(i=8;i<=10;i++)
   d[i]=r[i-7];
 cout<<"Transmitted word is\n";
 for(i=0;i<=10;i++)
   cout<<d[i]<<" ";
 cout<<"\nEnter received word\n";
 for(i=0;i<=10;i++)
   cin>>d[i];
 for(i=0;i<=3;i++)
   r[i]=d[i];
 flag=0;start=4;
 calc();decr();
 if(i<=3)
   cout<<"ERROR in transmission";
 else
   cout<<"NO ERROR in transmission";
 getch();
}
/*OUTPUT:-
Enter the 8 bit data

1
0
1
1
0
1
0
0
Enter the 4 bit generator
1
0
1
1
0 1 0 0
1 1 1 1
1 0 0 0
1 1 0 0
0 1 1 1
Transmitted word is
1 0 1 1 0 1 0 0 1 1 1
Enter received word
1
0
1
1
1
1
0
0
1
1
1
1 1 0 0
1 1 1 1
1 0 0 1
1 0 1 0
ERROR in transmission


*/