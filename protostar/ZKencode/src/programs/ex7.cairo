%lang starknet
from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem, assert_lt_felt

// Using binary operations return:
// - 1 when pattern of bits is 01010101 from LSB up to MSB 1, but accounts for trailing zeros
// - 0 otherwise

// 000000101010101 PASS
// 010101010101011 FAIL

func pattern{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}(
    n: felt, idx: felt, exp: felt, broken_chain: felt
) -> (true: felt) {
    // XOR -> different = 1, both are same = 0
    // AND -> both are 1 = 1, different = 0
    // OR  -> either is 1 = 1, both 0 = 0
    // For LSB to MSB, bits are ordered from smalled to greatest. 
    // 170 is 10101010 which should pass, return 1
    // 10 is 1010 which should pass, return 1
    // 17 is 10001 which should fail, return 0

    //Steps:
    //  -pad input to be same size as 000000101010101 (15 bits)
    //  -use bitwise_and to get resulting bits
    //  -reorder than LSB to MSB
    //  -compare result to 000000101010101 (pass condition)
    //  -return 1 if true

    // testing, currently keeps setting x continually until it exits with 0
    alloc_locals;
    let bin_n = 1;
    let bin_n_ptr = &bin_n;
    let x: felt = loopForBinary(6, bin_n_ptr);
    %{
        print(str(ids.x))
    %}

    return (0,);
}

// Takes number and returns binary + size
func getBinaryAndSize(num: felt) -> (result: felt, size: felt) {
    //let size: felt = 
    //let (temp_num, rem) = unsigned_div_rem(value=num, div=2);
}

// Contructs LSB to MSB
func constructBinary(num: felt, addNum: felt) -> (newNum: felt) {
    // For each output of loopForBinary, left bit shift.

}

// Takes input number and return remainder until num < 2
// numOut should be binary number
func loopForBinary{range_check_ptr}(num: felt, binary_ptr: felt*) -> (numOut_ptr: felt*) {
    alloc_locals;
    if (num != 1) {
        let (nextNum, rem) = unsigned_div_rem(value=num, div=2);
        %{
            print("Next Num: " + str(ids.nextNum))
            print("Rem: " + str(ids.rem))
        %}
        loopForBinary(num=nextNum, binary_ptr=binary_ptr );
        return (numOut_ptr=binary_ptr); 
    } else {
        return (0,);
    }
}