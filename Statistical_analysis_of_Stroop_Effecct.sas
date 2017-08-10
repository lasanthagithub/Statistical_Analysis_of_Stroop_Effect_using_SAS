%let drive = E;
%let path = &drive.:\OneDrive_gmail\OneDrive\Dropbox_transfers\Udacity\Nano_Degree_Data_analysis\Project_8_Statistics\Stroop_effect_project;
libname stroop "&path.";

ods graphics on /reset = all; /* width = 5.9 in height = 8 in  border=off  
        imagename = "All_OP_water_dist_1" imagefmt= png  ANTIALIASMAX=102900; */
*ods pdf style = mystyle1 file = "&path\Stroop_effect_Analysis.pdf" dpi=300;
ods escapechar='^';
options nodate;

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


proc template;
   delete mystyle_text;
   delete styles.mystyle1;
run;



options orientation = portrait; 
ods graphics on /reset = all;
*ods pdf close;
ods html close;
