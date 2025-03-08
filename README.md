# PromoterShiny

**An Interactive RShiny Dashboard for Visualizing Promoter Gene Sequences**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

PromoterShiny is a simple yet innovative RShiny application designed to explore and visualize promoter gene sequences from the UCI "Molecular Biology (Promoter Gene Sequences)" dataset. This dashboard provides two main features: a nucleotide frequency heatmap for promoter and non-promoter sequences, and an interactive position-wise nucleotide frequency analysis. Built with bioinformatics beginners and researchers in mind, it offers an accessible way to investigate sequence patterns in E. coli promoter regions.

---

## Features

- **Nucleotide Frequency Heatmap**: Visualize the distribution of nucleotides (A, G, C, T) across 57 positions for promoter and non-promoter sequences side by side.
- **Position-wise Analysis**: Interactively select a position (1-57) to compare nucleotide frequencies between promoter and non-promoter classes using bar plots.
- **Reproducible Workflow**: Uses open-source data and R packages, with clear instructions for setup and execution.

---

## Dataset

The project uses the ["Molecular Biology (Promoter Gene Sequences)" dataset](https://archive.ics.uci.edu/ml/datasets/Molecular%2BBiology%2B%28Promoter%2BGene%2BSequences%29) from the UCI Machine Learning Repository:
- **Source**: Donated June 29, 1990.
- **Content**: 106 instances of E. coli gene sequences, classified as promoter (+) or non-promoter (-), with 57 nucleotide positions each.
- **Download**: Available directly from the UCI link above; save `promoters.data` in the project directory.

---

## Installation

### Prerequisites
- **R**: Version 4.0.0 or higher recommended (earlier versions may work with adjustments).
- **RStudio**: Optional, but recommended for project management and Shiny development.
- **R Packages**:
  - `shiny`
  - `dplyr`
  - `ggplot2`
  - `tidyr`

### Setup Steps
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/YourUsername/PromoterShiny.git
   cd PromoterShiny