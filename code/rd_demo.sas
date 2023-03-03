/******************Header Template V2***************************************
| Program Name: rd_dm1c.sas
|
| OS / SAS Version: Linux SAS 9.4
|
| Purpose: To create the Summary of Demographic Characteristics output
|
| Input Parameters: postsubset - to be used after tu_multisegments call
|                   presubset - to be used before tu_multisegments call
|                   tu_multisegments
|
| Input: ADaM datasets
| Output: L10 assosciated outputs
|
| Global macro variables created: n/a
|
| Macros called: 
| (@) tr_putlocals
| (@) tu_putglobals
| (@) tu_multisegments
| (@) tu_abort
*/

%macro demo(trtvar=, /*treatment group*/
               subgroup_txt=/*%str(Number of subjects in subgroup)*/,
               segment1=/*%str(analysisVars=age)*/,/*Parameters for freq/sumstatsinrows*/
               segment2=/*%str(groupByVarsNumer=&g_trtcd &g_trtgrp (Sex='n') sexcd sex,dsetout=segment2_out(rename=(sex=tt_decode1 sexcd=tt_code1)),codedecodevarpairs=&g_trtcd &g_trtgrp sexcd sex)*/,/*Parameters for freq/sumstatsinrows*/
               segment3=/*%str(groupByVarsNumer=&g_trtcd &g_trtgrp (ethnic='n') ethniccd ethnic,dsetout=segment3_out(rename=(ethnic=tt_decode1 ethniccd=tt_code1)),codedecodevarpairs=&g_trtcd &g_trtgrp ethniccd ethnic,psformat=ethniccd $ethnic.)*/,
               segment4= ,      /*Parameters for freq/sumstatsinrows*/
               segment5= ,      /*Parameters for freq/sumstatsinrows*/
               segment6= ,      /*Parameters for freq/sumstatsinrows*/
               segment7= ,      /*Parameters for freq/sumstatsinrows*/
               segment8= ,      /*Parameters for freq/sumstatsinrows*/
               segment9 =   ,   /*Parameters for freq/sumstatsinrows*/
               segment10 =  ,   /*Parameters for freq/sumstatsinrows*/
               segment11 =   ,  /*Parameters for freq/sumstatsinrows*/
               segment12 =   ,  /*Parameters for freq/sumstatsinrows*/
               segment13 =   ,  /*Parameters for freq/sumstatsinrows*/
               segment14 =   ,  /*Parameters for freq/sumstatsinrows*/
               segment15 =   ,  /*Parameters for freq/sumstatsinrows*/
               segment16 =  ,   /*Parameters for freq/sumstatsinrows*/
               segment17 =   ,  /*Parameters for freq/sumstatsinrows*/
               segment18 =   ,  /*Parameters for freq/sumstatsinrows*/
               segment19 =   ,  /*Parameters for freq/sumstatsinrows*/
               segment20 =  ,   /*Parameters for freq/sumstatsinrows*/
               acrossColVarPrefix       = /*tt_result*/, /* Text passed to the PROC TRANSPOSE PREFIX statement in tu_denorm. */
               acrossvar=/*&g_trtcd*/ ,       /* Variable that will be transposed to columns */
               acrossvardecode=/*&g_trtgrp*/, /* The name of a decode variable for ACROSSVAR */
               acrossVarListName        =,         /* Macro variable name to contain the list of columns created by the transpose of the first variable in VARSTODENORM.*/
               addbignyn                =/*Y*/,        /* Append the population N (N=nn) to the label of the transposed columns containg the results - Y/N */
               alignyn                  =/*Y*/,        /* Control execution of tu_align */
               denormyn                 =/*Y*/,        /* Transpose result variables from rows to columns across the ACROSSVAR - Y/N? */
               dsetin = /*adamdata.adsl*/, /* DSETIN for all segments.*/
               dsetout=,          /* Output summary dataset */
               break1                   =,         /* Break statements. */
               break2                   =,         /* Break statements. */
               break3                   =,         /* Break statements. */
               break4                   =,         /* Break statements. */
               break5                   =,         /* Break statements. */
               byvars                   =,         /* By variables */
               centrevars               =,         /* Centre justify variables */
               colspacing               =/*2*/,        /* Overall spacing value. */
               columns                  = /*tt_segorder tt_grplabel tt_code1  tt_decode1 tt_result:*/ , /* Column parameter */
               computebeforepagelines   =,         /* Specifies the text to be produced for the Compute Before Page lines (labelkey labelfmt colon labelvar)*/
               computebeforepagevars    =,         /* Names of variables that shall define the sort order for  Compute Before Page lines */
               dddatasetlabel           = DD dataset for td_dm1 display,         /* Label to be applied to the DD dataset */
               defaultwidths            =,         /* List of default column widths */
               descending               =,         /* Descending ORDERVARS */
               display                  =/*Y*/,        /* Specifies whether the report should be created */
               flowvars                 =/*_ALL_*/,    /* Variables with flow option */
               formats                  =,         /* Format specification */
               idvars                   =,         /* ID variables    */
               labels                   =,         /* Label definitions. */
               labelvarsyn              =/*Y*/,        /* Control execution of tu_labelvars */
               leftvars                 =,         /* Left justify variables */
               linevars                 =,         /* Order variable printed with line statements. */
               noprintvars              =/*tt_segorder tt_code1*/, /* No print vars (usually used to order the display) */
               nowidowvar               =,         /* Not in Version 1 */
               orderdata                =,         /* ORDER=DATA variables */
               orderformatted           =,         /* ORDER=FORMATTED variables */
               orderfreq                =,         /* ORDER=FREQ variables */
               ordervars                =/*tt_segorder  tt_grplabel tt_code1*/ , /* Order variables */
               overallsummary           =/*N*/,        /* Overall summary line at top of tables */
               pagevars                 =,         /* Break after <var> / page */
               proptions                =/*headline*/, /* PROC REPORT statement options */
               rightvars                =,         /* Right justify variables */
               sharecolvars             =,         /* Order variables that share print space. */
               sharecolvarsindent       =/*2*/,        /* Indentation factor */
               skipvars                 = /*tt_segorder*/ ,         /* Break after <var> / skip */
               splitchar                =~,        /* Split character */
               stackvar1                =,         /* Create Stacked variables (e.g. stackvar1=%str(varsin=invid subjid, varout=st_inv_subj,sepc=/,splitc=~)) */
               stackvar2                =,         /* Create Stacked variables (e.g. stackvar2=%str(varsin=invid subjid, varout=st_inv_subj,sepc=/,splitc=~)) */
               stackvar3                =,         /* Create Stacked variables (e.g. stackvar3=%str(varsin=invid subjid, varout=st_inv_subj,sepc=/,splitc=~)) */
               stackvar4                =,         /* Create Stacked variables (e.g. stackvar4=%str(varsin=invid subjid, varout=st_inv_subj,sepc=/,splitc=~)) */
               stackvar5                =,         /* Create Stacked variables (e.g. stackvar5=%str(varsin=invid subjid, varout=st_inv_subj,sepc=/,splitc=~)) */
               stackvar6                =,         /* Create Stacked variables (e.g. stackvar6=%str(varsin=invid subjid, varout=st_inv_subj,sepc=/,splitc=~)) */
               stackvar7                =,         /* Create Stacked variables (e.g. stackvar7=%str(varsin=invid subjid, varout=st_inv_subj,sepc=/,splitc=~)) */
               stackvar8                =,         /* Create Stacked variables (e.g. stackvar8=%str(varsin=invid subjid, varout=st_inv_subj,sepc=/,splitc=~)) */
               stackvar9                =,         /* Create Stacked variables (e.g. stackvar9=%str(varsin=invid subjid, varout=st_inv_subj,sepc=/,splitc=~)) */
               stackvar10               =,         /* Create Stacked variables (e.g. stackvar10=%str(varsin=invid subjid, varout=st_inv_subj,sepc=/,splitc=~)) */
               stackvar11               =,         /* Create Stacked variables (e.g. stackvar11=%str(varsin=invid subjid, varout=st_inv_subj,sepc=/,splitc=~)) */
               stackvar12               =,         /* Create Stacked variables (e.g. stackvar12=%str(varsin=invid subjid, varout=st_inv_subj,sepc=/,splitc=~)) */
               stackvar13               =,         /* Create Stacked variables (e.g. stackvar13=%str(varsin=invid subjid, varout=st_inv_subj,sepc=/,splitc=~)) */
               stackvar14               =,         /* Create Stacked variables (e.g. stackvar14=%str(varsin=invid subjid, varout=st_inv_subj,sepc=/,splitc=~)) */
               stackvar15               =,         /* Create Stacked variables (e.g. stackvar15=%str(varsin=invid subjid, varout=st_inv_subj,sepc=/,splitc=~)) */
               varlabelstyle            =/*SHORT*/,    /* Specifies the label style for variables (SHORT or STD) */
               varspacing               =,         /* Spacing for individual variables. */
               varstodenorm             =/*tt_result*/, /* Variable to be transposed */
               widths                   = /*tt_grplabel 9  tt_decode1 19 tt_result0001-tt_result9999 13*/,  /* Column widths */
               xmldefaults              = /*&g_refdata/tr_dm1_defaults.xml*/, /*   Location and name of XML defaults file for td macro*/
               ynvars                   =,         /* List of Yes/No variables that require codes and decodes */
               ynorderfmt               =/*$ynorder.*/,/* Format for creating order variables corresponding to YNVARS */
               yndecodefmt              =/*$yndecod.*/, /* Format for creating decode variables corresponding to YNVARS */
               trtcdvar=,
               trtgrpvar=,
               postsubset=,
               presubset=
               );

  %local MacroVersion;
  %let MacroVersion = 3;
  %include "&g_refdata/tr_putlocals.sas";
  %tu_putglobals()

  /* Name of dataset specified in XML defaults file. */
  %local ddname;
  %let ddname = DM1; 

