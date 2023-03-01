%macro create_lib;
*Create a folder for comparison if required;
%let complib=%str(/mnt/code/ISS/test/);
%let complib_data=%str(/mnt/data/US_PhUSE_ISS_Tool/test/);
%let compn = 3;
%let lib1=STUDY1;
%let lib2=STUDY2;
%let lib3=STUDY3;
%let createlib = %sysfunc(dequote(&complib.));
%let createlib_data = %sysfunc(dequote(&complib_data.));

data _null_;
  call symput("folder","&createlib.");
  call symput("folderd","&createlib_data.");
  call symput("adam","&createlib_data./adamdata/");
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
x "mkdir &folderd";
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
    call symput("crlib&z.C","&createlib_data.adamdata/&&lib&z..C/");
    call symput("crlib&z.","&createlib_data.adamdata/&&lib&z../");
run;

x "mkdir &&&crlib&z.C.";
x "mkdir &&crlib&z..";

%end;

%mend create_lib;
%create_lib;