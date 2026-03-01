# org.Hs.eg.db3 is a prototype of a replacement of org.Hs.eg.db with parquet-based org.Hs resource

## The partly implicit API

Resources available from the `org.Hs.eg.db` package in Bioc 3.22 are:
```
 [1] "org.Hs.eg"                "org.Hs.eg_dbconn"         "org.Hs.eg_dbfile"        
 [4] "org.Hs.eg_dbInfo"         "org.Hs.eg_dbschema"       "org.Hs.eg.db"            
 [7] "org.Hs.egACCNUM"          "org.Hs.egACCNUM2EG"       "org.Hs.egALIAS2EG"       
[10] "org.Hs.egCHR"             "org.Hs.egCHRLENGTHS"      "org.Hs.egCHRLOC"         
[13] "org.Hs.egCHRLOCEND"       "org.Hs.egENSEMBL"         "org.Hs.egENSEMBL2EG"     
[16] "org.Hs.egENSEMBLPROT"     "org.Hs.egENSEMBLPROT2EG"  "org.Hs.egENSEMBLTRANS"   
[19] "org.Hs.egENSEMBLTRANS2EG" "org.Hs.egENZYME"          "org.Hs.egENZYME2EG"      
[22] "org.Hs.egGENENAME"        "org.Hs.egGENETYPE"        "org.Hs.egGO"             
[25] "org.Hs.egGO2ALLEGS"       "org.Hs.egGO2EG"           "org.Hs.egMAP"            
[28] "org.Hs.egMAP2EG"          "org.Hs.egMAPCOUNTS"       "org.Hs.egOMIM"           
[31] "org.Hs.egOMIM2EG"         "org.Hs.egORGANISM"        "org.Hs.egPATH"           
[34] "org.Hs.egPATH2EG"         "org.Hs.egPFAM"            "org.Hs.egPMID"           
[37] "org.Hs.egPMID2EG"         "org.Hs.egPROSITE"         "org.Hs.egREFSEQ"         
[40] "org.Hs.egREFSEQ2EG"       "org.Hs.egSYMBOL"          "org.Hs.egSYMBOL2EG"      
[43] "org.Hs.egUCSCKG"          "org.Hs.egUNIPROT"        
```

The `org.Hs.eg.db` is an instance of OrgDb defined in AnnotationDbi.  The architect
of AnnotationDbi has left the project.  The toolkit for producing org.Hs.eg.db is
complex, and as of Bioconductor 3.22, no bandwidth is available to maintain it.
Attempts to follow the documentation invariably lead to error and ad hoc patching.

Can the main resources be made available in a simpler way?  The key data source,
implied by the 'eg' in the package name, is NCBI Gene.

Let's explore the package contents.

