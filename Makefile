.PHONY: test test-static test-scenarios install

test:
	@./tests/run.sh

test-static:
	@./tests/static/validate-skills.sh
	@python3 ./tests/static/validate-artifacts.py

test-scenarios:
	@echo "Manual scenario tests — see tests/scenarios/README.md"

install:
	@./scripts/install.sh
