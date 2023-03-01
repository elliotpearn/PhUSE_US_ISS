/******************Header Template V2***************************************
| Program Name: iss_comparison.sas
| Purpose: Tool to compare ISS study datasets back to original studies.
| Input Parameters: 
| NAME                  DESCRIPTION                                                      DEFAULT
| -----------------     ------------------------------------------------------------    --------
| MAINLIB               Specifies the file directory of the ISS                          (None)
|
| COMPLIB               Specifies the file directory where the compare datasets          (None)
|                       will be created. RECOMMEND: Creating a test area within the 
|                       same RE and copying folder structure.
|
| COMPN                 Specifies the number of studies included in the ISS              (None)
|
| DS_REMOVE             Specifies the name of any datasets that you do not want          (None)
|                       to compare
|
| LIB1-LIB6             Specifies the short names of the individual origin studies       (None)
|                       used to create datasets and library names (e.g STUDY1 for 1st
|                       comparison study)
|
| FILTER1-6             Specifies the filter required on the ISS datasets to create      (None) 
|                       origin study datasets
|                       
|
| COMPLIB1-6            Specifies the library of the origin study                        (None)
|
| CSV                   Specifies the location and name of the CSV file required         (None)
|                       for renaming variables for comparison - ISS_Var_Rename.csv. 
|                       CSV has 3 columns:
|                         DATASET - specify datasets where change is required in.
|                         STUDY - origin study where change is required 
|                                (needs to match values in LIB1-LIB6)
|                         OLD_VAR - Name of variable in origin study
|                         NEW_VAR - Name of variable in ISS study                 
|
|
| COMPLOC               Specifies the desired location of the Compare PDFs               (None)
|
| DISP                  Specifies whether Displays will also be compared                  N
|
| DATAC                 Specifies whether Datasets will be compared                       Y
|
| DRIVLIB               Specifies the location of the display drivers                    (None)
|
| Input: n/a
| Output: list of output files or responses or `n/a`
|
| Global macro variables created: n/a
|
| Macros called: n/a
| 
|
| Additional Notes: 
|
|***************************************************************************
| ~Change Log~
| Version | Developer | Date        | Description
| 1       | ep582653 | 30-MAR-2022  | Creation
|
****************************************************************************/

%macro iss_comparison(
        folder =N,
        mainlib=,
        complib=,
        compn=,
        ds_remove =,
        lib1=,
        lib2=,
        lib3=,
        lib4=,
        lib5=,
        lib6=,
        filter1=,
        filter2=,
        filter3=,
        filter4=,
        filter5=,
        filter6=,
        complib1=,
        complib2=,
        complib3=,
        complib4=,
        complib5=,
        complib6=,
        compfilt1=,
        compfilt2=,
        compfilt3=,
        compfilt4=,
        compfilt5=,
        compfilt6=,
        csv =,
        comploc =,
        disp=N,
        datac=Y,
        drivlib =
        );

***********************************************;
************* USE IN ARWORK ONLY **************;
***********************************************;
/*
%let mainlib_data=%str(/mnt/data/US_PhUSE_ISS_Tool/ISS);
%let mainlib=%str(/mnt/code/ISS/);
%let compn=3;
%let ds_remove =;
%let lib1=STUDY1;
%let lib2=STUDY2;
%let lib3=STUDY3;
%let filter1=%str(STUDYID = "STUDY1");
%let filter2=%str(STUDYID = "STUDY2");
%let filter3=%str(STUDYID = "STUDY3");
%let csv = %str(/mnt/code/CSV/ISS_Var_Rename.csv);
%let complib1=%str('/mnt/data/US_PhUSE_ISS_Tool/Original/STUDY1');
%let complib2=%str('/mnt/data/US_PhUSE_ISS_Tool/Original/STUDY2');
%let complib3=%str('/mnt/data/US_PhUSE_ISS_Tool/Original/STUDY3');
%let comploc=%str(/mnt/code/ISS/Compares/);
%let compfilt1=;
%let compfilt2=;
%let compfilt3=;
%let compfilt4=;
%let compfilt5=;
%let disp = N;
%let drivlib = %str(/mnt/code/ISS/);
*/

%if &datac= Y %then %do;

