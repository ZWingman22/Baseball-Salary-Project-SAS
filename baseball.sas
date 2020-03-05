proc contents data=sashelp.baseball;run;



proc sort data=sashelp.baseball out=sortb;
by Salary;
run;

proc print data=sortb;
run;


/* remove all non numeric predictors */
data newdata;
set sortb (drop=Div Division League Name Position Team logSalary);
run;

proc print data=newdata;
run;


/* without all the blank salaries*/

data newdata2;
set newdata (where=(Salary ne .));
run;

proc print data=newdata2;
run;


/* print correlation matrix */


PROC CORR Data=newdata2 plot (maxpoints=20000)=matrix;
run;


/* The Variables that seem to be the best predictors for salary are 
Career RBIs, Career Runs, Career Hits, Career At Bats, Career Walks, 1986 RBI, 
1986 Walks, and 1986 Hits  */


/* model with all predictors */

proc reg data=newdata2;
model Salary=nAtbat nHits nHome nRuns nRBI nBB YrMajor CrAtBat CrHits CrHome CrRuns CrRbi CrBB nOuts nAssts nError/AIC P ALL;
run;



/* model with forward stepwise selction */
proc reg data=newdata2;
model Salary=nAtbat nHits nHome nRuns nRBI nBB YrMajor CrAtBat CrHits CrHome CrRuns CrRbi CrBB nOuts nAssts nError/selection=forward;
run;

/*Comparing this to my prediction Career Hits, and 1986 RBI did not make the list but 1986 At Bats, 1986 Outs, 1986 runs, and 1986 Assists made the list.
If you look at the list it shows the ones over F value of .5 significance but some p values are over .05 chance level
1986 Assists, 1986 Runs, Career Runs should not be on the list.
The 3 best are Career RBIs, 1986 Hits, 1986 Walks
People under $600,000 salary for the most part have a really higher predicted value than their salary (underpaid) and those that have an 
actual salary above $600,000 are actually above their predicted salary (overpaid)
*/


/* based on the forward stepwise the following 3 predictors are the best 3*/

proc reg data=newdata2;
model Salary=nHits nBB CrRbi/AIC P ALL;
run;

/* ran model of all 3 together and individually */

proc reg data=newdata2;
model Salary=CrRbi/AIC P ALL;
run;




proc reg data=newdata2;
model Salary=nHits/AIC P ALL;
run;



proc reg data=newdata2;
model Salary=nBB/AIC P ALL;
run;



/* This is backward stepwise */


proc reg data=newdata2;
model Salary=nAtbat nHits nHome nRuns nRBI nBB YrMajor CrAtBat CrHits CrHome CrRuns CrRbi CrBB nOuts nAssts nError/selection=backward;
run;



/*
Comparing this to my prediction Career Hits, and 1986 RBI did not make the list but, 1986 At Bats, 1986 Outs, made the list.
If you look at the list it shows the ones over F value of .1 significance and all p values are under .05 chance level
All of the ones on the list should be there
The 3 best are 1986 Hits, Career RBIs, 1986 walks
Still People under $600,000 salary for the most part have a 
really higher predicted value than their salary (underpaid) and those that have an 
actual salary above $600,000 are actually above their predicted salary (overpaid)
*/


/* Another kitchen sink model is best predictors squared */

data newdata3;
set newdata2;
p1nHits = nHits**2;
p2CrRbi = CrRbi**2;
p3nBB = nBB**2;
run;
proc print data=newdata3;
run;


/* this is model where the 3 best predictors squared */

proc reg data=newdata3;
model Salary=p1nHits p2CrRbi p3nBB/AIC P ALL;
run;



/* The best model here is the the best 3 predictors:

nHits
CrRbi
nBB

The best model is to just include the three best predictors against 
salary it has the highest F score way more than the original and the 
square method and has a higher R square than the square method as well.


Original
F=23.79
R Square=.6075
3 Best
F=104.18
R Square=.5468
3 Best Square
F=80.42
R Square=.4823


*/




