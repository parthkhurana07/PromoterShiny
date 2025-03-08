install.packages("shiny")
install.packages("dplyr")
install.packages("ggplot2")

library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)

# Read data
data <- read.table("promoters.data", sep = ",", header = FALSE, strip.white = TRUE, stringsAsFactors = FALSE)
colnames(data) <- c("class", "name", "sequence")

# Split sequence and rename
data <- data %>%
  mutate(sequence = strsplit(sequence, "")) %>%
  unnest_wider(sequence, names_sep = "_") %>%
  select(class, name, paste0("sequence_", 1:57))
colnames(data)[3:59] <- paste("pos", 1:57, sep = "")

# Subset data
promoters <- data[data$class == "+", ]
non_promoters <- data[data$class == "-", ]
promoter_seqs <- promoters[, 3:59]
non_promoter_seqs <- non_promoters[, 3:59]

# UI
ui <- fluidPage(
  titlePanel("Promoter Gene Sequences Visualization"),
  tabsetPanel(
    tabPanel("Nucleotide Frequency Heatmap",
             fluidRow(
               column(6, h3("Promoter Sequences Heatmap"), plotOutput("promoterHeatmap")),
               column(6, h3("Non-Promoter Sequences Heatmap"), plotOutput("nonPromoterHeatmap"))
             )
    ),
    tabPanel("Position-wise Analysis",
             fluidRow(
               column(4, selectInput("position", "Select Position:", choices = 1:57)),
               column(8, h3("Nucleotide Frequencies at Selected Position"), plotOutput("positionPlot"))
             )
    )
  )
)

# Server
server <- function(input, output) {
  calc_freq_matrix <- function(seq_matrix) {
    freq_matrix <- matrix(0, nrow = 4, ncol = ncol(seq_matrix), 
                          dimnames = list(c("a", "g", "c", "t"), paste("pos", 1:57, sep = "")))
    for (pos in 1:ncol(seq_matrix)) {
      table <- table(seq_matrix[, pos])
      freq_matrix[names(table), pos] <- table / nrow(seq_matrix)
    }
    freq_matrix[is.na(freq_matrix)] <- 0
    as.data.frame(freq_matrix)
  }
  
  promoter_freq <- calc_freq_matrix(promoter_seqs)
  non_promoter_freq <- calc_freq_matrix(non_promoter_seqs)
  
  promoter_freq_long <- promoter_freq %>%
    mutate(Nucleotide = rownames(promoter_freq)) %>%
    tidyr::pivot_longer(cols = starts_with("pos"), names_to = "Position", values_to = "Frequency")
  non_promoter_freq_long <- non_promoter_freq %>%
    mutate(Nucleotide = rownames(non_promoter_freq)) %>%
    tidyr::pivot_longer(cols = starts_with("pos"), names_to = "Position", values_to = "Frequency")
  
  output$promoterHeatmap <- renderPlot({
    ggplot(promoter_freq_long, aes(x = Position, y = Nucleotide, fill = Frequency)) +
      geom_tile() +
      scale_fill_gradient(low = "white", high = "blue") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 8)) +
      labs(title = "Promoter Sequences")
  })
  
  output$nonPromoterHeatmap <- renderPlot({
    ggplot(non_promoter_freq_long, aes(x = Position, y = Nucleotide, fill = Frequency)) +
      geom_tile() +
      scale_fill_gradient(low = "white", high = "blue") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 8)) +
      labs(title = "Non-Promoter Sequences")
  })
  
  output$positionPlot <- renderPlot({
    pos <- as.integer(input$position)
    
    # Ensure character type
    promoter_nucleotides <- as.character(promoter_seqs[, pos])
    non_promoter_nucleotides <- as.character(non_promoter_seqs[, pos])
    
    # Create data frames
    promoter_df <- data.frame(nucleotide = promoter_nucleotides, class = "promoter")
    non_promoter_df <- data.frame(nucleotide = non_promoter_nucleotides, class = "non-promoter")
    combined_df <- rbind(promoter_df, non_promoter_df)
    
    # Calculate frequencies
    freq_df <- combined_df %>%
      group_by(class, nucleotide) %>%
      summarise(count = n()) %>%
      mutate(freq = count / sum(count))
    
    # Debug: Print to console
    print(freq_df)
    
    # Plot
    ggplot(freq_df, aes(x = nucleotide, y = freq, fill = class)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(x = "Nucleotide", y = "Frequency", fill = "Class") +
      theme_minimal()  # Add a theme for better visibility
  })
}

# Run the app
shinyApp(ui, server)


