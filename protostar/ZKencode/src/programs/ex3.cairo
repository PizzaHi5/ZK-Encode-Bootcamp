// Perform and log output of simple arithmetic operations
func simple_math() {
    alloc_locals;
   // adding 13 +  14
    local one = 13 + 14;
    %{
        print('one is: ' + str(ids.one))
    %}

   // multiplying 3 * 6
    local two = 3 * 6;
    %{
        print('two is: ' + str(ids.two))
    %}

   // dividing 6 by 2
   local three = 6/2;
    %{
        print('three is: ' + str(ids.three))
    %}

   // dividing 70 by 2
    local four = 70/2;
    %{
        print('four is: ' + str(ids.four))
    %}

   // dividing 7 by 2
    local five = 7/2;
    %{
        print('five is: ' + str(ids.five))
    %}

    return ();
}
