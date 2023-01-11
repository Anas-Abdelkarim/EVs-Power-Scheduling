##########################################################
#                    بسم الله الرحمن الرحيم                       
#This is a program is written in AMPL to descibe the opt- 
#imzation appeared  in equation  18 of paper:            
#Using Convex Optimization to Schedule V2G EV Power Profi-
#les with Conditional Minimum Energy Boundary
#Date         : 10/1/2023                      
#Version      : v1.0                           
#Written by   : Anas Abdelkarim               
#File name    : Model	                      
##########################################################



############### parameters ###################### 
param N ; # horizon length
param Ts ; # sampling time
param num_EV ; # number of EV

# the maximum battery energy
param E_max_1;
param E_max_2;
param E_max_3;

# the minimum battery energy
param E_min_1;
param E_min_2;
param E_min_3;

# connect instant of EVs
param k_c_1;
param k_c_2;
param k_c_3;


# the initial battery energy
param E_0_1;
param E_0_2;
param E_0_3;

# disconnectinstant of EVs
param k_d_1;  
param k_d_2;  
param k_d_3; 
 
# the target battery energy
param E_t_1;
param E_t_2;
param E_t_3;

# the maximum discharging power of EV
param p_dis_max_1;
param p_dis_max_2;
param p_dis_max_3; 

# the maximum charging power of EV
param p_ch_max_1;
param p_ch_max_2;
param p_ch_max_3;

# we define the set K_u here because we need it for P_load and P_grid
set K_u := 0..N-1 ; # the set of control instants

param P_load {i in K_u}  >=0;
param P_PV {i in K_u}  <= 0;

param E_R1_max_1 := E_min_1 - E_0_1; # see equation 11 in the paper
param E_R2_max_1 := E_max_1 - E_min_1; # see equation 11 in the paper
param k_m_1 := k_c_1 + floor(E_R1_max_1/p_ch_max_1); # see equation 15

#################################################



###################  sets  ###################### 
set K := 0..N ; # the set of sampling instants


# the set of time instants that EV is available for (dis)charging
set K_a_1 := k_c_1 .. k_d_1 - 1;
set K_a_2 := k_c_2 .. k_d_2 - 1;
set K_a_3 = k_c_3 .. k_d_3 - 1;


# the set of time instants that EV  is not connected to the grid
set K_n_1 = K diff {K_a_1 union {k_d_1}};
set K_n_2 = K diff {K_a_2 union {k_d_2}};
set K_n_3 = K diff {K_a_3 union {k_d_3}};

set mu_EV := 1..num_EV ;  # the set of indices of EVs
set mu_0 := {3}; # the set of indices of EVs that will not participate in V2G
set mu_l := {1}; # the set of indices of EVs that will participate in V2G and E_0 >= E_min
set mu_h := {2}; # the set of indices of EVs that will participate in V2G and E_0 < E_min 
#################################################



 

###################  control variables ###################### 
var P_grid {k in K_u} <= 0; # the planned imported power vector

var P_1 {k in K_u}; # the power vector for EV 1
var P_2 {k in K_u}; # the power vector for EV 2
var P_3 {k in K_u}; # the power vector for EV 3

var E_1{k in K}  >= 0; # the battery energy vector for EV 1
var E_2{k in K}  >= 0; # the battery energy vector for EV 2
var E_3{k in K}  >= 0; # the battery energy vector for EV 3


var E_R1_1 {k in k_c_1 .. k_d_1} >= 0; # the energy of R1 of EV 1
var E_R2_1 {k in k_c_1 .. k_d_1} >= 0; # the energy of R2 of EV 1

var P_ch_R1_1 {k in k_c_1 .. k_d_1 -1}  ; # the charging power of R1 of EV 1
var P_ch_R2_1 {k in k_c_1 .. k_d_1 - 1} ; # the charging power of R2 of EV 1
var P_dis_R2_1 {k in k_c_1 .. k_d_1 - 1}; # the discharging power of R2 of EV 1


#################################################






###################  cost function ###################### 
minimize cost_function_AT_eq_2 : sum {k in K_u} P_grid[k]**2;
#################################################








###################  constraints ###################### 

# equation 1 in the paper
subject to eq_1 {k in K_u} : P_grid[k] + P_1[k] + P_2[k] + P_3[k] + P_PV[k] + P_load[k] = 0 ; 

# equation 3 in the paper
subject to eq_3_a_1 : E_1[k_c_1] = E_0_1; 
subject to eq_3_a_2 : E_2[k_c_2] = E_0_2;
subject to eq_3_a_3 : E_3[k_c_3] = E_0_3;