%if folder = Y %then %do;
%macro create_lib;
*Create a folder for comparison if required;
%let createlib = %sysfunc(dequote(&complib.));

data _null_;
  call symput("folder","&createlib.");
  call symput("adam","&createlib./adamdata/");
  call symput("ardata","&createlib./ardata/");
  call symput("code","&createlib./code/");
  call symput("dddata","&createlib./dddata/");
  call symput("documents","&createlib./documents/");
  call symput("driver","&createlib./drivers/");
  call symput("output","&createlib./output/");
  call symput("pkdata","&createlib./pkdata/");
  call symput("rawdata","&createlib./rawdata/");
  call symput("refdata","&createlib./refdata/");
  call symput("logs","&createlib./saslogs/");
  call symput("sdtm","&createlib./sdtm/");
run;

x "mkdir &folder";
x "mkdir &adam";
x "mkdir &ardata";
x "mkdir &code";
x "mkdir &dddata";
x "mkdir &documents";
x "mkdir &driver";
x "mkdir &output";
x "mkdir &pkdata";
x "mkdir &rawdata";
x "mkdir &refdata";
x "mkdir &logs";
x "mkdir &sdtm";

%do z = 1 %to &compn;
data _null_;
    call symput("crlib&z.C","&createlib.adamdata/&&lib&z..C/");
    call symput("crlib&z.","&createlib.adamdata/&&lib&z../");
run;

x "mkdir &&&crlib&z.C.";
x "mkdir &&crlib&z..";

%end;

%mend create_lib;
%create_lib;

%end;

**Create lib_list macro variable which is used throughout;
%macro create_lib_list;
%macro var;

data lib_list;
    %do a = 1 %to &compn.;
        length lib $200;
        lib= strip("&&lib&a..");
        output;
    %end;
run; 

%mend;
%var;
                                                                                                                                                                                                                                               
%macro create();                                                                                                                                                                                                                                               
%let dsid=%sysfunc(open(lib_list));                                                                                                         
%let cnt=%sysfunc(attrn(&dsid,nobs));                                                                                                  
    %do b=1 %to &cnt.;                                                                                                                     
      %let rc=%sysfunc(fetchobs(&dsid,&b));                                                                                               
      %cmpres(%sysfunc(getvarc(&dsid,%sysfunc(varnum(&dsid,lib)))))                                                                     
    %end;                                                                                                                                 
  %let rc=%sysfunc(close(&dsid));                                                                                                        
%mend create;
                                                                                                                             
%global lib_list;
%let lib_list = %create;

%mend create_lib_list;
%create_lib_list;    

**First call filter_dd macro - which filters ISS datasets and outputs for just origin study records;
%macro filter_dd;
    %macro filter(lib=,dset_in=);

    **Read in current ADaMs and output to compare folder filtered for each origin study;
    libname comp "&complib.adamdata/&lib.C";
    data comp.&dset_in;
        set adamdata.&dset_in;

        %do i = 1 %to &compn.;

        %if &lib.=&&lib&i.. %then if &&filter&i..;;

        %end;
    run;

    %mend;

    ** Create macro variables for all ADaMs created in ISS;
    data files;
     keep filename;
     length fref $8 filename $80;
     rc = filename(fref, "&mainlib.adamdata/");
     if rc = 0 then
     do;
     did = dopen(fref);
     rc = filename(fref);
     end;
     dnum = dnum(did);
     do m = 1 to dnum;
     filename = dread(did, m);
     n = m;
     /* If this entry is a file, then output. */
     fid = mopen(did, filename);
     if fid > 0
     then
     output;
     end;
     rc = dclose(did);
     run;

     **Remove extension from filename and filter out any datasets we do not want to compare;
     data files;
        set files (where=(index(filename,".sas7bdat")>0));

        filename=compress(tranwrd(filename,".sas7bdat",""));

        if upcase(filename) not in (&ds_remove.);
     run;

    **Count datasets;
    %global ds_count;
     proc sql noprint;
        select count(*)
         into :ds_count
         from files;
     quit;

    **Create macro variable for each dataset;
     proc sql noprint;
        select filename into: dsnam1 - :dsnam%left(&ds_count.)
        from files;
     quit;

     %do g = 1 %to &ds_count;
     %global ds&g.;
     %let ds&g.=%str(&&dsnam&g..);
     %end;

    **Loop filter macro through each library and each dataset;
    %local j next_lib;
    %let j=1;
    %do %while (%scan(&lib_list, &j) ne );
       %let next_lib = %scan(&lib_list, &j);

        %do p = 1 %to &ds_count.;
           %filter(lib=&next_lib,dset_in=&&dsnam&p..);
        %end;
       
       %let j = %eval(&j + 1);
    %end;
