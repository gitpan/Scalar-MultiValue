#########################

###use Data::Dumper ; print Dumper(  ) ;

use Test;
BEGIN { plan tests => 1 } ;

use Scalar::MultiValue ;

use strict ;
use warnings qw'all' ;

#########################
{

  my $s = new Scalar::MultiValue( [qw(a b c d)] , 2 ) ;
  
  ok($s) ;

  $s->reset ;

  my $vals ;

  for(0..8) {
    $vals .= "$s;" ;
  }
  
  ok($vals , 'a;a;b;b;c;c;d;d;a;') ;

}
#########################

print "\nThe End! By!\n" ;

1 ;
