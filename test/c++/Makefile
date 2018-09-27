include ../common.mak

TESTS:=exceptions

ifeq (osx,$(OS))
	LDSTDCPP := -L-lc++
else
	LDSTDCPP := -L-lstdc++
endif

.PHONY: all clean exceptions
all: $(addprefix $(ROOT)/,$(addsuffix .done,$(TESTS)))
clean:
	rm -rf $(GENERATED)

# Generic testing rule
$(ROOT)/%.done: $(ROOT)/%
	@echo Testing $*
	$(QUIET)$(TIMELIMIT)$(ROOT)/$* $(RUN_ARGS)
	@touch $@

$(ROOT)/exceptions:
	$(QUIET)$(CXX) exceptions/exception.cpp -c -o exceptions/cpp_exception_test.o
	$(QUIET)$(DMD) $(LDSTDCPP) exceptions/cpp_exception_test.o exceptions/dexception.d -of$@