%mend;
%filter_dd;

%put _global_;
**Get origin datasets ready for compare:
  - Rederive treatment variables in ADSL and merge onto required datasets
  - Rename or rederive any variables to allow for an easier compare;
%macro ds_comp_ready(inds=);

*Individual Study ADaMs - check latests REs;
%do k = 1 %to &compn.;
libname &&lib&k.. &&complib&k..;
%end;

%macro assign_trt(lib=);
data adsl_&lib.;
    set &lib..adsl (drop=trt01p trt01pn trt01a trt01an);

      ****STUDY SPECIFIC CODE - THIS WILL NEED TO BE UPDATED;
      ***Reassign Treatment Variables to previous studies so they match ISS;
      length trt01p trt01a $26 tr01pg1 tr01ag1 $10 tr01pg2 tr01ag2 $21 tr01pg3 tr01ag3 $30 tr01pg4 tr01ag4 $15;

      **Planned Treatments;
      **Placebo arm from ICE;
      if STUDYID eq "214367" then do;
        if ARMCD = "P" then do;
            trt01p = "Placebo";
            trt01pn = 1;
        end;
        **Covers Gen 1 from ICE and Peak A;
        else if ARMCD = "A" then do;
            trt01p = "Sotrovimab Gen1 (500mg IV)";
            trt01pn = 2;
        end;
      end;
      else if STUDYID eq "216912" then do;
        if ARMCD = "A" then do;
            trt01p = "Sotrovimab Gen1 (500mg IV)";
            trt01pn = 2;
        end;
        **Covers Gen2 IV from Peak A,B and C;
        else if ARMCD in ("B" "D" "F")  then do;
            trt01p = "Sotrovimab Gen2 (500mg IV)";
            trt01pn = 3;
        end;
        **IM arm from Peak B;
        else if ARMCD in ("C")  then do;
            trt01p = "Sotrovimab Gen2 (500mg IM)";
            trt01pn = 4;
        end;
        **IM arm from Peak C;
         else if ARMCD in ("E")  then do;
            trt01p = "Sotrovimab Gen2 (250mg IM)";
            trt01pn = 5;
        end;
      end;
      else if STUDYID eq "217114" then do;
        if ARMCD in ("A")  then do;
            trt01p = "Sotrovimab Gen2 (500mg IV)";
            trt01pn = 3;
        end;
        else if ARMCD in ("B")  then do;
            trt01p = "Sotrovimab Gen2 (500mg IM)";
            trt01pn = 4;
        end;
        else if ARMCD in ("C")  then do;
            trt01p = "Sotrovimab Gen2 (250mg IM)";
            trt01pn = 5;
        end;
      end;
      else if armcd = "NOTTRT" then do;
            trt01p = "Not Treated";
            trt01pn = 6;
      end;
      else if armcd = "SCRNFAIL" then do;
            trt01p = "Screen Failure";
            trt01pn = 0;
      end;

        **Actual Treatments;
        **Placebo arm from ICE;
      **Placebo arm from ICE;
      if STUDYID eq "214367" then do;
        if ACTARMCD = "P" then do;
            TRT01A = "Placebo";
            TRT01An = 1;
        end;
        **Covers Gen 1 from ICE and Peak A;
        else if ACTARMCD = "A" then do;
            TRT01A = "Sotrovimab Gen1 (500mg IV)";
            TRT01An = 2;
        end;
      end;
      else if STUDYID eq "216912" then do;
        if ACTARMCD = "A" then do;
            TRT01A = "Sotrovimab Gen1 (500mg IV)";
            TRT01An = 2;
        end;
        **Covers Gen2 IV from Peak A,B and C;
        else if ACTARMCD in ("B" "D" "F")  then do;
            TRT01A = "Sotrovimab Gen2 (500mg IV)";
            TRT01An = 3;
        end;
        **IM arm from Peak B;
        else if ACTARMCD in ("C")  then do;
            TRT01A = "Sotrovimab Gen2 (500mg IM)";
            TRT01An = 4;
        end;
        **IM arm from Peak C;
         else if ACTARMCD in ("E")  then do;
            TRT01A = "Sotrovimab Gen2 (250mg IM)";
            TRT01An = 5;
        end;
      end;
      else if STUDYID eq "217114" then do;
        if ACTARMCD in ("A")  then do;
            TRT01A = "Sotrovimab Gen2 (500mg IV)";
            TRT01An = 3;
        end;
        else if ACTARMCD in ("B")  then do;
            TRT01A = "Sotrovimab Gen2 (500mg IM)";
            TRT01An = 4;
        end;
         else if ACTARMCD in ("C")  then do;
            TRT01A = "Sotrovimab Gen2 (250mg IM)";
            TRT01An = 5;
        end;
      end;
      else if ACTARMCD = "NOTTRT" then do;
            TRT01A = "Not Treated";
            TRT01An = 6;
      end;
      else if ACTARMCD = "SCRNFAIL" then do;
            TRT01A = "Screen Failure";
            TRT01An = 0;
      end;

        **Pooled Treatment - Planned;
        **Sotrovimab vs Placebo;
        if trt01pn = 1 then do;
            tr01pg1 = "Placebo";
            tr01pg1n = 1;
        end;
        else if trt01pn in (2,3,4,5) then do;
            tr01pg1 = "Sotrovimab";
            tr01pg1n = 2;
        end;
        **500IV vs 500IM vs 250IM vs Placebo;
        if trt01pn = 1 then do;
            tr01pg2 = "Placebo";
            tr01pg2n = 1;
        end;
        else if trt01pn in (2,3) then do;
            tr01pg2 = "Sotrovimab (500mg IV)";
            tr01pg2n = 2;
        end;
        else if trt01pn in (4) then do;
            tr01pg2 = "Sotrovimab (500mg IM)";
            tr01pg2n = 3;
        end;
        else if trt01pn in (5) then do;
            tr01pg2 = "Sotrovimab (250mg IM)";
            tr01pg2n = 4;
        end;
        **500 IV/IM vs Placebo vs IM250;
        if trt01pn in (1) then do;
            tr01pg3 = "Placebo";
            tr01pg3n = 1;
        end;
        else if trt01pn in (2,3,4 ) then do;
            tr01pg3 = "Sotrovimab (500mg)";
            tr01pg3n = 2;
        end;
        else if trt01pn in (5) then do;
            tr01pg3 = "Sotrovimab (250mg IM)";
            tr01pg3n = 3;
        end;
        **IV vs IM vs Placebo;
        if trt01pn = 1 then do;
            tr01pg4 = "Placebo";
            tr01pg4n = 1;
        end;        
        else if trt01pn in (2,3) then do;
            tr01pg4 = "Sotrovimab (IV)";
            tr01pg4n = 2;
        end;
        else if trt01pn in (4,5) then do;
            tr01pg4 = "Sotrovimab (IM)";
            tr01pg4n = 3;
        end;

        **Pooled Treatment - Actual;
        **Sotrovimab vs Placebo;
        if trt01an = 1 then do;
            tr01ag1 = "Placebo";
            tr01ag1n = 1;
        end;
        else if trt01an in (2,3,4,5) then do;
            tr01ag1 = "Sotrovimab";
            tr01ag1n = 2;
        end;
        **500IV vs 500IM vs 250IM vs Placebo;
        if trt01an = 1 then do;
            tr01ag2 = "Placebo";
            tr01ag2n = 1;
        end;
        else if trt01an in (2,3) then do;
            tr01ag2 = "Sotrovimab (500mg IV)";
            tr01ag2n = 2;
        end;
        else if trt01an in (4) then do;
            tr01ag2 = "Sotrovimab (500mg IM)";
            tr01ag2n = 3;
        end;
        else if trt01an in (5) then do;
            tr01ag2 = "Sotrovimab (250mg IM)";
            tr01ag2n = 4;
        end;
        **500 IV/IM vs Placebo/IM250;
        if trt01an in (1) then do;
            tr01ag3 = "Placebo";
            tr01ag3n = 1;
        end;
        else if trt01an in (2,3,4 ) then do;
            tr01ag3 = "Sotrovimab (500mg)";
            tr01ag3n = 2;
        end;
        else if trt01an in (5) then do;
            tr01ag3 = "Sotrovimab (250mg IM)";
            tr01ag3n = 3;
        end;
        **IV vs IM vs Placebo;
        if trt01an = 1 then do;
            tr01ag4 = "Placebo";
            tr01ag4n = 1;
        end;        
        else if trt01an in (2,3) then do;
            tr01ag4 = "Sotrovimab (IV)";
            tr01ag4n = 2;
        end;
        else if trt01an in (4,5) then do;
            tr01ag4 = "Sotrovimab (IM)";
            tr01ag4n = 3;
        end;