```
> org.Hs.eg()
Quality control information for org.Hs.eg:

This package has the following mappings:

org.Hs.egACCNUM has 47268 mapped keys (of 193613 keys)
org.Hs.egACCNUM2EG has 1008918 mapped keys (of 1008918 keys)
org.Hs.egALIAS2EG has 261726 mapped keys (of 261726 keys)
org.Hs.egCHR has 193547 mapped keys (of 193613 keys)
org.Hs.egCHRLENGTHS has 711 mapped keys (of 711 keys)
org.Hs.egCHRLOC has 28279 mapped keys (of 193613 keys)
org.Hs.egCHRLOCEND has 28279 mapped keys (of 193613 keys)
org.Hs.egENSEMBL has 39386 mapped keys (of 193613 keys)
org.Hs.egENSEMBL2EG has 42336 mapped keys (of 42336 keys)
org.Hs.egENSEMBLPROT has 6620 mapped keys (of 193613 keys)
org.Hs.egENSEMBLPROT2EG has 28110 mapped keys (of 28110 keys)
org.Hs.egENSEMBLTRANS has 12710 mapped keys (of 193613 keys)
org.Hs.egENSEMBLTRANS2EG has 42867 mapped keys (of 42867 keys)
org.Hs.egENZYME has 2229 mapped keys (of 193613 keys)
org.Hs.egENZYME2EG has 975 mapped keys (of 975 keys)
org.Hs.egGENENAME has 193613 mapped keys (of 193613 keys)
org.Hs.egGENETYPE has 193613 mapped keys (of 193613 keys)
org.Hs.egGO has 20835 mapped keys (of 193613 keys)
org.Hs.egGO2ALLEGS has 22131 mapped keys (of 22131 keys)
org.Hs.egGO2EG has 18864 mapped keys (of 18864 keys)
org.Hs.egMAP has 70449 mapped keys (of 193613 keys)
org.Hs.egMAP2EG has 1976 mapped keys (of 1976 keys)
org.Hs.egOMIM has 17516 mapped keys (of 193613 keys)
org.Hs.egOMIM2EG has 24388 mapped keys (of 24388 keys)
org.Hs.egPATH has 5868 mapped keys (of 193613 keys)
org.Hs.egPATH2EG has 229 mapped keys (of 229 keys)
org.Hs.egPMID has 163069 mapped keys (of 193613 keys)
org.Hs.egPMID2EG has 804160 mapped keys (of 804160 keys)
org.Hs.egREFSEQ has 46047 mapped keys (of 193613 keys)
org.Hs.egREFSEQ2EG has 475603 mapped keys (of 475603 keys)
org.Hs.egSYMBOL has 193613 mapped keys (of 193613 keys)
org.Hs.egSYMBOL2EG has 193512 mapped keys (of 193512 keys)
org.Hs.egUCSCKG has 37507 mapped keys (of 193613 keys)
org.Hs.egUNIPROT has 19846 mapped keys (of 193613 keys)

Additional Information about this package:

DB schema: HUMAN_DB
DB schema version: 2.1
Organism: Homo sapiens
Date for NCBI data: 2025-Sep24
Date for GO data: 2025-07-22
Date for KEGG data: 2011-Mar15
Date for Golden Path data: UTC-Sep26
Date for Ensembl data: 2025-Sep03
```
The use of 2011 KEGG information is questionable.  The date for "Golden Path"
is odd, and likely refers to an extract of information from UCSC.
The AnnotationDbi approach predates the TxDb and EnsDb concepts.

### Using an environment

#### "PATH"

The documentation says:
```
org.Hs.egPATH           package:org.Hs.eg.db           R Documentation

Mappings between Entrez Gene identifiers and KEGG pathway identifiers

Description:

     KEGG (Kyoto Encyclopedia of Genes and Genomes) maintains pathway
     data for various organisms. org.Hs.egPATH maps entrez gene
     identifiers to the identifiers used by KEGG for pathways

Details:

     Each KEGG pathway has a name and identifier. Pathway name for a
```
According to the code browser, this environment is used in 22 files in
the ecosystem, in packages CBNplot, RTopper, and GOstats among a few
others.  as.list and toTable methods are used.  How do these work?


```
> head(toTable(org.Hs.egPATH))
  gene_id path_id
1       2   04610
2       9   00232
3       9   00983
4       9   01100
5      10   00232
6      10   00983
> head(as.list(org.Hs.egPATH))
$`1`
[1] NA

$`2`
[1] "04610"

$`9`
[1] "00232" "00983" "01100"

$`10`
[1] "00232" "00983" "01100"

$`11`
[1] NA

$`12`
[1] NA
```

This is so obsolete that we can just pass the environment from 3.22 to any new incarnation.

#### GO

Here's an illustration from an scde man page.
```
go.env <- mget(ls(org.Hs.egGO2ALLEGS)[1:10], org.Hs.egGO2ALLEGS)
> go.env
$`GO:0000009`
    IEA     IGI     IMP     IBA     IEA     IMP     IDA     IEA 
"55650" "55650" "55650" "79087" "79087" "79087" "85365" "85365" 

$`GO:0000012`
        IDA         IDA         IDA         NAS         IDA         TAS         IEA         IMP 
     "1161"      "2074"      "3981"      "7014"      "7141"      "7374"      "7515"      "7515" 
        IMP         IMP         IBA         IDA         IEA         IMP         IDA         IDA 
     "8859"     "23411"     "54840"     "54840"     "54840"     "54840"     "55247"     "55775" 
        IEA         IMP         IMP         IEA 
    "55775"     "55775"    "200558" "100133315" 

$`GO:0000014`
    IBA     IDA     IMP     IBA     IMP     IBA     IDA     TAS     IMP     IBA     IDA     IMP 
 "2021"  "2067"  "2067"  "2072"  "2072"  "4361"  "4361"  "4361"  "5932"  "6419"  "6419"  "6419" 
    IEA     IBA     IDA     IDA     IDA 
 "7515"  "9941" "10111" "28990" "64421" 
...
```
The evidence code is the name of the gene id.

