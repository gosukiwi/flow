.PHONY: test test-static test-scenarios install

test:
	@./tests/run.sh

test-static:
	@./tests/static/validate-skills.sh
	@python3 ./tests/static/validate-artifacts.py

test-scenarios:
	@chmod +x ./tests/scenarios/run-scenarios.sh
	@./tests/scenarios/run-scenarios.sh

install:
	@./scripts/install.sh