run;

**If NON-ADSL dataset is required for TLF comparison - then merge rederived treatments onto old dataset;
**If ADSL then just rename dataset to be in correct format;
libname comp "&complib.adamdata/&lib./";

%do k = 1 %to &compn.;
   %if %sysfunc(exist(&lib..&inds.)) %then %do;
    %if &&lib&k.. = &lib. %then %do;
        data &inds._pre;
            set &lib..&inds.;

            %if &&compfilt&k.. ne %then %do;
            &&compfilt&k..;
            %end;
        run;
    %end;
   %end;
%end;

%let null = 0;

 %if %upcase(&inds.) ne ADSL %then %do;
  %if %sysfunc(exist(&lib..&inds.)) %then %do;
   data comp.&inds.;
    merge &inds._pre (drop=trt0: in=inDS) adsl_&lib. (keep=studyid usubjid trt0: tr0:);
    by studyid usubjid;

    if inDS;

   run;
  %end;

  %else %do;
    %let null = 1;

    data comp.&inds.;
        null = 1;
    run;

  %end;
 %end;
 %else %do;
   data comp.&inds.;
     set adsl_&lib.;

   run;
 %end;

**Import CSV file for renaming variables - all variables that are in both studies just with diff names;
%if &null. ne 1 %then %do;
proc import datafile="&csv."
		out=renam dbms=csv replace;
	getnames=YES;
	guessingrows=max;
