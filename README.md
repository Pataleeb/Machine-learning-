# Machine-learning-
(1)	In this exercise, we explore the well-known zipcode dataset refers to the U.S. Postal Service ZIP code dataset. In this exercise, we only consider Y=5 and Y=6.!
Exploratory statistics of the dataset:

The dimension of the dataset: ziptrain56 training dataset has 1220 rows and 257 columns.
The number of occurrences where the first column has a value equal to 5 in the dataset =556.
The number of occurrences where the first column has a value equal to 6 in the same dataset= 664

KNN with k=1,3,5,7,9,11,13,15

Table 2: Training error values with different neighbors

k	Training error values
1	0
3	0.004918033
5	0.005737705
7	0.006557377
9	0.007377049
11	0.009016393
13	0.01311475
15	0.01393443

(3). Testing errors

For the testing dataset, we have 330 data rows and 257 columns, first column being the response of Y variable. 

Table 3: Testing error values with different neighbor values

k	Testing error values
1	0.01818182
3	0.003030303
5	0.009090909
7	0.006060606
9	0.01212121
11	0.01212121
13	0.01212121
15	0.01212121

(4). Cross-validation:

For the linear regression method, the mean predicted error value=0.003278689
Table 4: Monte Carlo cross validation with 100 repetitions.

k	Testing error values 
1	0.010393939
3	0.008696970
5	0.009909091
7	0.011333333
9	0.012696970
11	0.014333333
13	0.015969697
15	0.016696970

Table 5: Sample Variance of Testing Errors 

k	Testing error values 
1	2.472011e-05
3	1.885800e-05
5	2.742856e-05
7	3.072414e-05
9	3.945701e-05
11	4.282587e-05
13	4.709260e-05
15	5.240560e-05

Considering the Monte Carlo cross-validation results presented in Table 4 and Table 5 (i.e., mean error value and error variance), 
it was observed that the optimal choice of k=3 neighbors for the tuning parameter in the KNN algorithm is recommended for classifying 5’s and 6’s in the dataset. 
In Figure 5, a drop in mean testing error value is evident at k=3. At k=3, the lowest recorded testing error value is observed, and beyond that point, the testing error increases again. 
The choice of k=3 suggests that a relatively small number of neighboring data points should be considered when making predictions. 
A smaller k value implies a more localized decision boundary, leading to a model that is sensitive to local patterns and variations in the zipcode data used in this analysis.



