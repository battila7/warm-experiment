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
    b.data[0] = -1;
    b.data[1] = -1;


    c.size = 3;
    c.data = malloc(3 * sizeof(warm_data_t));
    c.data[0] = 1;
    c.data[1] = 30;
    c.data[2] = 68;

    warm_add(&a, &b, &c);

    printf("\nResults\n");
    print32(a.size);
    print64(*a.data);
    printf("%llu\n", *(a.data + 1));
    printf("%llu\n", *(a.data + 2));
    printf("%llu\n", *(a.data + 3));

    return 0;
}
