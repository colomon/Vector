use v6;
use KnotVector;
use Vector;

class Nubs
{
    has $.degree;
    has $.knot_vector;
    has @.control_points;
    
    multi method new(Int $degree, KnotVector $kv, @control_points) 
    {
        self.bless(*, degree => $degree, knot_vector => $kv, control_points => @control_points);
    }
    
    our Str multi method perl()
    {
        self.WHAT.perl ~ ".new($.degree, {$.knot_vector.perl}, {@.control_points.perl})";        
    }
    
    multi method ParameterRange()
    {
        $.knot_vector.ParameterRange($.degree);
    }
    
    # make this next one private?
    multi method Direction($t)
    {
        $t < ([+] self.ParameterRange) / 2; # ?? Left !! Right;
    }

    multi method evaluate($t, $direction-left = self.Direction($t))
    {
        my $n0 = $.knot_vector.N0_index($.degree, $t, $direction-left);
        my $result = 0 * @.control_points[0];
        for $.knot_vector.N_local($n0, $.degree, $t) Z @.control_points[$n0 .. ($n0 + $.degree)] -> $a, $b {
            $result = $result + $a * $b;
        }
        $result;
        # return [+] ($.knot_vector.N_local($n0, $.degree, $t) 
        #             >>*<< @.control_points[$n0 .. ($n0 + $.degree)]);
    }
    
    multi method evaluate($base_t, $actual_t, $direction-left = self.Direction($base_t))
    {
        my $n0 = $.knot_vector.N0_index($.degree, $base_t, $direction-left);
        return [+] ($.knot_vector.N_local($n0, $.degree, $actual_t) 
                    >>*<< @.control_points[$n0 .. ($n0 + $.degree)]);
    }
}