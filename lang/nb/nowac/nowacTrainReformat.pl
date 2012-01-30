#!/usr/bin/perl
##############################################################################
#
#   This script takes the NOWAC corpus of Bokmål Norwegian and reformats a configuable number
#   of sentences from the corpus into training data for sentence detection and tokeniztion using OpenNLP
#
#   Input:  
#       The nowac corpus file (specified with the --in command line option)
#       The number of sentences to process and output in the training data (specified with the --smax command line option)
#   Output:
#       Two files: "nowacSent.train" -- a training file formatted for the SentenceDetectorTrainer of OpenNLP
#                  "nowacTok.train" -- a training file formatted for the TokenizerTrainer of OpenNLP
#
#       The files are written to the current directory.
#
#       The above two files serve as the training data input files to OpenNLP's training process,
#       invocable using OpenNLP's command line tools, e.g.:
#       
#       bin/opennlp TokenizerTrainer -encoding UTF-8 -lang nb -data nowacTok.train -model nb-tok.bin
#       bin/opennlp SentenceDetectorTrainer -encoding UTF-8 -lang nb -data nowacTok.train -model nb-sent.bin
#
#	Author: Stephan Greene
##############################################################################

use strict;
# Specify UTF-8 input and output
use utf8;
binmode STDOUT, ":utf8";
binmode STDIN, ":utf8";

# Libraries 
use     Getopt::Long;    # Command line handling

# Handle command line
my $infilet	= "";
my $nSentMax = 100;
my $help = 0;
GetOptions(  "in=s"=> \$infilet,
       	     "smax:i"=>\$nSentMax,
             "H|help"=>\$help)
  or usage();
  
usage() if (($help) || ($infilet eq ""));

sub usage { 
	print STDERR "Usage: $0\n";
	print STDERR " --in [input file]              nowoc corpus file\n";
	print STDERR " --smax [maximum number of sentences to process -- default 100]\n";
  	die "Exiting\n";
}

open( fh, $infilet ) or die("can't open $infilet");
open( sentOutput, ">nowacSent.train");
open( tokOutput, ">nowacTok.train");

my @tokens = ();
my $nSent = 0;


#1. No space after token:  «  (  [
#2. No space before token:  »  )  ]  :  ,  .  ;  ?  !
#3. Space unknown (no spaces):    |  - '
#4. Alternating spacing:  "
#5. ?: ¶

sub writeSentence
  {
    my (@toks) = @_;
    my $nTok = @toks;
    my $nDoubleQ = 0;
    my @spacings = ();
    for( my $i = 0; $i < $nTok; ++$i )
      {
	if ( $tokens[$i] =~ /^[«([]$/ ) { push(@spacings, 0); } 
	elsif ( $tokens[$i] =~ /^[»)\]:,.;?!]$/ ) { pop(@spacings); push(@spacings, 0); push(@spacings, 1); }
	elsif ( $tokens[$i] eq "|" ) { pop(@spacings); push(@spacings, 0);  push(@spacings, 0);  }
	elsif ( $tokens[$i] eq "'" ) { pop(@spacings); push(@spacings, 0);  push(@spacings, 0);  }
	elsif ( $tokens[$i] eq "-" ) { pop(@spacings); push(@spacings, 0);  push(@spacings, 0); }
	elsif ( $tokens[$i] eq "/" ) { pop(@spacings); push(@spacings, 0);  push(@spacings, 0); }
	elsif ( $tokens[$i] eq "\"" )
	  {
	    ++$nDoubleQ;
	    if( $nDoubleQ % 2 == 0 ) { pop(@spacings); push(@spacings, 0); push(@spacings, 1 ); }
	    else { push(@spacings, 0 ); }
	  }
	elsif ( $i == $nTok - 1 ) { push(@spacings, 0); }
	else { push(@spacings, 1); }
      }

    for( my $i = 0; $i < $nTok; ++$i )
      {
	print( sentOutput $tokens[$i]);
	print( tokOutput $tokens[$i]);
	if( $spacings[$i] == 1 ) { print( sentOutput " "); print( tokOutput " "); }
	else { print( tokOutput "<SPLIT>"); }
      }
    print(sentOutput "\n");
    print(tokOutput "\n");
  }

while ( my $line = <fh> ) 
{
  if( $line =~ /^<\/s>/)
  {
    my $nToks = @tokens;
    if(  $nToks gt 0 )
      {
	writeSentence(@tokens);
	++$nSent;
      }
    if( $nSent != $nSentMax && $nSent % 100 == 0 ) { print("$nSent sentences processed...\n"); }
    if( $nSent >= $nSentMax) { last; }
  }
  elsif( $line =~ /^<s/ )
  {
    @tokens = ();
  }
  else
    {
      my @ltoks = split("\t", $line);
      push( @tokens, $ltoks[0] );
    }
}
print( "$nSent sentences processed\n");

close(sentOutput);
close(tokOutput);
close(fh);