subject to eq_3_b_1 : E_1[k_d_1] >= E_t_1; 
subject to eq_3_b_2 : E_2[k_d_2] >= E_t_2;
subject to eq_3_b_3 : E_3[k_d_3] >= E_t_3;


# equation 4 in the paper
subject to eq_4_a_2 {k in K_a_2} : E_2[k+1] =  E_2[k]   + Ts *P_2[k];
subject to eq_4_a_3 {k in K_a_3} : E_3[k+1] =  E_3[k]   + Ts *P_3[k];

subject to eq_4_b_1{k in K_a_1} : E_1[k+1] <=  E_max_1;
subject to eq_4_b_2{k in K_a_2} : E_2[k+1] <=  E_max_2;
subject to eq_4_b_3{k in K_a_3} : E_3[k+1] <=  E_max_3;

subject to eq_4_c{k in K_a_2} : E_2[k+1] >=  E_min_2;

subject to eq_4_d_1{k in K_n_1} : E_1[k] =  0;
subject to eq_4_d_2{k in K_n_2} : E_2[k] =  0;
subject to eq_4_d_3{k in K_n_3} : E_3[k] =  0;


# equation 5 in the paper
subject to eq_5_a_2 {k in K_a_2} : P_2[k] <=  p_ch_max_2;
subject to eq_5_a_3 {k in K_a_3} : P_3[k] <=  p_ch_max_3;

subject to eq_5_b_2 {k in K_a_2} : P_2[k] >=  p_dis_max_2;
subject to eq_5_b_3 {k in K_a_3} : P_3[k] >=  p_dis_max_3;
 
subject to eq_5_c_1 {k in K_u diff K_a_1} : P_1[k] =  0;
subject to eq_5_c_2 {k in K_u diff K_a_2} : P_2[k] =  0;
subject to eq_5_c_3 {k in K_u diff K_a_3} : P_3[k] =  0;




# equation 12 in the paper
subject to eq_12_a {k in K_a_1} : P_1[k] =  P_ch_R1_1[k] + P_ch_R2_1[k] + P_dis_R2_1[k];

subject to eq_12_b_1 {k in K_a_1} : P_ch_R1_1[k] >=  0;
subject to eq_12_b_2 {k in K_a_1} : P_ch_R2_1[k] >=  0;
subject to eq_12_b_3 {k in K_a_1} : P_dis_R2_1[k] <=  0;

subject to eq_12_c {k in K_a_1} : P_ch_R1_1[k] +  P_ch_R2_1[k]  <= p_ch_max_1
;
subject to eq_12_d {k in K_a_1} : P_dis_R2_1[k]  >= p_dis_max_1;




# equation 13 in the paper
subject to eq_13_a_1 : E_R1_1[k_c_1] = 0; 
subject to eq_13_a_2 : E_R2_1[k_c_1] = 0;
subject to eq_13_a_3 : E_R1_1[k_d_1] =  E_R1_max_1;


subject to eq_13_b {k in K_a_1} : E_R1_1[k+1] =  E_R1_1[k]   + Ts *P_ch_R1_1[k];

subject to eq_13_c {k in K_a_1} : E_R2_1[k+1] =  E_R2_1[k]   + Ts *(P_ch_R2_1[k] + P_dis_R2_1[k]);

subject to eq_13_d {k in K_a_1} : E_1[k+1] =  E_0_1 + E_R1_1[k+1] + E_R2_1[k+1];

subject to eq_13_e {k in K_a_1} : E_R2_1[k+1] >=  0;

subject to eq_13_f {k in K_a_1} : E_R1_1[k+1] <=  E_R1_max_1;

# equation 14 in the paper
subject to eq_14 {k in K_a_1} : E_R1_1[k+1]/E_R1_max_1 >=   E_R2_1[k+1]/E_R2_max_1;


# equation 16 in the paper
subject to eq_16_a_1 {k in k_c_1 .. k_m_1 -1} : P_ch_R2_1[k] =  0;
subject to eq_16_a_2 {k in k_c_1 .. k_m_1 -1} : P_dis_R2_1[k] =  0;

subject to eq_16_b {k in k_c_1 .. k_m_1 -1} : P_ch_R1_1[k] >=  0;


# equation 17 in the paper
subject to eq_17_a {k in k_m_1 .. k_d_1 -1} : P_ch_R1_1[k] <=  (1- E_R2_1[k]/E_R2_max_1)*p_ch_max_1;


subject to eq_17_b_1 {k in k_m_1 .. k_d_1 -1} : P_ch_R2_1[k] <=  E_R1_1[k]/E_R1_max_1*p_ch_max_1;

subject to eq_17_c_1 {k in k_m_1 .. k_d_1 -1} : P_dis_R2_1[k] >=  E_R1_1[k]/E_R1_max_1*p_dis_max_1;
#################################################
