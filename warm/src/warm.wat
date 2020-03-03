(module
    (func $warm_add (param $result_ptr i32) (param $left_ptr i32) (param $right_ptr i32)
        (local $smaller_data_ptr i32)
        (local $smaller_size i32)
        (local $larger_data_ptr i32)
        (local $larger_size i32)
        (local $result_data_ptr i32)
        (local $result_size i32)
        (local $limb_index i32)
        (local $new_carry i32)
        (local $old_carry i32)
        (local $left_limb i64)
        (local $right_limb i64)
        (local $result_limb i64)
        (local $limb_ptr_offset i32)

        ;; Deciding which operand is smaller/larger.
        local.get $left_ptr
        i32.load
        local.get $right_ptr
        i32.load
        i32.lt_u
        if  ;; left < right
            local.get $left_ptr
            i32.load
            local.set $smaller_size

            local.get $left_ptr
            i32.load offset=4
            local.set $smaller_data_ptr

            local.get $right_ptr
            i32.load
            local.set $larger_size

            local.get $right_ptr
            i32.load offset=4
            local.set $larger_data_ptr
        else ;; right >= left
            local.get $right_ptr
            i32.load
            local.set $smaller_size

            local.get $right_ptr
            i32.load offset=4
            local.set $smaller_data_ptr

            local.get $left_ptr
            i32.load
            local.set $larger_size

            local.get $left_ptr
            i32.load offset=4
            local.set $larger_data_ptr
        end

        ;; Set the size of the result to larger_size + 1.
        ;; And allocate memory for the result.
        i32.const 1
        local.get $larger_size
        i32.add
        local.tee $result_size
        call $malloc
        local.set $result_data_ptr

        ;; Set result.size.
        local.get $result_ptr
        local.get $result_size
        i32.store

        ;; Set result.data to point to the allocated memory.
        local.get $result_ptr
        local.get $result_data_ptr
        i32.store offset=4


        ;; First add loop, which uses actually adds the left operand to the right operand.
        ;; We start from the 0th limb up to the size of the smaller operand.
        i32.const 0
        local.tee $limb_index
        local.set $old_carry
        loop
            ;; Calculate the byte offset of the current limb.
            local.get $limb_index
            i32.const 8
            i32.mul
            local.tee $limb_ptr_offset

            ;; Load the left operand and put on the stack for add.
            local.get $smaller_data_ptr
            i32.add
            i64.load
            local.tee $left_limb 

            ;; Load the right operand and put on the stack for add.
            local.get $limb_ptr_offset
            local.get $larger_data_ptr
            i32.add
            i64.load
            local.tee $right_limb

            ;; Add the operands, store and put on the stack.
            i64.add
            local.tee $result_limb

            ;; Check if an overflow occurred. In that case, set $new_carry.
            local.get $left_limb
            i64.lt_u
            local.get $result_limb
            local.get $right_limb
            i64.lt_u
            i32.and
            local.set $new_carry

            ;; Add the old carry and check if an overflow occurred.
            ;; If an overflow occurred previously OR at here, then set $new_carry.
            local.get $result_limb
            local.get $old_carry
            i64.extend_i32_u
            local.get $result_limb
            i64.add
            local.tee $result_limb
            i64.gt_u
            local.get $new_carry
            i32.or
            local.set $old_carry
            
            ;; Store the result of the addition in the current limb of the result.
            local.get $result_data_ptr
            local.get $limb_ptr_offset
            i32.add
            local.get $result_limb
            i64.store

            ;; If we ran out of the smaller operand, then break.
            local.get $smaller_size
            local.get $limb_index
            i32.sub
            i32.const 1
            i32.eq
            br_if 1
            
            ;; Otherwise move to the next limb.
            local.get $limb_index
            i32.const 1
            i32.add
            local.set $limb_index
            br 0
        end

        local.get $old_carry
        if ;; If there's carry, then continue with subsequent increments.
          loop
            ;; Increment the limb we'are working on and
            ;; calculate the byte offset of the current limb.
            local.get $limb_index
            i32.const 1
            i32.add
            local.tee $limb_index
            i32.const 8
            i32.mul
            local.tee $limb_ptr_offset

            ;; Load the appropriate limb of the larger operand and put on the stack for add.
            local.get $larger_data_ptr
            i32.add
            i64.load
            local.tee $left_limb 

            ;; Load the current carry and put on the stack for add.
            local.get $old_carry
            i64.extend_i32_u

            ;; Add the operands, store and put on the stack.
            i64.add
            local.tee $result_limb

            ;; Check if an overflow occurred. In that case, set $old_carry.
            local.get $left_limb
            i64.lt_u
            local.set $old_carry
            
            ;; Store the result of the addition in the current limb of the result.
            local.get $result_data_ptr
            local.get $limb_ptr_offset
            i32.add
            local.get $result_limb
            i64.store

            ;; If we ran out of the operand, then break.
            local.get $larger_size
            local.get $limb_index
            i32.sub
            i32.const 1
            i32.eq
            br_if 1

            br 0
          end          
        else ;; Otherwise, continue with simple copies.
          loop
            ;; Increment the limb we'are working on and
            ;; calculate the byte offset of the current limb.
            local.get $limb_index
            i32.const 1
            i32.add
            local.tee $limb_index
            i32.const 8
            i32.mul
            local.tee $limb_ptr_offset

            ;; Move to the current result limb.
            local.get $result_data_ptr
            i32.add

            ;; Load the appropriate limb of the larger operand.
            local.get $larger_data_ptr
            local.get $limb_ptr_offset
            i32.add
            i64.load

            ;; Store it in the result.
            i64.store

            ;; If we ran out of the operand, then break.
            local.get $larger_size
            local.get $limb_index
            i32.sub
            i32.const 1
            i32.eq
            br_if 1

            br 0
          end
        end

        ;; Finish by setting the last limb of the result to 0 or 1 (dependending on the carry).
        local.get $result_data_ptr
        local.get $limb_index
        i32.const 1
        i32.add
        i32.const 8
        i32.mul
        i32.add
        local.get $old_carry
        i64.extend_i32_u
        i64.store
    )
)