run;

**Format memname to be the same as current datasets;
data renam_format;
    set renam;
    length memname $32;
    memname = strip(dataset);

    drop dataset;
run;

%let nam = %str(&lib._&inds._cont);

data ds_in;
    set %put &nam;;
run;

**Proc Contents to get attributes for variables;
proc contents data=comp.&inds. out=ds_in noprint;
title 'before renaming';
run;

**Set all attribute dataset together;
data cont_all;
    set ds_in;

    lib="&lib.";
run;
**Merge attributes with renaming dataset and only keep variables that are in both;
**Create a macro variable of the list of dataset that will need a variable renamed;
proc sql noprint;
    create table rename_identify as
    select a.memname, a.name, b.new_var, b.study
    from cont_all (where=(lib="&lib.")) as a, renam_format (where=(study="&lib.")) as b
    where a.memname = b.memname and a.name=b.old_var;

    select distinct(memname) into: ds_list
    separated by " "
    from rename_identify; 
quit;

**Create order variable;
proc sort data=rename_identify;
    by memname name;
run;

data rename_identify;
    set rename_identify;
    by memname name;
    
    retain varnum 0;
    if first.memname then varnum=1;
    else varnum=varnum+1;
run;

%end;

%if %symexist(ds_list) %then %do;

%macro renam(dsin=);

    **Read in required dataset and find number of vars required;
    data rename_num;
        set rename_identify (where=(memname="&dsin" and study="&lib."));
        by memname varnum;

        if first.memname then call symput("start",strip(put(varnum,best.)));
        if last.memname then call symput("end",strip(put(varnum,best.)));
    run;

    **Count number of obs and only run renaming code if needed;
    proc sql noprint;
       select count(*) into: nobs
       from rename_num;
    quit;

    %if &nobs ne 0 %then %do;

    **Create a list the old variables and the new variables into a macro variable;
    proc sql noprint;
        select distinct(name) into: old_list
        separated by " "
        from rename_identify (where=(memname="&dsin")); 
        select distinct(name) into: old_sql
        separated by ","
        from rename_identify (where=(memname="&dsin"));
        select distinct(new_var) into: new_list
        separated by " "
        from rename_identify (where=(memname="&dsin")); 
    quit;

    **Pull out the new variables and transpose so there is 1 record and all variables;
    proc transpose data=rename_identify (where=(memname="&dsin")) out=new_var_t (keep=&new_list);
        by memname;
        id new_var;
    run;

    data sortedby;
        set sashelp.vcolumn;
        where libname="ADAMDATA" and memname=upcase("&inds") and sortedby ne 0;
    run;

    proc sql noprint;
        select distinct(name) into: sorted_list
        separated by " "
        from sortedby; 
         select distinct(name) into: sorted_sql
        separated by ","
        from sortedby; 
    quit;

    **Create a temporary dataset containing old variables and merge variables;
    proc sql noprint;
        create table temp as
        select &old_sql, &sorted_sql
        from comp.&dsin;
    quit;

    **Create a second temporary dataset containing all variables but the old variables;
    proc sort data=comp.&dsin. out=temp2 (drop=&old_list);
        by &sorted_list;
    run;

    %LET ds=%SYSFUNC(OPEN(temp,i));
    %LET renam=%SYSFUNC(OPEN(new_var_t,i));

    **Renaming the variable process;
    %do i=&start %to &end;
        %let newnam&i=%SYSFUNC(VARNAME(&renam,&i));
        %let dsvn&i=%SYSFUNC(VARNAME(&ds,&i));
        %if %index(&sorted_list,%upcase(&&dsvn&i)) eq 0 %then %do;
            %let vn&i=&&newnam&i;
        
        **Use VCOLUMN dataset to get attributes so that we can set lengths/label varibles;
        data var_props;
            set sashelp.vcolumn;
            where libname="COMP" and memname="&dsin." and name="&&dsvn&i.";
            if type ne "" then call symputx("type&i",type,"G");
            
        run;

        data var_props2;
            set sashelp.vcolumn;
            where libname="ADAMDATA" and memname=upcase("&inds") and name=upcase("&&newnam&i.");
            if label ne "" then call symputx("lab&i",label);
            if type = "char" then if length ne . then call symputx("len&i",length);
       run;

       %end;
    %end;

    **Finalising renaming process;
    data temp_renam;
    set temp;

    %do i=&start %to &end;
    %if %index(&sorted_list,%upcase(&&dsvn&i)) eq 0 %then %do;
    %if &&type&i eq char %then %do;
    length &&vn&i $&&len&i;
    %end;
    &&vn&i=&&dsvn&i;
    label &&vn&i = "&&lab&i.";
    drop &&dsvn&i.;
    %end;
    %end;
    %let rc=%SYSFUNC(CLOSE(&ds));
    %let rc=%SYSFUNC(CLOSE(&renam));
    run;

    proc sort data=temp_renam;
        by &sorted_list;
    run;

    **Merge data back together with new variables;
    data comp.&dsin;
        merge temp2 (drop=&new_list) temp_renam ;
        by &sorted_list;
    run;

    %end;

