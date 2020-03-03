#if !defined(WARM_H)
#define WARM_H

#if !defined(__clang__)
#   error "Please switch to clang, as currently that's the only compiler with WASI support."
#endif

/**
 * Only exported functions will be available for the clients of the library. 
 *
 * This attribute is specific to Clang.
 */
#define EXPORTED __attribute__ ((visibility("default")))


/**
 * Datatype used for storing the actual number data. A warm number is represented
 * as an array of warm_data_t-s.
 *
 * When targeting wasm32-unknown-wasi, unsigned long long is a 64 bit unsigned integer, 
 * corresponding to the i64 WASM type.
 */
typedef unsigned long long warm_data_t;

/**
 * Stores the number of warm_data_t-s used to represent a warm number.
 *
 * When targeting wasm32-unknown-wasi, unsigned long is a 32 bit unsigned integer, 
 * corresponding to the i32 WASM type.
 */
typedef unsigned long warm_size_t;

/**
 * A warm number is just an array of warm_data_t-s. However, to make it easier to work with
 * we wrap it together with the size in a struct.
 */
typedef struct {
    warm_size_t size;

    /**
     * The digits of the number.
     *
     * Implementation note: The digits are stored left-to-right instead of right-to-left.
     */
    warm_data_t *data;
} warm_t;


/**
 * Alias for out arguments. These are produced by the functions.
 */
typedef warm_t *const warm_out_ptr;

/**
 * Alias for in arguments. These are consumed by the functions.
 */
typedef const warm_t *const warm_source_ptr;


EXPORTED void warm_add(warm_out_ptr result, warm_source_ptr left, warm_source_ptr right);

#endif
