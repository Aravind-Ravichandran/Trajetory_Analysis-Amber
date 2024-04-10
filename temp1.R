library(bio3d)
args = commandArgs(trailingOnly=TRUE)
dcdfile = args[1]
pdbfile = args[2]
res_no = args[3]

dcd <- read.dcd(dcdfile)
pdb <- read.pdb(pdbfile)
ca.inds <- atom.select(pdb, elety=c("CA", resno=res_no))
xyz <- fit.xyz(fixed=pdb$xyz, mobile=dcd, fixed.inds=ca.inds$xyz, mobile.inds=ca.inds$xyz)


#RMSD Plots
rd <- rmsd(xyz[1,ca.inds$xyz], xyz[,ca.inds$xyz])
png("RMSD.png", width = 3500, height = 1400, res = 300)
par(mar=c(6, 4, 4, 2) + 0.5)
plot(rd, type ="l", ylab=expression(paste("RMSD ( ", "\uc5", " )")), xlab="Frame No.", lwd =1.5)
box(lwd=1.5) 
points(lowess(rd), typ="l", col="red", lty=2, lwd=2)
dev.off()

#RMSD Histogram
png("RMSD_Histogram.png", width = 3500, height = 3400, res = 300)
par(mar=c(6, 4, 4, 2) + 0.5, lwd = 2.5)
hist(rd, breaks=40, freq=FALSE, main="RMSD Histogram", xlab="RMSD", pch=16, cex.lab=1.5, cex.axis=1.5, cex.main=1.5, cex.sub=1.5)
box(lwd=2) 
lines(density(rd), col="red", lwd=3)
dev.off()

#RMSF Plot
rf <- rmsf(xyz[,ca.inds$xyz])
png("RMSF.png", width = 3500, height = 1400, res = 300)
par(mar=c(6, 4, 4, 2) + 0.5)
plot(rf, ylab=expression(paste("RMSF ( ", "\uc5", " )")), xlab="Residue Number", typ="l", main="RMSF Plot", lwd=1.5)
box(lwd=1.5) 
dev.off()

#PCA Analysis
pc <- pca.xyz(xyz[,ca.inds$xyz])
png("PCA.png", width = 3500, height = 3400, res = 300)
par(mar=c(6, 4, 4, 2) + 0.5, lwd = 2.5)
plot(pc, col=bwr.colors(nrow(xyz)),cex.lab=1.5, cex.axis=1.5, cex.main=1.5, cex.sub=1.5)
dev.off()

# clustering in PC-space 
hc <- hclust(dist(pc$z[,1:2]))
grps <- cutree(hc, k=3)
png("PCA_Clustering.png", width = 3500, height = 3400, res = 300)
par(mar=c(6, 4, 4, 2) + 0.5, lwd = 2.5)
plot(pc, col=grps,cex.lab=1.5, cex.axis=1.5, cex.main=1.5, cex.sub=1.5)
dev.off()

#Which residue contributes to PCA
png("Residue_Contribution_to_PCA.png", width = 3500, height = 1400, res = 300)
par(mar=c(6, 4, 4, 2) + 0.5, lwd = 2.5)
plot.bio3d(pc$au[,1], ylab="PC1 (A)", xlab="Residue Position", typ="l", main="Residue Contribution to PCA")
box(lwd=1.5) 
points(pc$au[,2], typ="l", col="blue")
dev.off()

#PCA to PDB
p1 <- mktrj.pca(pc, pc=1, b=pc$au[,1], file="pc1.pdb")
p2 <- mktrj.pca(pc, pc=2,b=pc$au[,2], file="pc2.pdb")
#write.dcd(p1, "trj_pc1.dcd")

#Cross-Correlation Analysis
cij<-dccm(xyz[,ca.inds$xyz])
png("Cross_Correlation_plot.png", width = 3500, height = 3400, res = 300)
par(mar=c(6, 4, 4, 2) + 0.5, lwd = 2.5)
plot(cij)
dev.off()
#pymol.dccm(cij, pdb, type="launch")