%mend renam;

**Take list of datasets required and loop renaming macro through;
%local k next_ds;
%let k=1;
%do %while (%scan(&ds_list, &k) ne );
   %let next_ds = %scan(&ds_list, &k);
   %renam(dsin=&next_ds);
   %let k = %eval(&k + 1);
%end;
%end;

%mend assign_trt;
**Specify list of libraries and run macro through them;
%local q next_lib;
%let q=1;
%do %while (%scan(&lib_list, &q) ne );
   %let next_lib = %scan(&lib_list, &q);
   %assign_trt(lib=&next_lib);
   %let q = %eval(&q + 1);
%end;

%mend ds_comp_ready;
%macro test;
%do g = 1 %to &ds_count.;
   %ds_comp_ready(inds=&&ds&g..);
%end;
%mend test;
%test;

***Now run macro to compare datasets;
%macro compare_dd (in=,comp=);
  %tu_putglobals(varsin=g_fnc);
   %*- SET SYSTEM OPTIONS LOCALLY FOR THIS MACRO;
   %* we are going to create a lot of output (e.g. proc compare) so set pagesize to max ;
   %* first, save the current options so that we can restore at end of macro ;
   %let original_PS = %sysfunc(getoption(PS));
   %let original_ORIENTATION = %sysfunc(getoption(orientation));
   options ps=max orientation=landscape;

   %* Setup ODS output for PDF file with name using macro parameter (filein) ;
   %* with system date attached e.g. /path/to/file/name_27JUL21.pdf          ;
   %* where filein=/path/to/file/name                                        ;
   ods listing close;
   ods noresults;
   ods pdf file="&comploc.&in._Data_Compare.pdf";

   %macro comp_loop(lib=);
   
    %do t = 1 %to &compn;
        %if &in.=&ds1. %then %do;
            libname compc "&complib.adamdata/&lib.C";
            libname comp "&complib.adamdata/&lib.";
        %end;
    %end;

 %* define a value to accumulate all the proc compare results into;
