PYTHON = python3
FLAGS = -c
CMD = 'import sys, yaml, json; json.dump(yaml.load(sys.stdin, Loader=yaml.Loader), sys.stdout, indent=2)'

all: outgoing/cfr-fxa.json outgoing/cfr-heartbeat.json outgoing/cfr.json \
     outgoing/message-groups.json outgoing/messaging-experiments.json \
     outgoing/moments.json outgoing/whats-new-panel.json

outgoing/%.json: messages/%.yaml pre-build
	$(PYTHON) $(FLAGS) $(CMD) < $< > $@

.PHONY: clean check

pre-build:
	yamllint .

clean:
	rm *.json

check:
	scripts/validate.py cfr outgoing/cfr.json
	scripts/validate.py cfr-fxa outgoing/cfr-fxa.json
	scripts/validate.py cfr-heartbeat outgoing/cfr-heartbeat.json
	scripts/validate.py message-groups outgoing/message-groups.json
	scripts/validate.py messaging-experiments outgoing/messaging-experiments.json
	scripts/validate.py moments-page outgoing/moments.json
	scripts/validate.py whats-new-panel outgoing/whats-new-panel.json
