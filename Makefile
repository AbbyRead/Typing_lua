# This makefile is just so that I can update the copy
#   that I have in a PATH directory, so that I can use
#   it without specifying the location of it.

THIS = typing.lua
DEST = $(HOME)/bin/$(THIS)

.PHONY: install, diff

install: $(DEST)

$(DEST): $(THIS)
	@if diff -q $(THIS) $(DEST) > /dev/null; then \
		echo "✓ No changes. $(DEST) is up to date."; \
	else \
		echo "→ Updating $(DEST)..."; \
		cp $(THIS) $(DEST) && echo "✓ Installed successfully." || echo "✗ Copy failed!"; \
	fi

diff:
	@if diff -q $(DEST) $(THIS); then \
		echo "✗ No differences found."; \
	fi
