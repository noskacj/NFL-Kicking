data {
  int<lower=0> N; // Number of distances
  real dist[N]; // Distance
  int made[N]; // Number of kicks made at a distance
  int att[N]; // Number of kicks attempted at a distance
  // int player[N]; // Player index
}
transformed data {
  vector[N] threshold_angle;
  
  for (n in 1:N){
    threshold_angle[n] = asin((6.1667) ./ dist[n]);
  }
}
parameters {
  real<lower=0> sigma;
}
model {
  vector[N] p = 2 * Phi(threshold_angle / sigma) - 1;
  
  made ~ binomial(att, p);
}
generated quantities {
  int made_hat[N];
  real sigma_degrees = sigma * 180 / pi();
  vector[N] p = 2 * Phi(threshold_angle / sigma) - 1;
  
  for (n in 1:N){
    made_hat[n] = binomial_rng(att[n], p[n]);
  }
}
