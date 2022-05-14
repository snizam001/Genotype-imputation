# Genotype-imputation

This script is used to check imputation accuracy with different ancestral population as reference and purely for our Indian population samples with 207 individuals and 9624 SNPs. To run this script you should have Perl, Beagle and necessary input files (test/*bgl files).

Periyasamy Govindaraj#, Sheikh Nizamuddin# et al. Genome-wide analysis correlates Ayurveda Prakriti. 2015, Sci. Rep. 5, 15786.

REQUIREMENTS:
  
     Perl, Beagle
     Unix/Linux OS
     
INSTALLATION and COMMANDS:

    1. Please install Beagle.jar file (https://faculty.washington.edu/browning/beagle/b3.html) and generate its link to current directory where u have kept *bgl (input file format of BEAGLE tool).
    For example: if you have kept *bgl file to /Users/username/Desktop/directory and your beagle.jar file is in /Users/username/Desktop/software/
    generate link with:
    ln -s /Users/username/Desktop/software/beagle.jar /Users/username/Desktop/directory/
    
    2. Now copy provided test.tar.gz file to /Users/username/Desktop/directory/ and perform following commands on terminal:
    tar -zxvf test.tar.gz 
    mv test/* . 
    rm -r test
    
    3. Now u have everything to run the simulation with following command (in this step tools will automatically mask random genotype and imputation will be performed using Beagle tool; further concordance between masked and imputated genotype will be calculated):
    perl concordance.pl percentage number_of_permutation directory without_family.bgl
                 percentage: how much percentage, u want to masked.
                 number_of_permutation: how many times, u want to do simulation
                 directory: this is same directory where u have kept all *bgl files (Please give full path)

              example1: if you want to mask 2% genotype and perform 100 times simulation, u have to give following command:

              perl concordance.pl 2 100 /Users/username/Desktop/directory/ without_family.bgl
              
     



