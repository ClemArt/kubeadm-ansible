venv = venv/bin/activate

$(venv):
	python3 -m venv venv

.PHONY: install
install: $(venv)
	. $(venv); \
	pip install -r requirements.txt

