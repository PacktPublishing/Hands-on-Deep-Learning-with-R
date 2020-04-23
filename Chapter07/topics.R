tcm <- CreateTcm(doc_vec = twenty_newsgroups$text,
                 skipgram_window = 10,
                 verbose = FALSE,
                 cpus = 2)

embeddings <- FitLdaModel(dtm = tcm,
                          k = 20,
                          iterations = 500,
                          burnin = 200,
                          calc_coherence = TRUE)

embeddings$top_terms <- GetTopTerms(phi = embeddings$phi,
                                    M = 5)

embeddings$summary <- data.frame(topic = rownames(embeddings$phi),
                                 coherence = round(embeddings$coherence, 3),
                                 prevalence = round(colSums(embeddings$theta), 2),
                                 top_terms = apply(embeddings$top_terms, 2, function(x){
                                   paste(x, collapse = ", ")
                                 }),
                                 stringsAsFactors = FALSE)

embeddings$summary[order(embeddings$summary$coherence, decreasing = TRUE),][1:5,]
