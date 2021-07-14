#include<stdio.h>
#include<conio.h>
#include<string.h>

char EXOR(char a, char b) {
	if(a==b) return '0';
	else return '1';
}

void main() {

	char genCode[100]={"11001"}, frameCode[100] = {"10100010110000"}, tempCode[100], remCode[100];
	int i, j, k, l = 0;
	clrscr();

	printf("Enter the Frame: ");
	scanf("%s", frameCode);

	printf("Enter the Generator code: ");
	scanf("%s", genCode);

	i = 1;
	while(i<strlen(genCode)) {
		strcat(frameCode, "0");
		i++;
	}

	back:
	strcpy(tempCode, frameCode);

	while(strlen(genCode)<=strlen(tempCode)) {

		i = 0, j = 0, k = 0;
		while(i<strlen(genCode))
			remCode[i++] = EXOR(genCode[j++], tempCode[k++]);
		remCode[strlen(genCode)] = '\0';
		i = 0, j = 0;
		while(i<strlen(genCode))
			tempCode[i++] = remCode[j++];

		i = 0; k = 0;
		while(i<strlen(genCode)) {
			if(tempCode[i]=='0') k++;
			if(tempCode[i]=='1') break;
			i++;
		}

		i = 0; j = k;
		while(j<strlen(tempCode))
			tempCode[i++] = tempCode[j++];

		tempCode[strlen(tempCode)-k] = '\0';
	}

	printf("\n%s", tempCode);

	frameCode[strlen(frameCode)-strlen(tempCode)] = '\0';
	strcat(frameCode, tempCode);

	printf("\n%s", frameCode);


	if(l==0) {
		l = 1;
		goto back;
	}

	getch();

}
