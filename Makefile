all:
.SILENT:
.SECONDARY:
PRECMD=echo "  $(@F)" ; mkdir -p $(@D) ;
force:

PICO8_EXE:=~/games/pico-8/pico8
PICO8_HOME:=~/.lexaloffle/pico-8

SRCFILES:=$(shell find src -type f)
SRC_LUA:=$(filter %.lua,$(SRCFILES))
SRC_P8:=src/sitter.p8

# OUT_HTML lives under "/built/", and *does* get committed to git.
# That way, we can serve it straight off Github, which makes me giggle.
OUT_CART:=out/sitter.p8.png
OUT_HTML:=built/sitter.html
OUT_BIN:=out/sitter.bin
all:$(OUT_CART) $(OUT_HTML) $(OUT_BIN)

$(OUT_CART):$(SRC_P8) $(SRC_LUA);$(PRECMD) $(PICO8_EXE) src/sitter.p8 -export $(OUT_CART)
$(OUT_HTML):$(SRC_P8) $(SRC_LUA);$(PRECMD) $(PICO8_EXE) src/sitter.p8 -export $(OUT_HTML)
$(OUT_BIN):force;$(PRECMD) $(PICO8_EXE) src/sitter.p8 -export $(OUT_BIN)

run:;$(PICO8_EXE) -run src/sitter.p8
edit:;$(PICO8_EXE) src/sitter.p8
pkg:$(OUT_CART) $(OUT_HTML) $(OUT_BIN)
run-cart:$(OUT_CART);$(PICO8_EXE) -run $(OUT_CART)
clean:;rm -rf mid out
zap-scores:;rm $(PICO8_HOME)/cdata/sitter_hi_scores.p8d.txt
