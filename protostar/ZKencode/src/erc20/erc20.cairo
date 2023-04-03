%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_le,
    uint256_eq,
    uint256_unsigned_div_rem,
    uint256_sub,
    uint256_add,
)
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import unsigned_div_rem, assert_le_felt
from starkware.cairo.common.math import (
    assert_not_zero,
    assert_not_equal,
    assert_nn,
    assert_le,
    assert_lt,
    assert_in_range,
)
from exercises.contracts.erc20.ERC20_base import (
    ERC20_name,
    ERC20_symbol,
    ERC20_totalSupply,
    ERC20_decimals,
    ERC20_balanceOf,
    ERC20_allowance,
    ERC20_mint,
    ERC20_initializer,
    ERC20_transfer,
    ERC20_burn,
)

//  Start a test with:
//  protostar test test/test_erc20.cairo

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    name: felt, symbol: felt, initial_supply: Uint256, recipient: felt
) {
    ERC20_initializer(name, symbol, initial_supply, recipient);
    admin.write(recipient);
    return ();
}

// Storage
//#########################################################################################

@storage_var
func admin() -> (res: felt) {
}

@storage_var
func whiteListed(user : felt) -> (res : felt) {
}

// View functions
//#########################################################################################

@view
func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
    let (name) = ERC20_name();
    return (name,);
}

@view
func get_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    admin_address: felt
) {
    let (admin_address) = admin.read();
    return (admin_address,);
}

@view
func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (symbol: felt) {
    let (symbol) = ERC20_symbol();
    return (symbol,);
}

@view
func totalSupply{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    totalSupply: Uint256
) {
    let (totalSupply: Uint256) = ERC20_totalSupply();
    return (totalSupply,);
}

@view
func decimals{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    decimals: felt
) {
    let (decimals) = ERC20_decimals();
    return (decimals,);
}

@view
func balanceOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(account: felt) -> (
    balance: Uint256
) {
    let (balance: Uint256) = ERC20_balanceOf(account);
    return (balance,);
}

@view
func allowance{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    owner: felt, spender: felt
) -> (remaining: Uint256) {
    let (remaining: Uint256) = ERC20_allowance(owner, spender);
    return (remaining,);
}

// Externals
//###############################################################################################

//Added check to ensure only even #s are transferred
@external
func transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    recipient: felt, amount: Uint256
) -> (success: felt) {
    let (_, rem) = uint256_unsigned_div_rem(amount, Uint256(2,0));
    //%{
    //    print("Rem is: " + str(ids.rem))
    //%}
    let success: felt = uint256_eq(rem, Uint256(0,0));
    assert success = 1;
    ERC20_transfer(recipient, amount);
    return (1,);
}

//Added 10,000 mint cap
@external
func faucet{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(amount: Uint256) -> (
    success: felt
) {
    let (caller) = get_caller_address();
    //%{
    //   print(10000 * 10 ** ids.decimals()) -> 5 + 18 = 23 decimals
    //%}
    let success: felt = uint256_le(amount, Uint256(10000,0)); // * 10 ** decimals()
    assert success = 1;
    ERC20_mint(caller, amount);
    return (success,);
}

@external
func burn{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(amount: Uint256) -> (
    success: felt
) {
    alloc_locals;
    let (caller) = get_caller_address();
    let (newAmount, rem) = uint256_unsigned_div_rem(amount, Uint256(10,0));
    //%{
    //    print(ids.newAmount)
    //%}
    let admin: felt = get_admin();
    ERC20_transfer(admin, newAmount);
    
    let (value: Uint256) = uint256_sub(amount, newAmount);
    ERC20_burn(caller, value);
    
    return (1,);
}

@external
func request_whitelist{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    level_granted: felt
) {
    let (caller) = get_caller_address();
    let level_granted = 1;
    whiteListed.write(caller, level_granted);
    return (level_granted=level_granted,);
}

@external
func check_whitelist{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt
) -> (allowed_v: felt) {
    alloc_locals;
    let value: felt = whiteListed.read(account);
    if (value != 0) {
        return (allowed_v=1,);
    }
    return (allowed_v=0,);
}

@external
func exclusive_faucet{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    amount: Uint256
) -> (success: felt) {
    let (caller) = get_caller_address();
    let success: felt = check_whitelist(caller);
    assert success = 1;
    ERC20_mint(caller, amount);
    return (success=success);
}

