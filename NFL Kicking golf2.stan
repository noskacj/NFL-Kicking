data {
  int<lower=0> N; // Number of obs
  int n_player;
  real dist[N]; // Distance
  
  int att[N];
  int made[N];
  // matrix[n_player, N] made; // Number of kicks made at a distance
  // matrix[n_player, N] att; // Number of kicks attempted at a distance
  
  // int made[n_player, N]; // Number of kicks made at a distance
  // int att[n_player, N]; // Number of kicks attempted at a distance
  
  int player[N]; // Player index
}
transformed data {
  vector[N] threshold_angle;
  
  for (n in 1:N){
    threshold_angle[n] = asin((6.1667) ./ dist[n]);
  }
}
parameters {
  real sigma_mu;
  real<lower=0> tau_sigma;
  real<lower=0> sigma[n_player];
}
model {
  // matrix[n_player, N] p;
  vector[N] p;
  // p = 2 * Phi(threshold_angle ./ sigma[player]) - 1;
  // for (pl in 1:n_player){
  //   p[pl] = (2 * Phi(threshold_angle ./ sigma[pl]) - 1)';
  // }
  
  for (n in 1:N){
    p[n] = 2 * Phi(threshold_angle[n] / sigma[player[n]]) - 1;
  }
  
  tau_sigma ~ normal(0, 10);
  sigma ~ normal(sigma_mu, tau_sigma);
  
  // for (pl in 1:n_player){
  //   for (d in 1:N){
  //     made[pl, d] ~ binomial(att[pl, d], p[pl, d]);
  //   }
    // made[pl]' ~ binomial(att[pl]', p[pl]');
  // } 
  
  made ~ binomial(att, p);
  
}
generated quantities {
  // int made_hat[N];
  vector[n_player] sigma_degrees;
  
  for (n in 1:n_player){
    sigma_degrees[n] = sigma[n] * 180 / pi();
  }
  
  // vector[N] p = 2 * Phi(threshold_angle / sigma) - 1;
  // 
  // for (n in 1:N){
  //   made_hat[n] = binomial_rng(att[n], p[n]);
  // }
}
