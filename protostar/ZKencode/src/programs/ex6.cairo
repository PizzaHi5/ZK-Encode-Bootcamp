from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

// Implement a function that sums even numbers from the provided array
func sum_even{bitwise_ptr: BitwiseBuiltin*}(arr_len: felt, arr: felt*, run: felt, idx: felt) -> (
    sum: felt
) {
    // check if index < arr_length
    if (idx != arr_len) {
        // check if index is even or not
        let x: felt = bitwise_and(arr[run], 1);
        %{
            print("Bitwise X is: " + str(ids.x))
        %}
        if (x == 0) {
            let y: felt = arr[run];
            %{
            print("Adding: " + str(ids.y))
            %}
            return (sum=y);
        } else {
            return (0,);
        }
    }
    %{
        print("executed")
    %}
    
    let all_sum: felt = sum_even(arr_len=arr_len, arr=arr, run=run, idx=idx + 1);
    
    return (sum=all_sum);
}

// After writing this, I checked the test_ex6.cairo file and realized the run and idx values are zeros.
// Only 0s are input, rendering this non-functional since it would only check from index 0 to index 0 and
// will only return 0 from the first check.  
func sum_even2{bitwise_ptr: BitwiseBuiltin*}(arr_len: felt, arr: felt*, run: felt, idx: felt) -> (
    sum: felt
) {
    //if (run > idx) {
    //    return (0,);
    //}

    //if (run == idx) {
    //    if (bitwise_and(arr[run], 1) == 0) {
    //   %{
    //        print("Adding: " + str(ids.arr[run]))
    //    %}
    //        return arr[run];
    //    } else {
    //        return (0,);
    //    }
    //}
    //let mid_idx = (run + idx) / 2;
    //%{
    //    print("Is this a huge #?\n " + str(ids.mid_idx))
    //%}
    //let left_sum = sum_even(arr_len=arr_len, arr=arr, run=run, idx=mid_idx);
    //let right_sum =  sum_even(arr_len=arr_len, arr=arr, run=mid_idx + 1, idx=idx);
    //return (sum=left_sum + right_sum);
}