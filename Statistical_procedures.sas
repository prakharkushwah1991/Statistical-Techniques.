libname wd "/folders/myfolders";

/*Data Import*/
data WD.income (rename = (VAR1 = age VAR2 = work_class VAR3 = fnlwgt VAR4 = education VAR5 = education_num VAR6 = marital_status VAR7 = occupation 
	VAR8 = relationship VAR9 = race VAR10 = sex VAR11 = capital_gain VAR12 = capital_loss VAR13 = hours_per_week VAR14 = native_country VAR15 = gt50K_or_lte50K));
	infile 'folders/myfolders/adult.csv' delimiter = ',' MISSOVER DSD ;
	informat VAR1 best32. ;
	informat VAR2 $19. ;
	informat VAR3 best32. ;
	informat VAR4 $15. ;
	informat VAR5 best32. ;
	informat VAR6 $25. ;
	informat VAR7 $19. ;
	informat VAR8 $13. ;
	informat VAR9 $22. ;
	informat VAR10 $7. ;
	informat VAR11 best32. ;
	informat VAR12 best32. ;
	informat VAR13 best32. ;
	informat VAR14 $13. ;
	informat VAR15 $5. ;
	format VAR1 best12. ;
	format VAR2 $19. ;
	format VAR3 best12. ;
	format VAR4 $15. ;
	format VAR5 best12. ;
	format VAR6 $25. ;
	format VAR7 $19. ;
	format VAR8 $13. ;
	format VAR9 $22. ;
	format VAR10 $7. ;
	format VAR11 best12. ;
	format VAR12 best12. ;
	format VAR13 best12. ;
	format VAR14 $13. ;
	format VAR15 $5. ;
	input
		VAR1
		VAR2 $
		VAR3
		VAR4 $
		VAR5
		VAR6 $
		VAR7 $
		VAR8 $
		VAR9 $
		VAR10 $
		VAR11
		VAR12
		VAR13
		VAR14 $
		VAR15 $
;
run;

proc contents data = wd.income;
run;

/*Plotting data*/
proc gplot data = wd.income;
	plot hours_per_week * age;
run;

proc gplot data = wd.income;
	plot hours_per_week * age = sex;
run;

/*proc univariate*/
proc univariate data = wd.income normal plot;
run;

/*proc freq*/
proc freq data = wd.income;
	table education*gt50K_or_lte50K / list;
run;

/*proc corr*/
proc corr data = wd.income;
run;

proc corr data = wd.income;
	var capital_gain age;
run;

proc corr data = wd.income;
	var capital_gain age hours_per_week;
	with capital_loss;
run;

data wd.income;
	set wd.income;
	if age = . then delete;
run;

*A statistical hypothesis is an assumption about a population parameter. 
	This assumption may or may not be true. 
	Hypothesis testing refers to the formal procedures which is used for accepting or rejecting statistical hypotheses.
	Null hypothesis. The null hypothesis, denoted by H0
	Alternate hypothesis. denoted by Ha or H1;

/*/*ttest*/*/;
data V1 (rename = (i = ID));
	do i = 1 to 100;
		x1 = normal(786);
		x2 = rand('NORMAL', 68, 12);
		x3 = rand('NORMAL', 6, 2);
		if x1 >= 0 then x4 = 'a';
		else x4 = 'b';
		x5 = x2 + x3;  
	output;
	end;
run;

proc univariate data = work.V1 plots;
	var x2 x3;
	histogram x2 x3 / normal;
run;

proc summary data = work.V1;
	var x2 x3;
	output out = work.V1_summary;
run;

proc gplot data = work.V1;
	plot x3 * x2 = x4;
run;

/*one sample ttest*/
proc ttest data = work.V1; *h0=0;
	title 'One-sample T-test example';
	var x2;
run;

*explanation
	Standard error - SE = s / sqrt( n )
	Degrees of freedom - DF = n - 1
	t-statistic - t = (x_bar - mu) / SE, where x_bar is the observed sample mean, mu is hypothesised population mean and SE is the standard error of mean
	P-value is the probability of observing a sample statistic as extreme as the test statistic.
		the probability associated with the t-score, given the degrees of freedom computed above;

proc ttest data = work.V1 h0=68;
	title 'One-sample T-test example';
	var x2;
run;

proc ttest data = work.V1 h0=68 alpha=0.1;
	title 'One-sample T-test example';
	var x2;
run;

*sides = U, L or 2;

*one sample median test;
proc univariate data = wd.income loccount mu0 = 40;
  var age;
run;

/*paired ttest*/
proc ttest data = work.V1;
	title 'Paired-sample T-test example';
	paired x2*x5;
run;

/*two sample ttest*/
proc ttest data = work.V1;
	title 'Two-sample T-test example';
	class x4;
	var x2;
run;

*When the p-value 
	(shown under "Pr>F") is greater than 0.05, then the variances are equal then read the "Pooled" section of the result
    (shown under "Pr>F") is no more than 0.05, then the variances are unqueal then read the "Satterthwaite" section of the result 

/*/*Chi-square test*/*/;
*Chi-square goodness of fit;
proc freq data = wd.income;
 	tables race / chisq testp=(10 10 10 10 60);
run;

/*Chi-square test*/
proc freq data = wd.income;
 	tables gt50K_or_lte50K*sex / chisq;
run;

*Fisher's exact test;
proc freq data = wd.income;
 	tables gt50K_or_lte50K*sex / fisher;
run;


/*/*ANOVA*/*/;
*One-way ANOVA*;
proc anova data = wd.income;
	class race;
	model hours_per_week = race;
run;

proc anova data = wd.income;
	class race;
	model hours_per_week = race;
	means race / bon;
run;

*Two-way ANOVA;
proc anova data=wd.income;
	class race sex;
	model hours_per_week = race sex;
run;

proc glm data=wd.income;
	class race sex;
	model hours_per_week = race sex;
run;

