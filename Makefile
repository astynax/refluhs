INSTALL_ROOT != stack path --local-install-root 
INPUT_FILE = $(INSTALL_ROOT)/bin/refluhs.jsexe/all.js
OUTPUT_FILE = public/all.min.js
EXTERNS_FILE = js/externs.js
OPTIMIZATION = ADVANCED

all: $(OUTPUT_FILE)

$(OUTPUT_FILE): $(INPUT_FILE)
	closure $(INPUT_FILE) --externs $(EXTERNS_FILE) --js_output_file $(OUTPUT_FILE) -O $(OPTIMIZATION)

$(INPUT_FILE):
	stack build

.PHONY: $(INPUT_FILE)

