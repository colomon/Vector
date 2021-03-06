use v6;
use MONKEY_TYPING;

use Test;  # so we can define is_approx_vector

class Vector
{
    has @.coordinates;
    
    multi method new (*@x) 
    {
        self.bless(*, coordinates => @x);
    }
    
    multi method new (@x) 
    {
        self.bless(*, coordinates => @x);
    }
    
    our Str multi method Str() 
    {
        "(" ~ @.coordinates.join(', ') ~ ")";
    }
    
    our Str multi method perl()
    {
        self.WHAT.perl ~ ".new(" ~ @.coordinates.map({.perl}).join(', ') ~ ")";        
    }
    
    multi method Num()
    {
        die "Cannot call Num on Vector!";
    }
    
    method Dim()
    {
        @.coordinates.elems;
    }

    our multi sub infix:<⋅>(Vector $a, Vector $b where { $a.Dim == $b.Dim }) is export(:DEFAULT) # is tighter(&infix:<+>) (NYI)
    {
        [+]($a.coordinates »*« $b.coordinates);
    }

    our multi sub infix:<dot>(Vector $a, Vector $b) is export(:DEFAULT)
    {
        $a ⋅ $b;
    }

    method Length()
    {
        sqrt(self ⋅ self);
    }
    
    multi method abs()
    {
        self.Length;
    }
        
    method Unitize()
    {
        my $length = self.Length;
        if $length > 1e-10
        {
            return Vector.new(@.coordinates >>/>> $length);
        }
        else
        {
            return Vector.new(@.coordinates);
        }
    }
    
    multi sub infix:<+> (Vector $a, Vector $b where { $a.Dim == $b.Dim }) is export(:DEFAULT)
    {
        Vector.new($a.coordinates »+« $b.coordinates);
    }
    
    multi sub infix:<->(Vector $a, Vector $b where { $a.Dim == $b.Dim }) is export(:DEFAULT)
    {
        Vector.new($a.coordinates »-« $b.coordinates);
    }

    multi sub prefix:<->(Vector $a) is export(:DEFAULT)
    {
        Vector.new(0 <<-<< $a.coordinates);
    }

    multi sub infix:<*>(Vector $a, $b) is export(:DEFAULT)
    {
        Vector.new($a.coordinates >>*>> $b);
    }

    multi sub infix:<*>($a, Vector $b) is export(:DEFAULT)
    {
        Vector.new($a <<*<< $b.coordinates);
    }

    multi sub infix:</>(Vector $a, $b) is export(:DEFAULT)
    {
        Vector.new($a.coordinates >>/>> $b);
    }

    multi sub infix:<×>(Vector $a where { $a.Dim == 3 }, Vector $b where { $b.Dim == 3 }) is export(:DEFAULT)
    {
        Vector.new($a.coordinates[1] * $b.coordinates[2] - $a.coordinates[2] * $b.coordinates[1], 
                   $a.coordinates[2] * $b.coordinates[0] - $a.coordinates[0] * $b.coordinates[2], 
                   $a.coordinates[0] * $b.coordinates[1] - $a.coordinates[1] * $b.coordinates[0]);
    }

    multi sub infix:<×>(Vector $a where { $a.Dim == 7 }, Vector $b where { $b.Dim == 7 }) is export(:DEFAULT)
    {
        Vector.new($a.coordinates[1] * $b.coordinates[3] - $a.coordinates[3] * $b.coordinates[1] 
                   + $a.coordinates[2] * $b.coordinates[6] - $a.coordinates[6] * $b.coordinates[2] 
                   + $a.coordinates[4] * $b.coordinates[5] - $a.coordinates[5] * $b.coordinates[4],
                   $a.coordinates[2] * $b.coordinates[4] - $a.coordinates[4] * $b.coordinates[2] 
                   + $a.coordinates[3] * $b.coordinates[0] - $a.coordinates[0] * $b.coordinates[3] 
                   + $a.coordinates[5] * $b.coordinates[6] - $a.coordinates[6] * $b.coordinates[5],
                   $a.coordinates[3] * $b.coordinates[5] - $a.coordinates[5] * $b.coordinates[3] 
                   + $a.coordinates[4] * $b.coordinates[1] - $a.coordinates[1] * $b.coordinates[4] 
                   + $a.coordinates[6] * $b.coordinates[0] - $a.coordinates[0] * $b.coordinates[6],
                   $a.coordinates[4] * $b.coordinates[6] - $a.coordinates[6] * $b.coordinates[4] 
                   + $a.coordinates[5] * $b.coordinates[2] - $a.coordinates[2] * $b.coordinates[5] 
                   + $a.coordinates[0] * $b.coordinates[1] - $a.coordinates[1] * $b.coordinates[0],
                   $a.coordinates[5] * $b.coordinates[0] - $a.coordinates[0] * $b.coordinates[5] 
                   + $a.coordinates[6] * $b.coordinates[3] - $a.coordinates[3] * $b.coordinates[6] 
                   + $a.coordinates[1] * $b.coordinates[2] - $a.coordinates[2] * $b.coordinates[1],
                   $a.coordinates[6] * $b.coordinates[1] - $a.coordinates[1] * $b.coordinates[6] 
                   + $a.coordinates[0] * $b.coordinates[4] - $a.coordinates[4] * $b.coordinates[0] 
                   + $a.coordinates[2] * $b.coordinates[3] - $a.coordinates[3] * $b.coordinates[2],
                   $a.coordinates[0] * $b.coordinates[2] - $a.coordinates[2] * $b.coordinates[0] 
                   + $a.coordinates[1] * $b.coordinates[5] - $a.coordinates[5] * $b.coordinates[1] 
                   + $a.coordinates[3] * $b.coordinates[4] - $a.coordinates[4] * $b.coordinates[3]);
    }

    multi sub infix:<cross>(Vector $a, Vector $b) is export(:DEFAULT)
    {
        $a × $b;
    }

    multi sub circumfix:<⎡ ⎤>(Vector $a) is export(:DEFAULT)
    {
        $a.Length;
    }

    sub is_approx_vector(Vector $a, Vector $b, $desc) is export(:DEFAULT)
    {
        ok(($a - $b).Length < 0.00001, $desc);
    }
}

# multi sub prefix:<+>(Vector $a)
# {
#     $a;
# }

subset UnitVector of Vector where { (1 - 1e-10) < $^v.Length < (1 + 1e-10) };
