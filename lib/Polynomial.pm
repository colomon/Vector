use v6;

class Polynomial
{
    has @.coefficients;
    
    multi method new (*@x is copy) 
    {
        while @x.elems > 1 && @x[*-1].abs < 1e-13
        {
            say @x.perl;
            say @x[*-1];
            @x.pop;
        }
        
        if (@x.elems == 0)
        {
            self.bless(*, coefficients => 0);
        }
        else
        {
            self.bless(*, coefficients => @x);
        }
    }
    
    multi method new (@x is copy) 
    {
        while @x.elems > 1 && @x[*-1].abs < 1e-13
        {
            # say @x.perl;
            # say @x[*-1];
            @x.pop;
        }
        
        if (@x.elems == 0)
        {
            self.bless(*, coefficients => 0);
        }
        else
        {
            self.bless(*, coefficients => @x);
        }
    }
    
    our Str multi method Str() 
    {
       (^(@.coefficients.elems)).map({"{@.coefficients[$_]} x^$_"}).reverse.join(" + ");
    }
    
    our Str multi method perl()
    {
        self.WHAT.perl ~ ".new(" ~ @.coefficients.map({.perl}).join(', ') ~ ")";        
    }
    
    our multi method evaluate($x)
    {
        [+] ((^(@.coefficients.elems)).map({@.coefficients[$_] * ($x ** $_)}));
    }

    multi sub infix:<+>(Polynomial $a, Polynomial $b) is export(:DEFAULT)
    {
        my @poly = gather for ^(+$a.coefficients max +$b.coefficients) -> $i {
            if $i < +$a.coefficients && $i < +$b.coefficients {
                take $a.coefficients[$i] + $b.coefficients[$i];
            } elsif $i < +$a.coefficients {
                take $a.coefficients[$i];
            } else {
                take $b.coefficients[$i];
            }
        }
        
        Polynomial.new(@poly);
    }

    multi sub infix:<+>(Polynomial $a, $b) is export(:DEFAULT)
    {
        my @ac = $a.coefficients;
        @ac[0] += $b;
        return Polynomial.new(@ac);
    }

    multi sub infix:<+>($b, Polynomial $a) is export(:DEFAULT)
    {
        $a + $b;
    }

    multi sub prefix:<->(Polynomial $a) is export(:DEFAULT)
    {
        Polynomial.new($a.coefficients.map({-$_}));
    }

    multi sub infix:<->(Polynomial $a, Polynomial $b) is export(:DEFAULT)
    {
        -$b + $a;
    }

    multi sub infix:<->(Polynomial $a, $b) is export(:DEFAULT)
    {
        my @ac = $a.coefficients;
        @ac[0] -= $b;
        return Polynomial.new(@ac);
    }

    multi sub infix:<->($b, Polynomial $a) is export(:DEFAULT)
    {
        -$a + $b;
    }

    multi sub infix:<*>(Polynomial $a, Polynomial $b) is export(:DEFAULT)
    {
        my @coef = 0.0 xx ($a.coefficients.elems + $b.coefficients.elems - 1);
        for ^($a.coefficients.elems) -> $m
        {
            for ^($b.coefficients.elems) -> $n
            {
                @coef[$m + $n] += $a.coefficients[$m] * $b.coefficients[$n];
            }
        }

        return Polynomial.new(@coef);
    }

    multi sub infix:<*>(Polynomial $a, $b) is export(:DEFAULT)
    {
        Polynomial.new($a.coefficients >>*>> $b);
    }

    multi sub infix:<*>($b, Polynomial $a) is export(:DEFAULT)
    {
        Polynomial.new($a.coefficients >>*>> $b);
    }

    multi sub infix:</>(Polynomial $a, $b) is export(:DEFAULT)
    {
        Polynomial.new($a.coefficients >>/>> $b);
    }
}
