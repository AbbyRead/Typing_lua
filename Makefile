THIS = typing.lua
DEST = $(HOME)/bin/$(THIS)

install: $(DEST)

$(DEST): $(THIS)
	@if diff -q $(THIS) $(DEST) > /dev/null; then \
		echo "✓ No changes. $(DEST) is up to date."; \
	else \
		echo "→ Updating $(DEST)..."; \
		cp $(THIS) $(DEST) && echo "✓ Installed successfully." || echo "✗ Copy failed!"; \
	fi

.PHONY: diff
diff:
	@if diff -q $(DEST) $(THIS); then \
		echo "✗ No differences found."; \
	fi
