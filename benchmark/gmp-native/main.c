#include <stdio.h>
#include <time.h>

#include "gmp.h"

#define ITERATIONS 10000000
#define SIZE 100

int main(int argc, char **argv)
{
    mpz_t result, left, right;

    mpz_init(result);
    mpz_init(left);
    mpz_init(right);

    _mpz_realloc(left, SIZE);
    _mpz_realloc(right, SIZE);

    for (int i = 0; i < SIZE; ++i)
    {
        left->_mp_d[i] = 678123;
        right->_mp_d[i] = 1234789;
    }

    clock_t start = clock();

    for (unsigned long long i = 0; i < ITERATIONS; ++i)
    {
        mpz_add(result, left, right);
    }

    clock_t end = clock();

    double time_spent = (double)(end - start) / CLOCKS_PER_SEC;

    printf("Iterations: %d\nSize: %d\nTime Spent: %f\n", ITERATIONS, SIZE, time_spent);

    return 0;
}

