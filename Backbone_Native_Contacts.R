library(matrixStats)
library(dplyr)
setwd("/home/aravindr/fat10/FAT10_Substrates/s15a/Native_contacts/Lys19")

#Loading Lys32
files1 = list.files(".", pattern="lys19_backbone_native")
df1 = read.table(files1[1], header=F)
merged_df1 = data.frame(V1 = df1[,1])
for(x in files1){
  df1 = read.table(x, header=F)
  merged_df1 = merge(merged_df1, df1, by = "V1")
}
names(merged_df1) = c("time","d1_1_NC","d1_1_NNC","d1_2_NC","d1_2_NNC","d1_3_NC","d1_3_NNC")
merged_df1$norm_1 = (select(merged_df1,d1_1_NC))/(max(select(merged_df1,d1_1_NC)))
merged_df1$norm_2 = (select(merged_df1,d1_2_NC))/(max(select(merged_df1,d1_2_NC)))
merged_df1$norm_3 = (select(merged_df1,d1_3_NC))/(max(select(merged_df1,d1_3_NC)))
merged_df1$mean = rowMeans(merged_df1 %>% select(8:10))
merged_df1$sd = rowSds(as.matrix(merged_df1 %>% select(8:10)))
x1 = merged_df1$time/25
y1 = merged_df1$mean
sd1 = merged_df1$sd
se1 = sd1/sqrt(3)


#Loading Lys48
setwd("/home/aravindr/fat10/FAT10_Substrates/s15a/Native_contacts/Lys59")
files2 = list.files(".", pattern="lys59_backbone_native")
df2 = read.table(files2[1], header=F)
merged_df2 = data.frame(V1 = df2[,1])
for(y in files2){
  df2 = read.table(y, header=F)
  merged_df2 = merge(merged_df2, df2, by = "V1")
}
names(merged_df2) = c("time","d2_1_NC","d2_1_NNC","d2_2_NC","d2_2_NNC","d2_3_NC","d2_3_NNC")
merged_df2$norm_1 = (select(merged_df2,d2_1_NC))/(max(select(merged_df2,d2_1_NC)))
merged_df2$norm_2 = (select(merged_df2,d2_2_NC))/(max(select(merged_df2,d2_2_NC)))
merged_df2$norm_3 = (select(merged_df2,d2_3_NC))/(max(select(merged_df2,d2_3_NC)))
merged_df2$mean = rowMeans(merged_df2 %>% select(8:10))
merged_df2$sd = rowSds(as.matrix(merged_df2 %>% select(8:10)))
x2 = merged_df2$time/25
y2 = merged_df2$mean
sd2 = merged_df2$sd
se2 = sd2/sqrt(3)


#Loading Lys76
setwd("/home/aravindr/fat10/FAT10_Substrates/s15a/Native_contacts/Lys70")
files3 = list.files(".", pattern="lys70_backbone_native")
df3 = read.table(files3[1], header=F)
merged_df3 = data.frame(V1 = df3[,1])
for(z in files3){
  df3 = read.table(z, header=F)
  merged_df3 = merge(merged_df3, df3, by = "V1")
}
names(merged_df3) = c("time","d3_1_NC","d3_1_NNC","d3_2_NC","d3_2_NNC","d3_3_NC","d3_3_NNC")
merged_df3$norm_1 = (select(merged_df3,d3_1_NC))/(max(select(merged_df3,d3_1_NC)))
merged_df3$norm_2 = (select(merged_df3,d3_2_NC))/(max(select(merged_df3,d3_2_NC)))
merged_df3$norm_3 = (select(merged_df3,d3_3_NC))/(max(select(merged_df3,d3_3_NC)))
merged_df3$mean = rowMeans(merged_df3 %>% select(8:10))
merged_df3$sd = rowSds(as.matrix(merged_df3 %>% select(8:10)))
x3 = merged_df3$time/25
y3 = merged_df3$mean
sd3 = merged_df3$sd
se3 = sd3/sqrt(3)

# Update to ignore initial 10 values
x1 = x1[101:length(x1)]
y1 = y1[101:length(y1)]
se1 = se1[101:length(se1)]
x2 = x2[101:length(x2)]
y2 = y2[101:length(y2)]
se2 = se2[101:length(se2)]
x3 = x3[101:length(x3)]
y3 = y3[101:length(y3)]
se3 = se3[101:length(se3)]

# Set the working directory
setwd("/home/aravindr/fat10/FAT10_Substrates/s15a/Native_contacts")

# Set the PNG output file
png('s15a_backbone_native_subset.png', units="in", width = 22, height = 8, res=1200)

# Set the margin and plot
par(mar = c(7, 7, 2, 1) + 0.5)
par(mgp = c(3, 1, 0))
par(las = 2)  # Rotate the x-axis labels

plot(x1, y1, cex = 0.2, ylim =  c(0.8,1), type = "l", lwd = 2.5, col = "#94B49F", ylab = "", xlab = "", yaxt = "n", xaxt = "n")

box(lwd=5.0)

axis(1, seq(0,1000,100), font = 2, cex.axis = 3.5, lwd = 5)
axis(2, seq(0.8,1,.05), font = 2, cex.axis = 3.5, lwd = 5)

lines(x2, y2, cex = 0.2, ylim = c(0, 1), type = "l", lwd = 2.5, col = "#DF7861")
lines(x3, y3, cex = 0.2, ylim = c(0, 1), type = "l", lwd = 2.5, col = "#76549A")

dev.off()