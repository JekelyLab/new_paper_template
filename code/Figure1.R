rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
gc() #free up memory and report the memory usage.

# load some packages
library(tidyverse)
library(cowplot)
library(png)
library(patchwork)


# Load and process the data -----------------------------------------------
#read some pre-processed data text/csv file from the /data directory
syn_df <- read.csv2("data/head_celltypes_syn_matrix.csv", row.names=1)

syn_df

#check the loaded data
syn_df[1:10,1:10]
dim(syn_df)

#convert to tibble to have tidy data
syn_tb <- as.data.frame(syn_df) %>%
  rownames_to_column(var = "presyn_cell_group") %>%
  pivot_longer(-presyn_cell_group, names_to = "postsyn_cell_group", values_to = "synapses")%>%
  group_by(postsyn_cell_group) %>%
  mutate(synapse_fraction = synapses / sum(synapses, na.rm = TRUE))

#check the tibble
syn_tb$presyn_cell_group

# visualise the data and save plot ----------------------------------------

#plot with ggplot
ggplot(syn_tb) +
  geom_point(aes(x = postsyn_cell_group, y = presyn_cell_group, size = sqrt(synapses), color = synapse_fraction), 
             stroke = 0,)+ 
  theme(
    axis.text.x = element_text (angle = 90,hjust = 1, vjust = 0.5, size=3), 
    axis.text.y = element_text (angle = 0,hjust = 1, vjust = 0.5, size=3),
    axis.title.x = element_text (size=14),
    axis.title.y = element_text (size=14)
  ) + 
  labs(x="postsynaptic cell types",y="presynaptic cell types",title=" ") +
  scale_size_area(max_size=1) +
  guides(color = 'legend') +
  scale_colour_gradient2(
    low = "#0072B2",
    mid = "#D55E00",
    high ="#D55E00",
    midpoint = 0.5,
    space = "Lab",
    na.value = "grey50",
    guide = "colourbar",
    aesthetics = "colour") +
  theme(panel.background = element_rect(fill = "grey98", color = "white"))


# Save the plot as pdf and png
ggsave("pictures/head_celltypes_syn_matrix.pdf", 
       width = 2000, 
       height = 1600, limitsize = TRUE, 
       units = c("px"))
ggsave("pictures/head_celltypes_syn_matrix.png", 
       width = 1700, 
       height = 1400, limitsize = TRUE, 
       units = c("px"))


# save the table as supplementary file ------------------------------------
#write table
readr::write_csv(syn_tb, file="supplements/Supplementary_table1.csv", na="", quote="none")



# assemble figure ---------------------------------------------------------

#read png convert to image panel
panelA <- ggdraw() + draw_image(readPNG("pictures/Platynereis_SEM_inverted_nolabel.png"), scale = 1) + 
  draw_label("Platynereis larva", x = 0.5, y = 0.95, fontfamily = "sans", fontface = "plain",
             color = "black", size = 11, angle = 0, lineheight = 0.9, alpha = 1) +
  draw_label(expression(paste("50 ", mu, "m")), x = 0.2, y = 0.11, fontfamily = "sans", fontface = "plain",
             color = "black", size = 10, angle = 0, lineheight = 0.9, alpha = 1) + 
  draw_label("head", x = 0.5, y = 0.85, fontfamily = "sans", fontface = "plain",
             color = "black", size = 9, angle = 0, lineheight = 0.9, alpha = 1) + 
  draw_label("sg0", x = 0.52, y = 0.67, fontfamily = "sans", fontface = "plain",
             color = "black", size = 9, angle = 0, lineheight = 0.9, alpha = 1) + 
  draw_label("sg1", x = 0.51, y = 0.55, fontfamily = "sans", fontface = "plain",
             color = "black", size = 9, angle = 0, lineheight = 0.9, alpha = 1) + 
  draw_label("sg2", x = 0.52, y = 0.4, fontfamily = "sans", fontface = "plain",
             color = "black", size = 9, angle = 0, lineheight = 0.9, alpha = 1) + 
  draw_label("sg3", x = 0.54, y = 0.2, fontfamily = "sans", fontface = "plain",
             color = "black", size = 9, angle = 0, lineheight = 0.9, alpha = 1) + 
  draw_label("pygidium", x = 0.55, y = 0.03, fontfamily = "sans", fontface = "plain",
             color = "black", size = 9, angle = 0, lineheight = 0.9, alpha = 1)
panelB <- ggdraw() + draw_image(readPNG("pictures/head_celltypes_syn_matrix.png"), scale = 1) + 
  draw_label("Synaptic connectivity of head cell types", x = 0.45, y = 0.97, fontfamily = "sans", fontface = "plain",
             color = "black", size = 8, angle = 0, lineheight = 0.9, alpha = 1)


#combine panels into Figure and save final figure as pdf and png
Fig1 <- plot_grid(panelA,panelB,
                  ncol=2,
                  rel_widths = c(0.4, 1),
                  labels=c("A", "B"),
                  label_size = 12, label_y = 1, label_x = 0,
                  label_fontfamily = "sans", label_fontface = "plain") + 
  theme(plot.margin = unit(c(1, 1, 1, 1), units = "pt"))

#save
ggsave("figures/Figure1.pdf", limitsize = FALSE, 
       units = c("px"), Fig1, width = 1800, height = 850)
ggsave("figures/Figure1.png", limitsize = FALSE, 
       units = c("px"), Fig1, width = 1800, height = 850, bg='white')



