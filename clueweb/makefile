#set bash
SHELL := /bin/bash


###############################################################
#Default make target

response: response_clueweb_pp13
	cp -v $< $@ 


###############################################################
#1. Data preprocessing:

# Converts candidates into protocol-buffer format.
candidates.pb: candidates
	$(TAC_ROOT)/components/bin/cands_to_proto.sh $+ $@

# Extracts features on a per-sentence level.
sfeatures: candidates.pb
	$(TAC_ROOT)/components/bin/sfeatures.sh $+ $@

# Runs candidates through dependency parser so they can be used by the dependency matcher.
candidates.parsed.pb:   candidates.pb
	$(TAC_ROOT)/components/bin/parse_candidates.sh $+ $@

# Adds expansiond to original queries and explicitly lists relations.
query_expanded.xml: query.xml
	$(TAC_ROOT)/components/bin/expand_query.sh $+ $@


###############################################################
#2. Make predictions and create responses (response_xxx files)

# Predicts slot fillers on a per-sentence level.
predictions_classifier: sfeatures
	$(TAC_ROOT)/components/bin/predictions.sh $+ $@

# Generates TAC-response with 'lsv' team id.
response_classifier: query_expanded.xml predictions_classifier
	$(TAC_ROOT)/components/bin/response.sh $+ $@

# Response from induced patterns.
response_induced_patterns: query_expanded.xml candidates
	$(TAC_ROOT)/components/bin/induced_pattern_response.sh $+ $@

# Responce from shortened induced patterns (universial schema patterns)
response_shortened_patterns: query_expanded.xml candidates
	$(TAC_ROOT)/components/bin/shortened_pattern_response.sh $+ $@

# Response from pattern matches.
response_patterns: query_expanded.xml candidates.pb
	$(TAC_ROOT)/components/bin/pattern_response.sh $+ $@

###############################################################
#4. Merge responses

response_clueweb: query_expanded.xml response_classifier response_shortened_patterns response_induced_patterns response_patterns
	$(TAC_ROOT)/components/bin/merge_responses.sh $+ > $@

###############################################################
#5. Post process responses

# Template for postprocessing responses for 2013 format
%_pp13: % query_expanded.xml /dev/null
	$(TAC_ROOT)/components/bin/postprocess2013.sh $+ $@


###############################################################

# Cleaning
clean:
	rm -f candidates.* query_expanded.xml sfeatures predictions_classifier \
	response_classifier response_shortened_patterns response_induced_patterns response_patterns \
	log4j.txt
