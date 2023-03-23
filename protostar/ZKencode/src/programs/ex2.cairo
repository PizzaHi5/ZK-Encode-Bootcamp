from starkware.cairo.common.uint256 import Uint256, uint256_add

// Modify both functions so that they increment
// supplied value and return it
func add_one(y: felt) -> (val: felt) {
    return (val = y + 1);
}

// Got this to work! WOOOO! Took hours to do! The syntax is brutal to learn and had to add import uint256_add! 
func add_one_U256{range_check_ptr}(y: Uint256) -> (val: Uint256) {
    
    let res = Uint256(low=1, high=0);

    let uint_ret = uint256_add(a=y, b=res);

    return(val = uint_ret.res);
}
