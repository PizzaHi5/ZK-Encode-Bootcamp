// Return summation of every number below and up to including n
func calculate_sum(n: felt) -> (sum: felt) {
    let total = 0;
    // Used a reference here allows total to be reassigned however many times recurse performs recursion
    let total: felt = recurse(n=n, total=total);
    %{
        print("End total: " + str(ids.total) + " and n: " + str(ids.n))
        print("Triangular Number Formula: " + str(ids.n * (ids.n + 1) / 2))
    %}

    // Turns out I only needed to use the Triangular Number Formula to solve this rather than recursion
    return (sum=(n * (n + 1) / 2));
}

// Returns n # of times in decending order, this does not work since total gets reassigned n times
// resulting in a value of 0 since it was the first total inputted. 
func recurse(n: felt, total: felt) -> (rem: felt) {
    if (n != 0) {
        %{
            print("total: " + str(ids.total) + " and n: " + str(ids.n))
        %}
        recurse(n=n-1, total=total+n);
    }
    %{
        print("Returning: " + str(ids.total))
    %}
    return(rem=total);
}