### Upshots

The environments are somewhat complex mappings between identifier sets.

The requirements of GSEABase might be difficult to satisfy with any modifications
to the legacy API.  In particular, `GSEABase:::.GOFilterIds` uses `annotate::getAnnMap`.

## Trying to break away

We have filtered the NCBI text files to taxid 9606 and transformed them to parquet.

Consider the function
```
> fullread
function() {
gene2gopath = system.file("extdata", "Hs.gene2go.parquet", package="org.Hs.eg.db3")
arrow::read_parquet(gene2gopath)
}
```
This produces
```
> ff = fullread()
> dim(ff)
[1] 464183      8
> head(ff)
  #tax_id GeneID      GO_ID Evidence  Qualifier
1    9606      1 GO:0004888      IBA    enables
2    9606      1 GO:0005576      HDA located_in
3    9606      1 GO:0005576      IDA located_in
4    9606      1 GO:0005576      IEA located_in
5    9606      1 GO:0005576      TAS located_in
6    9606      1 GO:0005615      HDA located_in
                                    GO_term            PubMed  Category
1 transmembrane signaling receptor activity                 -  Function
2                      extracellular region 27068509|27559042 Component
3                      extracellular region           3458201 Component
4                      extracellular region                 - Component
5                      extracellular region                 - Component
6                       extracellular space          16502470 Component
```
so it will be easy to produce the GO2ALLEGS environment.

What about `annotate::getAnnMap`?  The code browser returns 190 uses.
What is the API?

```
Usage:

     getAnnMap(map, chip, load = TRUE, type = c("db", "env"))
     
Arguments:

     map: a string specifying the name of the map to retrieve.  For
          example, '"ENTREZID"' or '"GO"'

    chip: a string describing the chip or genome

    load: a logical value.  When 'TRUE', 'getAnnMap' will try to load
          the annotation data package if it is not already attached.

    type: a character vector of one or more annotation data package
          types.  The currently supported types are '"db"' and '"env"'.
          If 'load' is 'TRUE', you can specify both '"db"' and '"env"'
          and the order will determine which type is tried first.  This
          provides a fall-back mechanism when the preferred annotation
          data package type is not available.  If 'type' is missing,
          then the first matching annotation package found in the
          search path will be used, and then the default value of
          'type' takes over.
```

The API is clearly very flexible and complex.  This seems slow:

```
> getAnnMap("GO2ALLEGS", "org.Hs.eg.db") |> as.list() |> head(2)
$`GO:0000012`
        IDA         IDA         IDA         NAS         IDA         TAS 
     "1161"      "2074"      "3981"      "7014"      "7141"      "7374" 
        IEA         IMP         IMP         IMP         IBA         IDA 
     "7515"      "7515"      "8859"     "23411"     "54840"     "54840" 
        IEA         IMP         IDA         IDA         IEA         IMP 
    "54840"     "54840"     "55247"     "55775"     "55775"     "55775" 
        IMP         IEA 
   "200558" "100133315" 

$`GO:0000017`
   IDA    IMP    ISS    IDA 
"6523" "6523" "6523" "6524" 
```

We can get this type of result on the basis of `ff` computed above.

```
> gns = as.character(ff$GeneID)
> names(gns) = ff$Evidence
> gnl = split(gns, ff$GO_ID)
> gnl[c("GO:0000012", "GO:0000017")]
$`GO:0000012`
        IDA         IDA         IDA         IDA         IDA         TAS 
      "142"      "1161"      "2074"      "3981"      "7141"      "7374" 
        IEA         IMP         IBA         IMP         IBA         IDA 
     "7515"      "7515"     "11284"     "23411"     "54840"     "54840" 
        IEA         IMP         IDA         IDA         IEA         IMP 
    "54840"     "54840"     "55247"     "55775"     "55775"     "55775" 
        IMP         IEA 
   "200558" "100133315" 

$`GO:0000017`
   IDA    IMP    ISS    IDA 
"6523" "6523" "6523" "6524" 
```

Let's create an environment like org.HsGO2ALLEGS and see if
getAnnMap can work with it.

```
org.HsGO2ALLEGS = new.env(hash=TRUE)
nn = lapply(seq_len(length(gnl)), function(i) assign(names(gnl)[i], gnl[[i]], envir=org.HsGO2ALLEGS))
```
