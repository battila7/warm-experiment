#include <stdio.h>
#include <stdlib.h>

#include "warm.h"

void print32(const unsigned long a)
{
    printf("%lu\n", a);
}

void print64(const unsigned long long a)
{
    printf("%llu\n", a);
}

int main(int argc, char **argv)
{
    warm_t a, b, c;

    int size = 2;

    b.size = 2;
    b.data = malloc(size * sizeof(warm_data_t));
    b.data[0] = 10;
    b.data[1] = 67;


    c.size = 2;
    c.data = malloc(size * sizeof(warm_data_t));
    c.data[0] = 20;
    c.data[1] = 30;

    warm_add(&a, &b, &c);

    printf("\nResults\n");
    print32(a.size);
    print64(*a.data);
    printf("%llu\n", *(a.data + 1));
    printf("%llu\n", *(a.data + 2));

    return 0;
}
