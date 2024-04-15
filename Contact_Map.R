library(ggplot2)

# Import data from a tab-separated file

data <- read.table("5_ProteinX_proteinY_toPlot_normalised_axis_corrected.dat", header=FALSE)
colnames(data) <- c("Var1", "Var2", "value")

# Plot the heat map
plot<-ggplot(data, aes(x = Var1, y = Var2)) + 
  geom_tile(aes(fill = value)) + 
  scale_fill_gradientn(colors = c("#FFFFFF","#FF0000","#800080","#000000","#000000")) +
  #scale_fill_gradientn(colors = c("#FFFFFF","#FFFF00","#800080","#000000","#000000")) +
  theme_classic() +
  theme(
    axis.line.x = element_line(color = "black", size = 1.5, linetype = "solid"),
    axis.line.y = element_line(color = "black", size = 1.5, linetype = "solid"),
    axis.text.x = element_text(size = 30, face = "bold",color = "black"),
    axis.text.y = element_text(size = 30, face = "bold",color = "black"),
    plot.background = element_rect(fill = "white"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(fill = NA, color = "black", size = 1.5),
    axis.ticks = element_line(color = "black", size = 1.5),
    axis.title.x = element_text(size = 0, face = "bold",color = "black"),
    axis.title.y = element_text(size = 0, face = "bold",color = "black"),
    axis.ticks.length = unit(8, "pt")
  ) + 
  scale_x_continuous(name = "FAT10", expand = c(0,0), breaks = pretty(data$Var1, 10), labels = scales::comma) +
  scale_y_continuous(name = "Parkin", expand = c(0,0), breaks = pretty(data$Var2, 10), labels = scales::comma) +
  labs(fill = "Contacts") +
  theme(legend.title = element_text(size = 20, face = "bold"),
        legend.text = element_text(size = 20, face = "bold")) +
  guides(fill = guide_colorbar(key.size = 10))

ggsave("Parkin-Lys32.png",plot, width = 10, height = 10, units = "in",dpi = 1200)