%let compres=0;

   %* Loop through every dataset in the original/old library and proc compare ;
   %* with the dataset of same name in the new library.                       ;
      title  "Compare of &in.";
      title2 "from- &lib";
      title3 "to- ISS";
      proc compare base=comp.&in.
                   compare=compc.&in.
                   listall                  /* List all vars and obs differences */
                   maxprint=(50,2000);      /* limit diffs reported (per-var,total)*/
      run;
      %* accumulate the sysinfo (which is a binary value);
      %let compres = %sysfunc(bOR(&sysinfo, &compres.));

   %* once completed all proc compare, output result to log;
   %put %str(IN)FO: PROC COMPARE result for all datasets is [&compres.];

   %mend comp_loop;

**Specify list of libraries and run macro through them;
    %local s next_lib;
    %let s=1;
    %do %while (%scan(&lib_list, &s) ne );
       %let next_lib = %scan(&lib_list, &s);
       %comp_loop(lib=&next_lib);
       %let s = %eval(&s + 1);
    %end;
  ods pdf close;

   %* TIDY UP;

   %* restore the original PS (pagesize) option ;
   options PS=&original_PS orientation=&original_ORIENTATION;

%mend compare_dd;

%do p = 1 %to &ds_count.;
   %compare_dd(in=&&ds&p..);
%end;

%end;

******** DISPLAY COMPARISON SECTION *****************;
%if &disp = Y %then %do;
**** SAS 2 TERMINAL CODE  ****;
data copy;
  x echo Delete drivers from current folder to prevent overwriting;
  x cd &complib.drivers/;
  x \rm t_*.sas;
  x echo Copy drivers from prod into test area;
  x cd &drivlib.drivers;
  x cp -p t_*.sas &complib.drivers/;
  x echo Copy macros from prod into test area;
  x cd &drivlib.code;
  x cp -p rd_*.sas &complib.code/;
  x cp -p td_*.sas &complib.code/;
  x cp -p tu_*.sas &complib.code/;
  x cp -p ts_*.sas &complib.code/;
run;

data drivers;
 keep filename n;
 length fref $8 filename $80;
 rc = filename(fref, "&complib.drivers/");
 if rc = 0 then
 do;
 did = dopen(fref);
 rc = filename(fref);
 end;
 dnum = dnum(did);
 do c = 1 to dnum;
 filename = dread(did, c);
 n = c;
 /* If this entry is a file, then output. */
 fid = mopen(did, filename);
 if fid > 0
 then
 output;
 end;
 rc = dclose(did);
 run;

 data drivers;
    set drivers;

    filename=compress(tranwrd(filename,".sas",""));
 run;

 proc sql noprint;
    select count(*)
     into :file_count
     from drivers;
 quit;

 x echo File Count = &file_count;

proc sql noprint;
    select filename into: file1 - :file%left(&file_count.)
    from drivers;
quit;

data test;

%macro rename(lib=);

%let main = %sysfunc(scan(&mainlib.,-1));;
%let comp = %sysfunc(scan(&complib.,-1));;

