%lang starknet


from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from warplib.maths.external_input_check_ints import warp_external_input_check_int256


func WS_WRITE0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt, value: Uint256) -> (res: Uint256){
    WARP_STORAGE.write(loc, value.low);
    WARP_STORAGE.write(loc + 1, value.high);
    return (value,);
}


func WS0_READ_Uint256{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: Uint256){
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    let (read1) = WARP_STORAGE.read(loc + 1);
    return (Uint256(low=read0,high=read1),);
}


// Contract Def Storage

//  @title Storage
// @dev Store & retrieve value in a variable
// @custom:dev-run-script ./scripts/deploy_with_ethers.ts

namespace Storage{

    // Dynamic variables - Arrays and Maps

    // Static variables

    const __warp_0_number = 0;

}

    //  @dev Store value in variable
    // @param num value to store
    @external
    func store_6057361d{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_1_num : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_1_num);
        
        WS_WRITE0(Storage.__warp_0_number, __warp_1_num);
        
        
        
        return ();

    }

    //  @dev Return value 
    // @return value of 'number'
    @view
    func retrieve_2e64cec1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_2 : Uint256){
    alloc_locals;


        
        let (__warp_se_0) = WS0_READ_Uint256(Storage.__warp_0_number);
        
        
        
        return (__warp_se_0,);

    }


    @constructor
    func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(){
    alloc_locals;
    WARP_USED_STORAGE.write(2);


        
        
        
        return ();

    }

@storage_var
func WARP_STORAGE(index: felt) -> (val: felt){
}
@storage_var
func WARP_USED_STORAGE() -> (val: felt){
}
@storage_var
func WARP_NAMEGEN() -> (name: felt){
}
func readId{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) -> (val: felt){
    alloc_locals;
    let (id) = WARP_STORAGE.read(loc);
    if (id == 0){
        let (id) = WARP_NAMEGEN.read();
        WARP_NAMEGEN.write(id + 1);
        WARP_STORAGE.write(loc, id + 1);
        return (id + 1,);
    }else{
        return (id,);
    }
}