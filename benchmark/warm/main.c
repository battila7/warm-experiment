#include <stdio.h>
#include <stdlib.h>

#include "warm.h"

int main(int argc, char **argv)
{
    warm_t a, b, c;

    b.size = 1;
    b.data = malloc(sizeof(warm_data_t));
    b.data[0] = 49;

    c.size = 1;
    c.data = malloc(sizeof(warm_data_t));
    c.data[0] = 20;

    warm_add(&a, &b, &c);

    printf("%lu\n", a.size);
    printf("%llu\n", *a.data);

    return 0;
}
