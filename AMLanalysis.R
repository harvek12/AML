#Krysten Harvey

source("https://bioconductor.org/biocLite.R")
biocLite("maftools")
require("maftools")
aml <- read.maf(maf ="/Users/admin/Documents/Genomesci/LAML/AML1/genome.wustl.edu_LAML.IlluminaHiSeq_DNASeq_automated.1.1.0.somatic.maf", clinicalData = "/Users/admin/Documents/practice/finalannotation6.tsv")

#plot summary of top 30 genes mutated
oncoplot(maf = aml, top = 30, fontSize = 10)

#finding associations between KIT mutatations and epigenetic mutations
oncostrip(maf = aml, genes = c('KIT','TET2','DNMT3A','CBL'))
oncostrip(maf = aml, genes = c('KIT','TET2'))
oncostrip(maf = aml, genes = c('KIT','DNMT3A'))
oncostrip(maf = aml, genes = c('KIT','CBL'))
oncostrip(maf = aml, genes = c('KIT','DNMT3A','TET2'))
oncostrip(maf = aml, genes = c('KIT','DNMT3A','CBL'))
oncostrip(maf = aml, genes = c('KIT','TET2','CBL'))


#pull top 3 associations and do survival analysis, split into exposure to drug and no exposure
#subset of patients with drug and no drug exposure gained from bash command:
#awk -F "\t" '{ if($5 == "Yes" || $5 == "history_neoadjuvant_treatment" || $5 == "CDE_ID:3382737" || $5 == "history_of_neoadjuvant_treatment") { print }}' finalannotation6.tsv > final_with_drug3.tsv

clinical_no_drug <- read.table(file='/Users/admin/Documents/practice/final_with_nodrug3.tsv', sep="\t", quote="", comment.char="", header=TRUE)
clinical_with_drug <- read.table(file='/Users/admin/Documents/practice/final_with_drug3.tsv', sep="\t", quote="", comment.char="", header=TRUE)


aml_survival_all= mafSurvival(maf = aml, genes = c('KIT','TET2','DNMT3A','CBL'), clinicalData=clinical_no_drug, time = 'days_to_death', Status = 'Overall_Survival_Status')
aml_survival_alldrug= mafSurvival(maf = aml, genes = c('KIT','TET2','DNMT3A','CBL'), clinicalData=clinical_with_drug, time = 'days_to_death', Status = 'Overall_Survival_Status')

aml_survival_B= mafSurvival(maf = aml, genes = c('KIT','TET2','DNMT3A'), clinicalData=clinical_no_drug, time = 'days_to_death', Status = 'Overall_Survival_Status')
aml_survival_Bdrug= mafSurvival(maf = aml, genes = c('KIT','TET2','DNMT3A'), clinicalData=clinical_with_drug, time = 'days_to_death', Status = 'Overall_Survival_Status')


aml_survival_C= mafSurvival(maf = aml, genes = c('KIT','DNMT3A','CBL'), clinicalData=clinical_no_drug, time = 'days_to_death', Status = 'Overall_Survival_Status')
aml_survival_Cdrug= mafSurvival(maf = aml, genes = c('KIT','DNMT3A','CBL'), clinicalData=clinical_with_drug, time = 'days_to_death', Status = 'Overall_Survival_Status')

