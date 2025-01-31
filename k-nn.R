##Machine Learning k-nearest neighbor
##exploratory data analysis of training data
ziptrain <- read.table("zip.train.csv", sep = ",");
ziptrain56 <- subset(ziptrain, ziptrain[,1]==5 | ziptrain[,1]==6);

dim(ziptrain56); ## 1220 257
sum(ziptrain56[,1] == 5); ##cheking whether the values in the first column of the matrix are equal to 5
sum(ziptrain56[,1] == 6); 
summary(ziptrain56);
summary(ziptrain56[,1])
cor_matrix <- cor(ziptrain56[,-1])

rowindex = 22; ## You can try other "rowindex" values to see other rows
ziptrain56[rowindex,1];
Xval = t(matrix(data.matrix(ziptrain56[,-1])[rowindex,],byrow=TRUE,16,16)[16:1,]);
image(Xval,col=gray(0:1),axes=FALSE) ## Also try "col=gray(0:32/32)"
image(Xval, col=gray(0:32/32),axes=FALSE)

### 2. Build Classification Rules
### linear Regression
mod1 <- lm( V1 ~ . , data= ziptrain56);
pred1.train <- predict.lm(mod1, ziptrain56[,-1]);
y1pred.train <- 5 + (pred1.train >= 5.5);
## Note that we predict Y1 to $5$ and $6$,
## depending on the indicator variable whether pred1.train >= 5.5 = (5+6)/2.
mean( y1pred.train != ziptrain56[,1]);

## KNN
library(class);
kk <- 15; ##KNN with k=3
xnew <- ziptrain56[,-1];
ypred2.train <- knn(ziptrain56[,-1], xnew, ziptrain56[,1], k=kk);
mean( ypred2.train != ziptrain56[,1])

###error graph
kk <- c(1, 3, 5, 7, 9, 11, 13, 15)

##The cross-validation error for this specific round for different k
cverror <- NULL;
for (i in 1:length(kk)){
  xnew <- ziptrain56[,-1];
  ypred.test <- knn(ziptrain56[,-1], xnew, ziptrain56[,1], k = kk[i]);
  temptesterror <- mean(ypred.test  != ziptrain56[,1]);
  cverror <- c(cverror, temptesterror); 
}


## This shows that KNN with k=1,3,5 
## yield the smallest CV error 
##  for this specific split 
plot(kk, cverror, xaxt = "n", xlab = "k values", ylab = "Cross-validation Error for Training Data")
axis(side = 1, at = c(1, 3, 5, 7, 9, 11, 13, 15))

###Testing error
### 3. Testing Error
### read testing data
ziptest <- read.table(file="/Users/patalee/Desktop/GT_Analytics/Spring_2024/ISYE7406/Module1/r_codes/zip.test.csv", sep = ",");
ziptest56 <- subset(ziptest, ziptest[,1]==5 | ziptest[,1]==6);
dim(ziptest56) ##330 257
## Testing error of KNN, and you can change the k values.
xnew2 <- ziptest56[,-1]; ## xnew2 is the X variables of the "testing" data
kk <- 15; ## below we use the training data "ziptrain56" to predict xnew2 via KNN
ypred2.test <- knn(ziptrain56[,-1], xnew2, ziptrain56[,1], k=kk);
mean( ypred2.test != ziptest56[,1]) ## Here "ziptest56[,1]" is the Y response of the "testing" data


###error for linear regression
mod1 <- lm( V1 ~ . , data= ziptest56);
pred1.test <- predict.lm(mod1, ziptest56[,-1]);
y1pred.test <- 5 + (pred1.test >= 5.5);
## Note that we predict Y1 to $5$ and $6$,
## depending on the indicator variable whether pred1.train >= 5.5 = (5+6)/2.
mean( y1pred.test != ziptest56[,1]);


##The cross-validation error for this specific round for different k
kk <- c(1, 3, 5, 7, 9, 11, 13, 15)

## The cross-validation error for this specific round for different k
cverror <- NULL
for (i in 1:length(kk)) {
  xnew2 <- ziptest56[, -1]
  ypred.test <- knn(ziptest56[, -1], xnew2, ziptest56[, 1], k = kk[i])
  temptesterror <- mean(ypred.test != ziptest56[, 1])
  cverror <- c(cverror, temptesterror) 
}

## This shows that KNN with k=1,3,5
## yield the smallest CV error 
## for this specific split 
plot(kk, cverror, xaxt = "n", xlab = "k values", ylab = "Cross-validation Error for Testing Data")
axis(side = 1, at = c(1, 3, 5, 7, 9, 11, 13, 15))


### 4. Cross-Validation
### The following R code might be useful, but you need to modify it.

###############################################
zip56full <- rbind(ziptrain56, ziptest56)  # Combine to a full dataset
n1 <- dim(ziptrain56)[1]  # Training set sample size
n2 <- dim(ziptest56)[1]   # Testing set sample size
n <- dim(zip56full)[1]     # Total sample size
set.seed(7406)  # Set randomization seed

# Initialize the TE values for all models in all B=100 loops
B <- 100  # Number of loops
TEALL <- NULL  # Final TE values

# Multiple round cross-validation
for (b in 1:B) {
  # Randomly select n1 observations as a new training subset in each loop
  flag <- sort(sample(1:n, n1))
  zip56traintemp <- zip56full[flag,]  # Temp training set for CV
  zip56testtemp <- zip56full[-flag,]  # Temp testing set for CV
  
  # Inside the loop, repeat the previous analysis of KNN for each k
  cverror <- NULL
  kk <- c(1, 3, 5, 7, 9, 11, 13, 15)
  for (i in 1:length(kk)) {
    xnew <- zip56testtemp[, -1]
    ypred.test <- knn(zip56traintemp[, -1], xnew, zip56traintemp[, 1], k = kk[i])
    temptesterror <- mean(ypred.test != zip56testtemp[, 1])
    cverror <- c(cverror, temptesterror)
  }
  TEALL <- rbind(TEALL, cverror)
  
}

