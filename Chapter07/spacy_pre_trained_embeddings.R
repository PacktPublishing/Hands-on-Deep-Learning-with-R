spacy_install()

spacy_initialize(model = "en_core_web_sm")

spacy_parse(twenty_newsgroups$text[1], entity = TRUE, lemma = TRUE)