PROJECTS = test_1 test_2 test_3

CLEAN = -clean
PROJECTS_CLEAN = $(addsuffix $(CLEAN), $(PROJECTS)) 

all: $(PROJECTS)

$(PROJECTS):
	$(MAKE) -C $@

clean: $(PROJECTS_CLEAN)

$(PROJECTS_CLEAN):
	$(MAKE) -C  $(subst -, ,$@)

.PHONY: $(PROJECTS)