# Plotting
plot(kk, apply(TEALL, 2, mean), ylab = 'CV Error', xlab = 'k values', main = 'Cross-Validation Error for Different k')

####regression method 
mod1 <- lm( V1 ~ . , data= zip56traintemp);
pred1.train <- predict.lm(mod1, zip56traintemp[,-1]);
y1pred.train <- 5 + (pred1.train >= 5.5);
## Note that we predict Y1 to $5$ and $6$,
## depending on the indicator variable whether pred1.train >= 5.5 = (5+6)/2.
mean( y1pred.train != zip56traintemp[,1]);

###error for linear regression
mod1 <- lm( V1 ~ . , data= zip56traintemp);
pred1.test <- predict.lm(mod1, zip56traintemp[,-1]);
y1pred.test <- 5 + (pred1.test >= 5.5);
## Note that we predict Y1 to $5$ and $6$,
## depending on the indicator variable whether pred1.train >= 5.5 = (5+6)/2.
mean( y1pred.test != zip56traintemp[,1]);



##############Testing 
zip56full <- rbind(ziptrain56, ziptest56)  # Combine to a full dataset
n1 <- dim(ziptrain56)[1]  # Training set sample size
n2 <- dim(ziptest56)[1]   # Testing set sample size
n <- dim(zip56full)[1]     # Total sample size
set.seed(7406)  # Set randomization seed

# Initialize the TE values for all models in all B=100 loops
B <- 100  # Number of loops
TEALL <- NULL  # Final TE values

# Multiple round cross-validation
for (b in 1:B) {
  # Randomly select n1 observations as a new training subset in each loop
  flag <- sort(sample(1:n, n1))
  zip56traintemp <- zip56full[flag,]  # Temp training set for CV
  zip56testtemp <- zip56full[-flag,]  # Temp testing set for CV
  
  # Inside the loop, repeat the previous analysis of KNN for each k
  cverror <- NULL
  kk <- c(1, 3, 5, 7, 9, 11, 13, 15)
  for (i in 1:length(kk)) {
    xnew <- zip56testtemp[, -1]
    ypred.test <- knn(zip56traintemp[, -1], xnew, zip56traintemp[, 1], k = kk[i])
    temptesterror <- mean(ypred.test != zip56testtemp[, 1])
    cverror <- c(cverror, temptesterror)
  }
  TEALL <- rbind(TEALL, cverror)
  
}

# Calculate the mean error for each k across all iterations
mean_error <- apply(TEALL, 2, mean)

# Print the mean error values for each k
print(mean_error)

# Plotting
plot(kk, mean_error, ylab = 'Mean CV Error', xlab = 'k values', main = 'Mean of the Testing Error for Different k')
axis(side = 1, at = c(1, 3, 5, 7, 9, 11, 13, 15))

variance <-apply(TEALL,2,var)
print(variance)
plot(kk, variance, ylab = 'Mean Variance Error', xlab = 'k values', main = 'Sample Variance for Testing Errors for Different k')
axis(side = 1, at = c(1, 3, 5, 7, 9, 11, 13, 15))


#####Final code 

zip56full <- rbind(ziptrain56, ziptest56)  # Combine to a full dataset
n1 <- dim(ziptrain56)[1]  # Training set sample size
n2 <- dim(ziptest56)[1]   # Testing set sample size
n <- dim(zip56full)[1]     # Total sample size
set.seed(7406)  # Set randomization seed

# Initialize the TE values for all models in all B=100 loops
B <- 100  # Number of loops
TEALL <- NULL  # Final TE values

# Multiple round cross-validation
for (b in 1:B) {
  # Randomly select n1 observations as a new training subset in each loop
  flag <- sort(sample(1:n, n1))
  zip56traintemp <- zip56full[flag,]  # Temp training set for CV
  zip56testtemp <- zip56full[-flag,]  # Temp testing set for CV
  
  # Inside the loop, repeat the previous analysis of KNN for each k
  cverror <- NULL
  kk <- c(1, 3, 5, 7, 9, 11, 13, 15)
  for (i in 1:length(kk)) {
    xnew <- zip56testtemp[, -1]
    ypred.test <- knn(zip56traintemp[, -1], xnew, zip56traintemp[, 1], k = kk[i])
    temptesterror <- mean(ypred.test != zip56testtemp[, 1])
    cverror <- c(cverror, temptesterror)
  }
  TEALL <- rbind(TEALL, cverror)
}

# Assign column names
colnames(TEALL) <- c("linearRegression", "KNN1", "KNN3", "KNN5", "KNN7", "KNN9", "KNN11", "KNN13", "KNN15")

# Plotting for KNN
plot(kk, apply(TEALL, 2, mean), ylab = 'CV Error', xlab = 'k values', main = 'Cross-Validation Error for Different k')

# Regression method
mod1 <- lm(V1 ~ . , data = zip56traintemp)
pred1.train <- predict.lm(mod1, zip56traintemp[, -1])
y1pred.train <- 5 + (pred1.train >= 5.5)
error_regression <- mean(y1pred.train != zip56traintemp[, 1])

# Print the mean error for regression method
cat("Mean Error for Regression Method:", error_regression, "\n")

# Report the sample mean/variances of the testing errors
mean_errors <- apply(TEALL, 2, mean)
var_errors <- apply(TEALL, 2, var)

cat("Sample Mean of Testing Errors:\n")
print(mean_errors)

cat("Sample Variance of Testing Errors:\n")
print(var_errors)