/*
  data _null_;
    put "WARN" "ING (USER DEFINED): High Level Race term MULTIPLE reformatted as MIXED RACE for the output";
  run;
*/

 %let subgroup_txt=%str(Number of Subjects in Subgroup);

  * 24-Mar-2021 ej972409 Removed the code dropping subjects with missing race;
  data _dsetin(drop=sex /*where=(not missing(trt))*/);
    set &dsetin;
    %unquote(&presubset);
    length sex1 $8. race_ $41;
    
    

    /* High Level Race and Number */ 
   if not missing(race) then do;
     race_=race;
     race_num=input(race_, hlrace_num. );
     racen_char=strip(put(race_num, best8.));
   end;

    /* Race Detail and Number */
   if not missing(aracen) then do;
     racecd=strip(upcase(arace));
     aracen=input(arace, raced_num.);
     aracen_char=strip(put(aracen, best8.));
   end;

    if agegr1n=. then agegr1n=99;
    if agegr2n=. then agegr2n=99;


    if sexn=. then do sexn=3; sex1="Missing"; end;
    else sex1=sex;


    trtn = &trtvar.n;
    trt = &trtvar.;
    subn=1;
    subc="&subgroup_txt";  label subc='DUMMY'; 
  run;

  %let dsetin=_dsetin;
  %let g_popdata= _dsetin;

  %tu_multisegments(segment1 = &segment1,
                    segment2 = &segment2,
                    segment3 = &segment3,
                    segment4 = &segment4,
                    segment5 = &segment5,
                    segment6 = &segment6,
                    segment7 = &segment7,
                    segment8 = &segment8,
                    segment9 = &segment9,
                    segment10 = &segment10,
                    segment11 = &segment11,
                    segment12 = &segment12,
                    segment13 = &segment13,
                    segment14 = &segment14,
                    segment15 = &segment15,
                    segment16 = &segment16,
                    segment17 = &segment17,
                    segment18 = &segment18,
                    segment19 = &segment19,
                    segment20 = &segment20,
                    display= &display,
                    acrossColVarPrefix = &acrossColVarPrefix,
                    acrossvar=&acrossvar,
                    acrossvardecode=&acrossvardecode,
                    acrossVarListName = &acrossVarListName,
                    addbignyn =&addbignyn,
                    alignyn=&alignyn,
                    denormyn=&denormyn,
                    varstodenorm=&varstodenorm,
                    labelvarsyn= &labelvarsyn ,
                    varlabelstyle= &varlabelstyle,
                    stackvar1 = &stackvar1,
                    stackvar2 = &stackvar2,
                    stackvar3 = &stackvar3,
                    stackvar4 = &stackvar4,
                    stackvar5 = &stackvar5,
                    stackvar6 = &stackvar6,
                    stackvar7 = &stackvar7,
                    stackvar8 = &stackvar8,
                    stackvar9 = &stackvar9,
                    stackvar10 = &stackvar10,
                    stackvar11 = &stackvar11,
                    stackvar12 = &stackvar12,
                    stackvar13 = &stackvar13,
                    stackvar14 = &stackvar14,
                    stackvar15 = &stackvar15,
                    dddatasetlabel = &dddatasetlabel,
                    ddname = &ddname,
                    dsetin = &dsetin,
                    dsetout = &dsetout,
                    computebeforepagelines = &computebeforepagelines,
                    computebeforepagevars = &computebeforepagevars,
                    columns = &columns,
                    ordervars = &ordervars,
                    sharecolvars = &sharecolvars,
                    sharecolvarsindent = &sharecolvarsindent,
                    overallsummary = &overallsummary,
                    linevars = &linevars,
                    descending = &descending,
                    orderformatted = &orderformatted,
                    orderfreq = &orderfreq,
                    orderdata = &orderdata,
                    noprintvars = &noprintvars,
                    byvars = &byvars,
                    flowvars = &flowvars,
                    widths = &widths,
                    defaultwidths = &defaultwidths,
                    skipvars = &skipvars,
                    pagevars = &pagevars,
                    idvars = &idvars,
                    centrevars = &centrevars,
                    leftvars = &leftvars,
                    rightvars = &rightvars,
                    colspacing = &colspacing,
                    varspacing = &varspacing,
                    formats = &formats,
                    labels = &labels,
                    break1 = &break1,
                    break2 = &break2,
                    break3 = &break3,
                    break4 = &break4,
                    break5 = &break5,
                    proptions = &proptions,
                    nowidowvar = &nowidowvar,
                    splitchar = &splitchar,
                    xmldefaults = &xmldefaults,
                    ynvars = &ynvars,
                    ynorderfmt = &ynorderfmt,
                    yndecodefmt = &yndecodefmt,
                    postsubset  =&postsubset) ;

  %tu_abort;

%mend demo;
