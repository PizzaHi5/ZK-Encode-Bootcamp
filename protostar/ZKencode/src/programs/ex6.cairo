from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

// Implement a function that sums even numbers from the provided array

//  I worked very hard to get this to work. I reached out to my team and instructor who helped some
//  however even with their help, I was not able to get this to work. I tried my best and I am glad
//  in what I accomplished! :) Cairo is a difficult language to learn. The problem I am running into
//  would be solved if this was a Cairo contract since I could store the total. I look forward to 
//  learning more about Cairo 1.0 which solves a huge problem I keep running into which is revoked 
//  implicit args. 
func sum_even{bitwise_ptr: BitwiseBuiltin*}(arr_len: felt, arr: felt*, run: felt, idx: felt) -> (
    sum: felt
) {
    alloc_locals;
    //local total = run;
    //local bool = 0;
    local bitwise_ptr0: BitwiseBuiltin* = bitwise_ptr;
    // check if index < arr_length
    if (idx != arr_len) {
        // check if index is even or not
        // When sum reaches here in 2nd loop, getting AssertEQ error again: bitwise_ptr.x = x, 100 != 1
        local bitwise_ptr: BitwiseBuiltin* = bitwise_ptr;
        let x: felt = bitwise_and(arr[idx], 1);
        %{
            print("Bitwise X is: " + str(ids.x))
        %}
        if (x == 0) {
            // add value
            let y: felt = arr[idx];
            %{
                print("Adding: " + str(ids.y))
            %}
            // This will cause revoked total every time. I tried all the options listed on docs to 
            // get this to work w/o losing my use case. Ensures that total is always the same value
            // in each tail recursion loop. All returns will be the same value.
            //
            // let total: felt = sum_even(arr_len=arr_len, arr=arr, run=run + y, idx=idx + 1);
            // return(sum=total)
            sum_even(arr_len=arr_len, arr=arr, run=run + y, idx=idx + 1);
        } else {
            // not add value
            let y: felt = arr[idx];
            %{
                print("Not Adding: " + str(ids.y))
            %}
            // Same as comment above
            sum_even(arr_len=arr_len, arr=arr, run=run, idx=idx + 1);
        }
    }
    //  This does not work since one iteration of sum_even bool is 1 and the rest are 0. Causes 
    //  ASSERT_EQ instruction failure error. 
    //%{
    //    print("bool is: " + str(ids.bool))
    //%}

    //if (bool == 0) {
    //    total = run;
    //    bool = bool + 1;
    //}
    %{
        print("Returning sum: " + str(ids.run))
    %}
    // Had to add this to get the 'revoked bitwise_ptr' error to go away
    tempvar bitwise_ptr = bitwise_ptr0;
    return (sum=run);
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