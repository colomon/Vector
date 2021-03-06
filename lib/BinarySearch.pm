module BinarySearch;

sub LowerBound(@x, $key) is export(:DEFAULT)
{
    my $first = 0;
    my $len = @x.elems;
    my $half;
    while ($len > 0 && $first < @x.elems)
    {
        $half = $len div 2;
        if (@x[$first + $half] < $key)
        {
            $first += $half + 1;
            $len -= $half + 1;
        }
        else
        {
            $len = $half;
        }
    }
    return $first;
}

sub UpperBound(@x, $key) is export(:DEFAULT)
{
    my $first = 0;
    my $len = @x.elems;
    my $half;
    while ($len > 0 && $first < @x.elems)
    {
        $half = $len div 2;
        if (@x[$first + $half] <= $key)
        {
            $first += $half + 1;
            $len -= $half + 1;
        }
        else
        {
            $len = $half;
        }
    }
    return $first;
}