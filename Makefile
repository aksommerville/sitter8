all:
.SILENT:
.SECONDARY:
PRECMD=echo "  $(@F)" ; mkdir -p $(@D) ;

PICO8_EXE:=~/games/pico-8/pico8
PICO8_HOME:=~/.lexaloffle/pico-8

run:;$(PICO8_EXE) -run sitter.p8
edit:;$(PICO8_EXE) sitter.p8
pkg:;$(PICO8_EXE) sitter.p8 -export sitter.p8.png
