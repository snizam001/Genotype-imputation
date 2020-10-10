print "#####################################\n";
print "#  This script is used for checking #\n";
print "#  imputation accuracy with diff.   #\n";
print "#  popualtion reference             #\n";
print "#  @Dr. K. thangaraj and S. Nizam   #\n";
print "#####################################";
#`rm temp* ; rm india.*; rm world*; rm outfile*`;
# link beagle.jar to directory and copy all file to directory only: files are family.family.bgl.phased, chromosome22.mapfile, japanese.bgl, european.D.bgl, european.unr.bgl, european.trios.bgl, yoruba.trios.bgl yoruba.D.bgl yoruba.unr.bgl, 1000.chr22.genotype.bglfile.simulation.phased

print "command (script is only run on mac):\nperl this-script.pl percentage number_of_permutation directory without_family.bgl\n";
####################3
`mkdir kachara`;
$per=$ARGV[0];
chomp $per;
#$number=$ARGV[1];
#################################################################################################################
$direct=$ARGV[2];
$file=$ARGV[3];

for($pp=0;$pp<$ARGV[1];$pp++)
{
$number=$pp+1;
open(f,$file) || die "cannot open file";
@file=<f>;
open(out,">$direct/kachara/outfile.$per.$number"); print out $file[0];

for($i=1;$i<scalar@file;$i++)
 {
   chomp $file[$i]; @split=split(' ',$file[$i]); print out "$split[0]\t$split[1]\t";
   for($x=2;$x<scalar@split;$x=$x+2) { print out "$split[$x]$split[$x+1]\t";}
  }
close out;
open(out,"$direct/kachara/outfile.$per.$number"); @file=<out>; close out;
# random numbers
#c ++++++++++++++++++++++++++++++

$howmany=int( ((207*9624)/100)*$per ); @random=();                                                                # change 9624
for($k=0;$k<$howmany;$k++)
 {
   $ran=int(rand(207*9624));
   push(@random,"$ran\t");
    }
# generate file
#++++++++++++++++++++++++++++++++++++++++

open(out,">$direct/kachara/outfile2.$per.$number");
@split=split(' ',$file[1]);
for($x=0;$x<scalar@random;$x++)
 {
   if(($split[$random[$x]]=~/rs/) || ($split[$random[$x]]=~/M/))
    {
       }
   else {$split[$random[$x]]="00"; }
    }
for($i=0;$i<scalar@split;$i++)
 {
   print out "$split[$i]\t";
   }
print out "\n";
`tr "*" "\n" < $direct/kachara/outfile2.$per.$number | sed -e 's/A/A /g' -e 's/C/C /g' -e 's/T/T /g' -e 's/G/G /g' -e 's/[[:<:]]00[[:>:]]/0 0/g' -e 's/    / /g' -e 's/   / /g' -e 's/  / /g' | sed 's/A FFX-SNP/AFFX-SNP/g' | tr "M" "\n" | sed 's/^/M /g' | sed 1d | sed 's/SNP_A /SNP_A/g' > $direct/kachara/temporary.$per.$number`;

############################################################3
# Imputation
#++++++++++++++++++++++++++++++++++++++++++++++++++

system("java -jar $direct/beagle.jar unphased=$direct/kachara/temporary.$per.$number phased=$direct/family.family.bgl.phased markers=$direct/chromosome22.mapfile missing=0 out=$direct/kachara/india.$per.$number gprobs=true verbose=true ; gunzip -f $direct/kachara/*gz");
system("java -jar $direct/beagle.jar unphased=$direct/kachara/temporary.$per.$number phased=$direct/japanese.bgl phased=$direct/european.D.bgl phased=$direct/european.unr.bgl phased=$direct/european.trios.bgl phased=$direct/yoruba.trios.bgl phased=$direct/yoruba.D.bgl phased=$direct/yoruba.unr.bgl markers=$direct/chromosome22.mapfile missing=0 out=$direct/kachara/world.$per.$number gprobs=true verbose=true  ");
system("java -jar $direct/beagle.jar unphased=$direct/kachara/temporary.$per.$number phased=$direct/family.family.bgl.phased phased=$direct/japanese.bgl phased=$direct/european.D.bgl phased=$direct/european.unr.bgl phased=$direct/european.trios.bgl phased=$direct/yoruba.trios.bgl phased=$direct/yoruba.D.bgl phased=$direct/yoruba.unr.bgl markers=$direct/chromosome22.mapfile missing=0 out=$direct/kachara/world.india.$per.$number gprobs=true verbose=true  ");
system("java -jar $direct//beagle.jar unphased=$direct/kachara/temporary.$per.$number phased=1000.chr22.genotype.bglfile.simulation.phased markers=$direct/chr22.mapfile missing=0 out=$direct/kachara/1000genome.$per.$number gprobs=true verbose=true ");



# imputed: imputed:india.temporary.phased; masked:temporary; real:without_family.bgl
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

`gunzip -f $direct/kachara/*gz`;
open(output1,">$direct/Output.$per.$number");
for($i=2;$i<9625;$i++)
 {
   $rs=`sed  -n $i\p $direct/without_family.bgl | awk '{print \$2}'`; chomp $rs;
   `fgrep -w $rs $direct/without_family.bgl | tr "\t " "\n\n" | sed '/^\$/d' > $direct/kachara/real.$per.$number; fgrep -w $rs $direct/kachara/temporary.$per.$number  | tr "\t " "\n\n" | sed '/^\$/d' > $direct/kachara/masked.$per.$number ; fgrep -w $rs $direct/kachara/india.$per.$number.temporary.$per.$number.phased | tr "\t " "\n\n" | sed '/^\$/d' > $direct/kachara/india.$per.$number ; fgrep -w $rs $direct/kachara/world.$per.$number.temporary.$per.$number.phased | tr "\t " "\n\n" | sed '/^\$/d'> $direct/kachara/world.$per.$number ; fgrep -w $rs $direct/kachara/world.india.$per.$number.temporary.$per.$number.phased | tr "\t " "\n\n" | sed '/^\$/d'> $direct/kachara/world.india.$per.$number; fgrep -w $rs $direct/kachara/1000genome.$per.$number.temporary.$per.$number.phased | tr "\t " "\n\n" | sed '/^\$/d' > $direct/kachara/1000genome.$per.$number`;
   `paste $direct/kachara/real.$per.$number $direct/kachara/masked.$per.$number $direct/kachara/india.$per.$number $direct/kachara/world.$per.$number $direct/kachara/world.india.$per.$number $direct/kachara/1000genome.$per.$number> $direct/kachara/total.$per.$number`;
    $t=0;$right_india=0;$right_world=0;$wrong_india=0;$wrong_world=0; $right_world_india=0; $wrong_world_india=0; $right_1000=0; $wrong_1000=0;
    open(t,"$direct/kachara/total.$per.$number") || die "unable to find total file";
    @total=<t>;
    for($k=2;$k<scalar@total;$k=$k+2)
         {
           chomp $total[$k]; chomp $total[$k+1]; @s_1=split(' ',$total[$k]); @s_2=split(' ',$total[$k+1]);
           if (($s_1[1]=~/0/) && ($s_1[0]!~/0/))
             {
                     $t=$t+2;
                     if(($s_1[2]=~/$s_1[0]/) && ($s_2[2]=~/$s_2[0]/))   {$right_india=$right_india+2; }
                     elsif(($s_1[2]=~/$s_2[0]/) && ($s_2[2]=~/$s_1[0]/))  {$right_india=$right_india+2; }
                     else {$wrong_india=$wrong_india+2;}                                      

                     if(($s_1[3]=~/$s_1[0]/) && ($s_2[3]=~/$s_2[0]/))   {$right_world=$right_world+2; }
                     elsif(($s_1[3]=~/$s_2[0]/) && ($s_2[3]=~/$s_1[0]/))   {$right_world=$right_world+2; }
                     else {$wrong_india=$wrong_world+2;}        

                     if(($s_1[4]=~/$s_1[0]/) && ($s_2[4]=~/$s_2[0]/))   {$right_world_india=$right_world_india+2; }
                     elsif(($s_1[4]=~/$s_2[0]/) && ($s_2[4]=~/$s_1[0]/))   {$right_world_india=$right_world_india+2; }
                     else {$wrong_india=$wrong_world+2;} 

                     if(($s_1[5]=~/$s_1[0]/) && ($s_2[5]=~/$s_2[0]/))   {$right_1000=$right_1000+2; }
                     elsif(($s_1[5]=~/$s_2[0]/) && ($s_2[5]=~/$s_1[0]/))   {$right_1000=$right_1000+2; }
                     else {$wrong_1000=$wrong_1000+2;} 
                }
             }
print "rsID\t$India\tWorld\tWorld+India\t1000G-SoutAsia\tTotal\n";
if($t==0)
 {}
else {
      $c_india=$right_india;
      $c_world=$right_world;
      $c_world_india=$right_world_india;
      $c_1000g=$right_1000;
        }
print output1 "$rs\t$c_india\t$c_world\t$c_world_india\t$c_1000g\t$t\n";
   }

}

