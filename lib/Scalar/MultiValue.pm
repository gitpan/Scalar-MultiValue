#############################################################################
## Name:        MultiValue.pm
## Purpose:     Scalar::MultiValue
## Author:      Graciliano M. P. 
## Modified by:
## Created:     2004-08-31
## RCS-ID:      
## Copyright:   (c) 2004 Graciliano M. P. 
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Scalar::MultiValue ;
use 5.006 ;

use strict qw(vars);

use vars qw($VERSION @ISA) ;

$VERSION = '0.01' ;

@ISA = qw(Object::MultiType) ;

###########
# REQUIRE #
###########

  use Object::MultiType ;

#######
# NEW #
#######

sub new {
  my $class = shift ;
  $class = ref($class) if ref($class) ;

  my @values = ref $_[0] eq 'ARRAY' ? @{shift(@_)} : split(/\s/s , shift(@_)) ;  
  
  my %inf = ref $_[0] eq 'HASH' ? %{shift(@_)} : ( period => shift(@_) ) ;
  
  my $this = Object::MultiType->new(
  scalarsub => \&content ,
  array     => \@values ,
  ) ;
  
  $$this->{period} = $inf{period} || 1 ;
  $$this->{lastpos} = $inf{lastpos} ne '' ? $inf{lastpos} : undef ;
  $$this->{counter} = -1 ;
  
  bless($this,$class) ;
}

###########
# CONTENT #
###########

sub content {
  my $this = shift ;
  
  if ( $$this->{period} eq '*' ) {
    $$this->{lastpos} = int( rand(@{$$this->{a}}) ) ;
  }
  elsif ( $$this->{period} =~ /^\d+$/s ) {
    ++$$this->{counter} ;
    
    if ( $$this->{counter} >= $$this->{period} ) {
      $$this->{counter} = 0 ;
      ++$$this->{lastpos} ;
      $$this->{lastpos} = 0 if $$this->{lastpos} > $#{$$this->{a}} ;
    }
  }
  
  return @{$$this->{a}}[ $$this->{lastpos} ] ;
}

#########
# RESET #
#########

sub reset {
  my $this = shift ;
  $$this->{counter} = -1 ;
}

##########
# PERIOD #
##########

sub period {
  my $this = shift ;
  
  if ( @_ ) {
    $$this->{period} = shift ;
  }
  
  return $$this->{period} ;
}

#######
# END #
#######

1;

__END__

=head1 NAME

Scalar::MultiValue - Create a SCALAR with multiple values.

=head1 DESCRIPTION

This module create a SCALAR with multiple values, where this values can be
randomic or can change by a defined period.

=head1 USAGE

With a period of I<2>:

  my $s = new Scalar::MultiValue( [qw(a b c d)] , 2 ) ;

  for(0..8) {
    print "$s\n" ;
  }

I<Output:>

  a
  a
  b
  b
  c
  c
  d
  d

With randomic values:

  my $s = new Scalar::MultiValue( [qw(a b c d)] , '*' ) ;

  for(0..8) {
    print "$s\n" ;
  }

I<Output:>

  c
  d
  c
  b
  a
  d
  c
  c

=head1 NEW (LIST , PERIOD)

The arguments of I<new> are a LIST and the PERIOD (optional):

=over 4

=item LIST

Can be a ARRAYREF or a string that will be splited by /\s/, like on qw():

  ## this is the same
  my $s = new Scalar::MultiValue( 'a b c d' ) ;
  ## of that:
  my $s = new Scalar::MultiValue( [qw(a b c d)] ) ;

=item PERIOD

The PERIOD can be a integer value, that will define how many times a value will
be repeated before change to the next value. PERIOD also can be 'B<*>', that will
change randomically the values.

=back

=head1 SETTING THE VALUES

You can use the scalar as a ARRAYREF and set it's values

  my $s = new Scalar::MultiValue( 'a b c d' ) ;

Redefining a single value:

  $$s[0] = 'A' ;

Redefining all the values:

  @$s = qw(w x y z) ;

=head1 METHODS

=head2 reset()

Reset the internal counter for the PERIOD.

=head2 period(VAL)

Return the period or define it when I<VAL> is defined.

=head1 EXAMPLE

A common example of use for this module is for multiple colors on a table:

    use Scalar::MultiValue ;
    
    my $colors = new Scalar::MultiValue('#CCCCCC #999999') ;
    
    my @users = qw(a b c d) ;
    
    print "<table>\n" ;
    foreach my $users_i ( @users ) {
      print "<tr><td bgcolor='$colors'>$users_i</td></tr>\n" ;
    }
    print "</table>\n" ;

I<Output:>

  <table>
  <tr><td bgcolor='#CCCCCC'>a</td></tr>
  <tr><td bgcolor='#999999'>b</td></tr>
  <tr><td bgcolor='#CCCCCC'>c</td></tr>
  <tr><td bgcolor='#999999'>d</td></tr>
  </table>

=head1 SEE ALSO

L<Scalar::Util>.

=head1 AUTHOR

Graciliano M. P. <gm@virtuasites.com.br>

I will appreciate any type of feedback (include your opinions and/or suggestions). ;-P

=head1 COPYRIGHT

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

