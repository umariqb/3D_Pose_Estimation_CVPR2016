function newNumber = runden( number, digits )

newNumber = round( number * 10^digits) / 10^digits;