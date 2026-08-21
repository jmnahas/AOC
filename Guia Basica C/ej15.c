#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>


int factoril(int n) {
    if (n==0)
    {
        return 1;
    } else{
        return (n*factoril(n-1));
    }
    
}
int main() {
    
    int n;
    printf("Ingrese un numero: ");
    scanf("%d", &n); 
    printf("%d \n", factoril(n));
}