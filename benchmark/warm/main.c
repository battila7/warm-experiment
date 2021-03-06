#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#include "warm.h"

#define ITERATIONS 10000000
#define SIZE 100

int main(int argc, char **argv)
{
    warm_t result, left, right;

    result.data = malloc((SIZE + 1) * sizeof(warm_data_t));
    left.size = SIZE;
    right.size = SIZE;
    left.data = malloc(SIZE * sizeof(warm_data_t));
    right.data = malloc(SIZE * sizeof(warm_data_t));

    for (int i = 0; i < SIZE; ++i)
    {
        left.data[i] = 678123;
        right.data[i] = 1234789;
    }

    clock_t start = clock();

    for (unsigned long long i = 0; i < ITERATIONS; ++i)
    {
        warm_add(&result, &left, &right);
    }

    clock_t end = clock();

    double time_spent = (double)(end - start) / CLOCKS_PER_SEC;

    printf("Iterations: %d\nSize: %d\nTime Spent: %f\n", ITERATIONS, SIZE, time_spent);

    return 0;
}

