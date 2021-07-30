# -------------------------------------------- #
# Supplementary materials
# 
# A closer look at fixed-effects regression in 
# structural equation modeling using lavaan
# 
# Generate data for examples 
# 
# Henrik Kenneth Andersen 
# -------------------------------------------- #

rm(list = ls())

# ----- Packages 

library(reshape2)


# ----- Generate data function 

gen_data <- function(n, waves, d_m, d_sd, a1_m, a1_sd, z_m, z_sd, e_m, e_sd, byx, bxa1, bxz, bya1, byz) {
  n <<- n
  waves <<- waves
  
  # Generate unit IDs
  id <- seq_along(1:n)
  id <- rep(id, each = waves)
  
  # Generate time IDs
  t <- seq_along(1:waves)
  t <- rep(t, times = n)
  
  # Pack them into long-format dataframe
  df <- data.frame(id, t)
  head(df, n = waves*3)
  
  # a1, a unit-specific, time-invariant variable
  # Save (N x 1) initial vector separately for use later 
  a1 <- rnorm(n, mean = a1_m, sd = a1_sd)
  # Repeat for each wave
  df$a1l <- rep(a1, each = waves)
  
  # Same for a2, another unit-specific time-invariant variable
  z <- rnorm(n, mean = z_m, sd = z_sd)
  df$zl <- rep(z, each = waves)
  
  # Unique variance of x 
  d <- rnorm(n*t, mean = d_m, sd = d_sd)
  
  # Equation for x 
  # Cause x to be correlated with a1 and a2
  df$x <- d + bxa1*df$a1l + bxz*df$zl 
  
  # The error of the dependent variable
  e <- rnorm(n*t, mean = e_m, sd = e_sd)
  
  # Equation for y 
  df$y <- byx*df$x + bya1*df$a1l + byz*df$zl + e   
  
  # Cast long-format data to wide-format
  dfw_x <- dcast(df, id ~ t, value.var = "x")
  dfw_y <- dcast(df, id ~ t, value.var = "y")
  
  # New wide dataframe
  dfw <- data.frame(dfw_x[ , 1],
                    a1,  
                    z,
                    dfw_x[ , 2:( waves + 1)],
                    dfw_y[ , 2:( waves + 1)])
  
  # Rename columns of wide dataframe 
  names(dfw) <- c("id", 
                  "a1", "z",
                  paste0(rep("x", waves), 
                         seq(1, waves, 1)),
                  paste0(rep("y", waves), 
                         seq(1, waves, 1)))
  
  # Function returns both long- and wide-format data 
  return(list( df, dfw))
}

# Run function to generate data 
data_sets <- gen_data(n = 1000, waves = 5, 
                      d_m = 3, d_sd = 2, 
                      a1_m = 2, a1_sd = 1, 
                      z_m = 1.5, z_sd = 3,
                      e_m = 3, e_sd = 1,
                      byx = 0.30, 
                      bxa1 = 0.85, bxz = 0.5,
                      bya1 = 0.75, byz = 0.45)

# Generate separate long- and wide-format dataframes as objects 
df <- data_sets[[1]]
dfw <- data_sets[[2]]

head(df)
head(dfw)

# ----- Add measurement error 

# Number of indicators 
k <- 3

# Create empty column vectors 
meas_err <- list(mode = "vector", length = k*2) 

# Fill each column with rnorm data, with random variance ranging from 1-1.5
for(i in 1:(k*2)){
  meas_err[[i]] <- rnorm(n = n*waves, 
                         mean = 0, 
                         sd = sample(x = seq(1, 1.5, 0.1), 
                                     size = 1, 
                                     replace = TRUE))
}

# Turn the columns of measurement error into dataframe
meas_err <- as.data.frame(meas_err)

# Rename columns
names(meas_err) <- c("u1", "u2", "u3",
                     "v1", "v2", "v3")

# Identify columns of original data to add error to
inds <- c("x1", "x2", "x3", 
          "y1", "y2", "y3")
df[, inds] <- NA

# Add error to the original data
df$x1 <- df$x + meas_err$u1
df$x2 <- df$x + meas_err$u2
df$x3 <- df$x + meas_err$u3
df$y1 <- df$y + meas_err$v1
df$y2 <- df$y + meas_err$v2
df$y3 <- df$y + meas_err$v3

# Transform to wide-format
dfw_x1 <- dcast(df, id ~ t, value.var = "x1")
dfw_x2 <- dcast(df, id ~ t, value.var = "x2")
dfw_x3 <- dcast(df, id ~ t, value.var = "x3")
dfw_y1 <- dcast(df, id ~ t, value.var = "y1")
dfw_y2 <- dcast(df, id ~ t, value.var = "y2")
dfw_y3 <- dcast(df, id ~ t, value.var = "y3")

# Clean up the resulting wide data
meas_err_cols <- data.frame(dfw_x1[, 2:(waves + 1)], dfw_x2[, 2:(waves + 1)], dfw_x3[, 2:(waves + 1)], 
                            dfw_y1[, 2:(waves + 1)], dfw_y2[, 2:(waves + 1)], dfw_y3[, 2:(waves + 1)])

# Bind measurement error-sullied columns to original dataframe
dfw <- cbind(dfw, meas_err_cols)

# Rename columns
names(dfw) <- c("id", 
                "a1", "z",
                paste0(rep("x", waves),
                       seq(1, waves, 1)),
                paste0(rep("y", waves),
                       seq(1, waves, 1)),
                paste0(rep("x", waves*k), 
                       rep(seq(from = 1, to = 3, by = 1), each = waves), 
                       rep(seq(from = 1, to = waves, by = 1), k)),
                paste0(rep("y", waves*k), 
                       rep(seq(from = 1, to = 3, by = 1), each = waves), 
                       rep(seq(from = 1, to = waves, by = 1), k)))


# Save the resulting dataframes 
saveRDS(df, file = "longData.Rda")
saveRDS(dfw, file = "wideData.Rda")

saveRDS(n, "n.Rda")
saveRDS(waves, "waves.Rda")
