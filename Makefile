.PHONY: lint html clean cacheclean

lint:
	jupyter book build book/ \
	  --warningiserror \
	  --nitpick \
	  --keep-going \
	  --all \
	  --verbose

html:
	Q2DOC_BASE_COMMAND='qiime2' jupyter book build book/

clean:
	jupyter book clean book/

cacheclean:
	rm -rf book/_build/
