library(Seurat)
library(dplyr)
library(tidyr)
library(reshape2)
library(viridis)

setwd("/Volumes/BZ/Home/gizevo30/R_Projects/Cavefish_Paper/AstMex_Hypo")

hypo <- readRDS("AstMex_63k.rds")

## Set colours for tsne
cols0 <- c("lightgoldenrod1", "springgreen4") # change to viridis

## Make TSNE graphs

png("Figures/hypo_cluster_plot_Subtype_nolab.png", height = 8, width = 8, units = "in", res = 500)
DimPlot(object = hypo, group.by = "Subtype", reduction = "tsne", pt.size = .05, label = F,  label.size = 5) + NoLegend() + NoAxes()
dev.off()

png("Figures/hypo_cluster_plot_Subtype.png", height = 8, width = 8, units = "in", res = 500)
DimPlot(object = hypo, group.by = "Subtype", reduction = "tsne", pt.size = .05, label = T,  label.size = 5) + NoLegend() + NoAxes()
dev.off()

png("Figures/hypo_cluster_plot_SubclusterType.png", height = 8, width = 8, units = "in", res = 500)
DimPlot(object = hypo, group.by = "SubclusterType", reduction = "tsne", pt.size = .05, label = T,  label.size = 2) + NoLegend() + NoAxes()
dev.off()

png("Figures/hypo_cluster_plot_species_morph.png", height = 8, width = 8, units = "in", res = 500)
DimPlot(object = hypo, group.by = "species", reduction = "tsne", pt.size = .05, label = F,  label.size = 2, cols = cols0) + NoAxes() + theme(legend.position = c(0.91,0.87), legend.background = element_blank()) + guides(color = guide_legend(ncol = 2, override.aes = list(size = 5)))
dev.off()

png("Figures/hypo_cluster_plot_orig.ident.png", height = 8, width = 8, units = "in", res = 500)
DimPlot(object = hypo, group.by = "orig.ident", reduction = "tsne", pt.size = .05, label = F,  label.size = 2) + NoAxes() + theme(legend.position = c(0.91,0.87), legend.background = element_blank()) + guides(color = guide_legend(ncol = 2, override.aes = list(size = 5)))
dev.off()


# DotPlots for major markers

png("Figures/hypo_dotplots_Subtype_markers.png", height = 10, width = 6.5, units = "in", res = 500) 
DotPlot(object = hypo, features = rev(c("gng3", "slc17a6a", "gad1b", "her15.1", "prdx1", "otpb", "pfn1", "mpz", "mrc1a", "epd", "hopx", "hbaa2")), group.by = "Subtype") + theme(legend.position = "right") + RotatedAxis()
dev.off()

# DotPlots for Subtype marker genes

gene.lists <- readRDS("marker_gene_lists.rds")

genes.to.plot <- lapply(gene.lists[[1]], function(x) row.names(x)[1:5])

DotPlot(hypo, features = rev(unique(unlist(genes.to.plot))), group.by = "Subtype", scale.max = 200) + coord_flip() + scale_color_viridis() + theme(axis.text.y = element_text(size = 6), axis.text.x = element_text(size = 8, angle = 45, hjust = 1, vjust = 1), axis.title = element_blank())


# Make prop plot

# Make tables of cell type proportions

prop.table <- table(hypo@meta.data$Subtype, hypo@meta.data$orig.ident)

prop.table <- as.data.frame(t(apply(prop.table, 1, function(y) {y/sum(y)})))

prop.table$cell_type <- row.names(prop.table)
prop.table <- melt(prop.table)
prop.table$cell_type <- as.factor(prop.table$cell_type)

prop.plots <- ggplot(prop.table, aes(x=cell_type, y=value, fill=variable)) + geom_bar(stat="identity")

prop.plots <- prop.plots + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) + theme(axis.line.y=element_blank(), axis.ticks.y=element_blank(), axis.title.x = element_text(size = 10), axis.title.y = element_blank(), plot.background = element_rect(fill = "transparent", color = NA), panel.background = element_blank()) + geom_hline(yintercept = 0.5, color = "grey36", size = 1, linetype = "dashed") + ylab("Sample Subtype frequency") + coord_flip() + guides(fill = guide_legend(title = "Origin (cave or surface)"))

png("Figures/AstMex_Hypo_Subtype_prop.png", units = "in", res = 250, height = 10, width = 5)
prop.plots
dev.off()