dataset <- read.csv("data.csv")
new_point <- read.csv("test.csv")


###Nearest neighbors
my_knn_regressor = function(x,y,k=3)
{
  if (!is.matrix(x))
  {
    x = as.matrix(x)
  }
  if (!is.matrix(y))
  {
    y = as.matrix(y)
  }
  my_knn = list()
  my_knn[['points']] = x
  my_knn[['value']] = y
  my_knn[['k']] = k
  attr(my_knn, "class") = "my_knn_regressor"
  return(my_knn)
}

compute_pairwise_distance=function(X,Y)
{
  xn = rowSums(X ** 2)
  yn = rowSums(Y ** 2)
  outer(xn, yn, '+') - 2 * tcrossprod(X, Y)
}

predict.my_knn_regressor = function(my_knn,x)
{
  if (!is.matrix(x))
  {
    x = as.matrix(x)
  }
  ##Compute pairwise distance
  dist_pair = compute_pairwise_distance(x,my_knn[['points']])

  dist_pair <- t(as.matrix(apply(dist_pair,1,order) <= my_knn[['k']]))
  my_knn[["value"]] <- as.matrix(as.numeric(as.factor(my_knn[['value']])))
  pred <- dist_pair %*% my_knn[["value"]]
  pred <- pred / as.numeric(my_knn["k"])
  for(i in 1:nrow(pred)){
    if(as.numeric(pred[i])-1 > 2-as.numeric(pred[i])){
      pred[i] = 'M'
    }else{
      pred[i] = 'B'
    }
  }
  total = 0
  for (i in 1:nrow(dataset)) {
    if(dataset[i,1] == pred[i]){
      total = total + 1
    }
  }
  print("Accuracy")
  print((total/nrow(dataset))*100)
}

knn_class = my_knn_regressor(dataset[2:31], dataset[1], k=5)
predict(knn_class, dataset[2:31])