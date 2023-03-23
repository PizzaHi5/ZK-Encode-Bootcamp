// Create a function that accepts a parameter and logs it
func log_value(y: felt) {
   // Start a hint segment that uses python print()

    %{
        print('first python print in Cairo\n')
    %}

   // This exercise has no tests to check against.

    return ();
}
