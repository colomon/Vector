use v6;
use BinarySearch;

# enum KnotBasisDirection <Left Right>;

class KnotVector
{
    has @.knots;
    
    multi method new (@u) 
    {
        self.bless(*, knots => @u);
    }
    
    our Str multi method Str() 
    {
        "(" ~ @.knots.join(', ') ~ ")";
    }
    
    our Str multi method perl()
    {
        self.WHAT.perl ~ ".new((" ~ @.knots.map({.perl}).join(', ') ~ "))";        
    }

    sub infix:<O/>($a, $b) is export(:DEFAULT)
    {
        return 0 if abs($b) < 1e-10;
        return $a / $b;
    }

        
    multi method N0_index(Int $p, $u, $direction-left = True)
    {
        if $direction-left {
            UpperBound(@.knots, $u) - $p - 1;
        } else {
            LowerBound(@.knots, $u) - $p - 1;
        }
    }
    
    multi method N_local(Int $n0, Int $p, $u)
    {
        my @N_prev = 0 xx $p, 1, 0;
        my @N = 0 xx ($p + 2);
                
        for 1..$p -> $q
        {
            for ($p - $q)...($p) -> $i
            {
                @N[$i] = (($u - @.knots[$n0 + $i]) O/ (@.knots[$n0 + $i + $q] - @.knots[$n0 + $i])) * @N_prev[$i]
                + ((@.knots[$n0 + $i + $q + 1] - $u) O/ (@.knots[$n0 + $i + $q + 1] - @.knots[$n0 + $i + 1])) * @N_prev[$i + 1];
            }
            @N_prev = @N;
        }
        @N.pop;

        return @N;
    }
    
    multi method N(Int $p, $u, $direction-left = True)
    {
        my $n0 = self.N0_index($p, $u, $direction-left);
        my @N = 0 xx (@.knots.elems - $p - 1);
        @N[($n0)..($n0 + $p)] = self.N_local($n0, $p, $u);
        return @N;
    }
    
    multi method ParameterRange(Int $p)
    {
        ($.knots[$p], $.knots[*-$p]);
    }
    
    # this one is handy for testing
    multi sub RangeOfSize($a, $b, $size) is export(:DEFAULT)
    {
        my $delta = ($b - $a) / ($size - 1);
        my $value = $a; 
        return gather
        {
            loop (my $i = 0; $i + 1 < $size; $i++)
            {
                my $result = $value;
                take $result;
                $value += $delta;
            }
            take $b;
        }
    }
}