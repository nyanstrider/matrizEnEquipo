# Load necessary libraries
library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)

# Load dataset
data <- read_csv("INEGI_Manzanas_Sheyra.csv")  # Adjust path if needed

# Prepare data for plotting
population_data <- data.frame(
  Age_Group = c("0-14", "15-29", "30-59", "60+"),
  Male = -c(data$POB0_14[1], data$P15A29A[1], data$P30A59A[1], data$P_60YMAS[1]), # Negative for left alignment
  Female = c(data$POB0_14[1], data$P15A29A[1], data$P30A59A[1], data$P_60YMAS[1])
)

# Convert to long format
population_long <- population_data %>%
  pivot_longer(cols = c(Male, Female), names_to = "Gender", values_to = "Population")

# Plot pyramid
ggplot(population_long, aes(x = Age_Group, y = Population, fill = Gender)) +
  geom_bar(stat = "identity", width = 0.8) +
  scale_y_continuous(labels = function(x) abs(x), breaks = seq(-max(abs(population_long$Population)), 
                                                               max(abs(population_long$Population)), by = 5000)) +
  coord_flip() +
  labs(title = "Pirámide de población",
       x = "Grupo de edad",
       y = "Población",
       fill = "Género") +
  scale_fill_manual(values = c("Male" = "blue", "Female" = "pink"),
                    labels = c("Hombres", "Mujeres")) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16))
