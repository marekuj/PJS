PROJECTDIR = ../
USRDIR = /usr/include
SRCDIR = src
OBJDIR = obj
OUTPUTDIR = bin

CPP_PLAINFILESLIST = \
	main.cpp

CPP_FILES = $(addprefix $(SRCDIR)/, $(CPP_PLAINFILESLIST))

LD_FLAGS = \
	
LD_PATHS = \

POSTCOMPILE = mv -f $(OBJDIR)/$*.Td $(OBJDIR)/$*.d
OBJTREEDIRS = $(sort $(dir $(CPP_PLAINFILESLIST)))

BUILD_DIRS = \
	$(OBJDIR) \
	$(OUTPUTDIR) \
	$(addprefix $(OBJDIR)/, $(OBJTREEDIRS))

OBJ_FILES = \
	$(patsubst $(SRCDIR)/%.cpp, $(OBJDIR)/%.o, $(CPP_FILES))

CXX = g++
CXX_FLAGS = -g -c -pipe -std=c++11 -Wall -W -MMD -MP -pthread -O3 -fpic

CXX_INCLUDES = \
	-I$(USRDIR) \
	-I$(PROJECTDIR)

default: app_test_2

app_test_2: $(BUILD_DIRS) $(OBJ_FILES)	
	$(CXX) $(LD_PATHS) $(LD_FLAGS) -o $(OUTPUTDIR)/$@ $(OBJ_FILES)

$(BUILD_DIRS):
	mkdir -p $@

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	@echo $<
	$(CXX) $(CXX_FLAGS) $(CXX_INCLUDES) -c -MF $(patsubst $(OBJDIR)/%.o, $(OBJDIR)/%.Td, $@) -o $@ $<
	$(POSTCOMPILE)

clean:
	rm -rf $(OBJDIR) $(OUTPUTDIR)

dirs:	
	mkdir -p $(OBJDIR) $(OUTPUTDIR)
