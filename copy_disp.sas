%let complib=%str(/mnt/code/ISS/test/);
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