x echo Starting Lib &lib.;
%if &lib. ne &lib1. %then %do;
x cd &drivlib.drivers;
x cp -p t_*.sas /arenv/arwork/gsk4182136/mid215199/iss_01/test/drivers/;
%end;
x cd &complib.drivers/;
%do i = 1 %to &file_count; ;
x echo Rename file &&file&i;
%if &i = 1 %then %do;
x echo Main = &main;
x echo Comp = &comp;
%end;

    x cp -p &drivlib.drivers/&&file&i...sas &complib.drivers/&&file&i.._&lib..sas; 
    x sed -i "s+&main/+&main/&comp/+" &complib.drivers/&&file&i.._&lib..sas;
    x sed -i 's+arprod/+arwork/+' &complib.drivers/&&file&i.._&lib..sas;
    x sed -i "s+/adamdata+/adamdata/\&lib+g" &complib.drivers/&&file&i.._&lib..sas;
    x sed -i "s/\.sas\>/_\&lib\.sas/g" &complib.drivers/&&file&i.._&lib..sas;
    x sed -i "s+/&&file&i..\>+/&&file&i.._&lib.+g"  &complib.drivers/&&file&i.._&lib..sas;
    x cd &complib.saslogs/;
    x sas ../drivers/&&file&i.._&lib..sas;
%end;
%mend;

%do d = 1 %to &compn.;
%rename(lib=&&lib&d..);
**ISS data filtered on specific study for comparison;
%rename(lib=&&lib&d..C);
%end;


run;

%macro compare_displays(ddlib=);

data files;
 keep filename n rc;
 length fref $8 filename $80;
 rc = filename(fref, "&drivlib.drivers/");
     if rc = 0 then
     do;
     did = dopen(fref);
     rc = filename(fref);
     end;
     dnum = dnum(did);
     do i = 1 to dnum;
     filename = dread(did, i);
     n = i;
     /* If this entry is a file, then output. */
     fid = mopen(did, filename);
     if fid > 0
     then
     output;
     end;
     rc = dclose(did);
 run;

 data files;
    set files (where=(index(filename,"t_")>0));

    filename=compress(tranwrd(filename,".sas",""));
 run;

 proc sql noprint;
    select count(*)
     into :file_count
     from files;
 quit;

 %put &file_count;

proc sql noprint;
    select filename into: file1 - :file%left(&file_count.)
    from files;
quit;


libname dddatac &ddlib.;

 %*- SET SYSTEM OPTIONS LOCALLY FOR THIS MACRO;
   %* we are going to create a lot of output (e.g. proc compare) so set pagesize to max ;
   %* first, save the current options so that we can restore at end of macro ;
   %let original_PS = %sysfunc(getoption(PS));
   %let original_ORIENTATION = %sysfunc(getoption(orientation));
   options ps=max orientation=landscape;

   %* Setup ODS output for PDF file with name using macro parameter (filein) ;
   %* with system date attached e.g. /path/to/file/name_27JUL21.pdf          ;
   %* where filein=/path/to/file/name                                        ;
   ods listing close;
   ods noresults;
   ods pdf file="&comploc.DDData_Compare.pdf";

   %macro comp_loop(lib=);
   %do i = 1 %to &file_count; ;
 %* define a value to accumulate all the proc compare results into;
    %let compres=0;

   %* Loop through every dataset in the original/old library and proc compare ;
   %* with the dataset of same name in the new library.                       ;
      title  "Compare of display";
      title2 "from- &lib";
      title3 "to- ISS";
      proc compare base=dddataC.&&file&i.._&lib.
                   compare=dddataC.&&file&i.._&lib.C
                   listall                  /* List all vars and obs differences */
                   maxprint=(50,2000);      /* limit diffs reported (per-var,total)*/
      run;
      %* accumulate the sysinfo (which is a binary value);
      %let compres = %sysfunc(bOR(&sysinfo, &compres.));
   %end;
   %mend comp_loop;
   %do d = 1 %to &compn.;
   %comp_loop(lib=&&lib&d..);
   %end;
  ods pdf close;

   %* TIDY UP;

   %* restore the original PS (pagesize) option ;
   options PS=&original_PS orientation=&original_ORIENTATION;

%mend compare_displays;

%compare_displays(ddlib="&complib.dddata");


%end;

%mend iss_comparison;




