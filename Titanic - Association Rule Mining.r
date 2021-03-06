
rm(list=ls())
knitr::opts_chunk$set(echo = TRUE)
setwd("S://DATA Science//R//Titanic//")
packages <- c("arules", "arulesViz")
purrr::walk(packages, library, character.only = TRUE, warn.conflicts = FALSE)

#This document intends to find and plot relationships among Survival, Passenger Class, Sex and Age variables from the Titanic Training Dataset. The RData file for the same is also available at http://www.rdatamining.com/data/titanic.raw.rdata?attredirects=0&d=1:


load("S:/DATA Science/R/Titanic/titanic.raw.rdata")

sapply(titanic.raw, FUN=function(x) addmargins(table(x)))

summary(titanic.raw)

rules.all <- apriori(titanic.raw)


inspect(rules.all)

rules <- apriori(titanic.raw,
                 control = list(verbose=F),
                 parameter = list(minlen = 2, supp = 0.005, conf = 0.8),
                 appearance = list(rhs=c("Survived=No","Survived=Yes"),
                                  default = "lhs"))

quality(rules)

rules.sorted <- sort(rules, by="lift")

inspect(rules.sorted)


subset.matrix <- is.subset(rules.sorted,rules.sorted)
subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
redundant <- colSums(subset.matrix, na.rm=T) >= 1

which(redundant)

rules.purned <- rules.sorted[!redundant]

inspect(rules.purned)

plot(rules.all, method="grouped")
plot(rules.purned, method="grouped")

plot(rules.all, method="graph")
plot(rules.purned, method="graph")

plot(rules.all, method="graph", control=list(type="items"))
plot(rules.purned, method="graph", control=list(type="items"))

plot(rules.all, method="paracoord", control=list(reorder=TRUE))
plot(rules.purned, method="paracoord", control=list(reorder=TRUE))


