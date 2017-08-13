%let drive = E;
%let path = &drive.:\OneDrive_gmail\OneDrive\Dropbox_transfers\Udacity\Nano_Degree_Data_analysis\Project_8_Statistics\Stroop_effect_project;
libname stroop "&path.";



ods escapechar='^';
options nodate;
ODS NOPROCTITLE;

proc template ;
    define style styles.mystyle1; parent = styles.HTMLBlue;
        style GraphFonts /
            'GraphValueFont' = ("<MTserif>, Times New Roman", 8pt)
            'GraphLabelFont' = ("<MTserif>, Times New Roman", 10pt, bold)
            'GraphTitleFont' = ("<MTserif>, Times New Roman", 10pt, bold)
            'GraphDataFont' = ("<MTserif>, Times New Roman", 8pt)
            'NodeLabelFont' = ("<MTserif>, Times New Roman", 8pt)
            
            "GraphAnnoFont" = ("<MTserif>, Times New Roman", 8pt)
            "GraphUnicodeFont" = ("<MTserif>, Times New Roman", 8pt)
            "GraphLabel2Font" = ("<MTserif>, Times New Roman", 8pt)
            "GraphFootnoteFont" = ("<MTserif>, Times New Roman", 8pt)
            "GraphTitle1Font" = ("<MTserif>, Times New Roman", 8pt)
            "NodeTitleFont" = ("<MTserif>, Times New Roman", 8pt)
            "NodeInputLabelFont" = ("<MTserif>, Times New Roman", 8pt)
            "NodeDetailFont" = ("<MTserif>, Times New Roman", 8pt);

    end; 
run;

proc template;
   define style mystyle_text;
   parent = styles.htmlblue;
   style usertext from usertext /
      	foreground = black
		font = ("<MTserif>, Times New Roman", 12pt);

	style titlesandfooters /
      	foreground = black
      	background = colors("systitlebg")
      	font = ("<MTserif>, Times New Roman") 
		font_size=5;

   end;
run;

ods graphics on /reset = all /* width = 5.9 in height = 8 in  border=off  */
        imagename = "Stroop_effect_Analysis" imagefmt= png  ANTIALIASMAX=102900; 
ods pdf style = mystyle1 file = "&path\Stroop_effect_Analysis.pdf" dpi=300;
ods html style = mystyle1 style = mystyle_text path = "&path" gpath = "&path"  
        file = "Stroop_effect_Analysis.htm" dpi=300;


Title "Statistical Analysis of Stroop Effect";

* Get the data in;
filename fn "&path\stroopdata.csv";
proc import out = stroop.Stroop_data
			datafile=fn
			dbms=csv replace;
			getnames=yes; 
	datarow = 2;
	*guessingrows = 32767;
	guessingrows = MAX;
	*Mixed=Yes;
run;

title;

ods text = "Folowwing table shows the first 10 records of the dataset";

proc print data = stroop.Stroop_data (obs = 10) noobs;
run;

ods text = "Some descriptive statistics of the dataset are given below";

/*
proc summary data = stroop.Stroop_data print; 
	var Incongruent Congruent;
	output out=summrydat n=number mean=average std=std_deviation median;
run;
*/
proc means data = stroop.Stroop_data  
		n mean std median min max Q1 Q3 print MAXDEC = 3; 
	var Incongruent Congruent;
	output out=summrydat2 n=n mean=mean std=std 
		median=median min=min max=max Q1=Q1 Q3=Q3;
	
run;


* Generating Histograms and density plots;
proc sgplot data = stroop.Stroop_data;
	histogram Incongruent /binwidth = 1;
	density Incongruent / type=kernel;
run;


proc sgplot data = stroop.Stroop_data;
	histogram Congruent /binwidth = 1;
	density Congruent / type=kernel;
run;

* generate scatter a plot;
proc sgplot data = stroop.Stroop_data;
	scatter y = Congruent x = Incongruent;

run;


* Transpose data. Now two multiple columns (previously rows);
proc transpose data=stroop.Stroop_data out=raw_t;
run;

/* Transpose data. Now the the values in columns goes to onecolumn
but grouped by first column-record values*/
proc transpose data=raw_t out=raw_t1;
	by _NAME_;
run;



proc sgplot data=raw_t1;
	label col1 = "Time in seconds" _name_="Test Type";
	vbox col1 / group=_name_ ;
	xaxis discreteorder=data display=(nolabel);
	legend;
run;


/*
proc ttest data=raw_t1 alpha=0.05 h0=0 sides = l;
	class _name_;
	var col1;
run; 


proc ttest data=raw_t1 alpha=0.05;
	class _name_;
	var col1;
run; 
*/

/* Paired T -test is the most suitable forthis experiment*/
/*
proc ttest data=stroop.Stroop_data  alpha=0.05 h0=0;
	paired  Congruent * Incongruent;
run; 

proc ttest data=stroop.Stroop_data  alpha=0.05 h0=0 sides=l;
	paired  Congruent * Incongruent;
run; 
*/

proc template;
   delete mystyle_text;
   delete styles.mystyle1;
run;



options orientation = portrait; 
ods graphics on /reset = all;
ods pdf close;
ods html close;

