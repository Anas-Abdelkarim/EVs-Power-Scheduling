# EV Power Scheduling
This text is providing instructions on how to run the code on the optimisation problem that appears in the paper "Using Convex Optimization to Schedule V2G EV Power Profiles with Conditional Minimum Energy Boundary." 

 
 
# Instructions to run the code
AMPL can be run in different ways please refer to the following repository for more details:
https://github.com/Anas-Abdelkarim/AMPL-Codes.

We present the run the code using NEOS server through the following steps:
1- navigate to CPLEX solver offered at NEOS server at the link:
https://neos-server.org/neos/solvers/socp:CPLEX/AMPL.html 
2- upload "model.mod"  file in the repository to the Model    File on the website by clicking "Choose File" which appears under "Model File    Enter the location of the AMPL model file (local file)"
3- upload "data.dat"   file in the repository to the Data     File on the website by clicking "Choose File" which appears under "Data File     Enter the location of the AMPL data file (local file)"
4- upload "solve.run"  file in the repository to the Commands File on the website by clicking "Choose File" which appears under "Commands File Enter the location of the AMPL commands file (local file)"
5- at "Additional settings" check the box for "Short Priority: submit to higher priority queue with maximum CPU time of 5 minutes"
6- at "Additional settings" enter the E-mail address in the box.
7- wait for the results to appear and you will receive an email with the results
8- process the data using your favourite tools such as Matlab, Python, and Excel, ...
