%let drive = E;
%let path = &drive.:\OneDrive_gmail\OneDrive\Dropbox_transfers\Udacity\Nano_Degree_Data_analysis\Project_8_Statistics\Stroop_effect_project;
libname stroop "&path.";

ods graphics on /reset = all; /* width = 5.9 in height = 8 in  border=off  
        imagename = "All_OP_water_dist_1" imagefmt= png  ANTIALIASMAX=102900; */
*ods pdf style = mystyle1 file = "&path\Stroop_effect_Analysis.pdf" dpi=300;
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


ods html style = mystyle1 style = mystyle_text path = "&path" gpath = "&path"  
        file = "Stroop_effect_Analysis.htm" dpi=300;

Title "Statistical Analysis of Stroop Effect";

ods text = 
"The Stroop effect is a demonstration of the phenomenon that the brain's reaction 
time slows down when it has to deal with conflicting information. This slowed 
reaction time happens because of interference, or a processing delay caused by 
competing or incompatible functions in the brain. The effect became widely known 
after John Ridley Stroop, an American psychologist, published a paper on it in 
1935, but it had been studied by several other researchers before Stroop.
[referene]
In a Stroop task, participants are presented with a list of words, with each 
word displayed in a color of ink. The participant’s task is to say out loud the
color of the ink in which the word is printed. The task has two conditions: 
a congruent words condition, and an incongruent words condition. In the 
congruent words condition, the words being displayed are color words whose 
names match the colors in which they are printed: for example RED, BLUE. 
In the incongruent words condition, the words displayed are color words 
whose names do not match the colors in which they are printed. 
";

ods text = "                                                           ";
title;

proc odstext;
	p 'The following word is styled; ^{style[color=purple fontweight=bold]HERE}^{newline 2}';
	p 'You can ^{style[textdecoration=underline]also} format your text.' / style=[color=red];
run;



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


ods text = "The distribution of variables in the Stroop effect dataset 
are shown in the following histograms and the density plots.  ";

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


proc template;
   delete mystyle_text;
   delete styles.mystyle1;
run;



options orientation = portrait; 
ods graphics on /reset = all;
*ods pdf close;
ods html close;


ods text = 'time takig to congruent is greater than incongruent test.

independand variable';
