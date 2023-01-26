
#
# tools
#

ASM=asmsx
EMULATOR=cmd /c start
PNG2MSX=png2msx

#
# commands
#

COPY=cmd /c copy
MKDIR=cmd /c mkdir
MOVE=cmd /c move
REMOVE=cmd /c del
RENAME=cmd /c ren

#
# paths and file lists
#

ROM=\
	justincyr-female-portraits.rom

ROMS=\
	$(ROM)

DATAS=\
	resources\00.clr.zx0 \
	resources\01.clr.zx0 \
	resources\02.clr.zx0 \
	resources\03.clr.zx0 \
	resources\04.clr.zx0 \
	resources\05.clr.zx0 \
	resources\06.clr.zx0 \
	resources\07.clr.zx0 \
	resources\08.clr.zx0 \
	resources\09.clr.zx0 \
	resources\10.clr.zx0 \
	resources\11.clr.zx0 \
	resources\12.clr.zx0 \
	resources\13.clr.zx0 \
	resources\14.clr.zx0 \
	resources\15.clr.zx0 \
	resources\16.clr.zx0 \
	resources\17.clr.zx0 \
	resources\18.clr.zx0 \
	resources\19.clr.zx0 \
	resources\20.clr.zx0 \
	resources\21.clr.zx0 \
	resources\22.clr.zx0 \
	resources\23.clr.zx0 \
	resources\24.clr.zx0 \
	resources\25.clr.zx0 \
	resources\26.clr.zx0 \
	resources\27.clr.zx0 \
	resources\28.clr.zx0 \
	resources\29.clr.zx0 \
	resources\30.clr.zx0 \
	resources\31.clr.zx0 \
	resources\32.clr.zx0 \
	resources\33.clr.zx0 \
	resources\34.clr.zx0 \
	resources\35.clr.zx0 \
	resources\36.clr.zx0 \
	resources\37.clr.zx0 \
	resources\38.clr.zx0 \
	resources\39.clr.zx0 \
	resources\40.clr.zx0 \
	resources\41.clr.zx0 \
	resources\42.clr.zx0 \
	resources\43.clr.zx0 \
	resources\44.clr.zx0 \
	resources\45.clr.zx0 \
	resources\46.clr.zx0 \
	resources\47.clr.zx0 \
	resources\48.clr.zx0 \
	resources\49.clr.zx0 \
	resources\50.clr.zx0 \
	resources\51.clr.zx0 \
	resources\52.clr.zx0 \
	resources\53.clr.zx0 \
	resources\54.clr.zx0 \
	resources\55.clr.zx0 \
	resources\56.clr.zx0 \
	resources\57.clr.zx0 \
	resources\58.clr.zx0 \
	resources\59.clr.zx0 \
	resources\60.clr.zx0 \
	resources\61.clr.zx0 \
	resources\62.clr.zx0

DATAS_INTERMEDIATE= \
	resources\00.clr \
	resources\01.clr \
	resources\02.clr \
	resources\03.clr \
	resources\04.clr \
	resources\05.clr \
	resources\06.clr \
	resources\07.clr \
	resources\08.clr \
	resources\09.clr \
	resources\10.clr \
	resources\11.clr \
	resources\12.clr \
	resources\13.clr \
	resources\14.clr \
	resources\15.clr \
	resources\16.clr \
	resources\17.clr \
	resources\18.clr \
	resources\19.clr \
	resources\20.clr \
	resources\21.clr \
	resources\22.clr \
	resources\23.clr \
	resources\24.clr \
	resources\25.clr \
	resources\26.clr \
	resources\27.clr \
	resources\28.clr \
	resources\29.clr \
	resources\30.clr \
	resources\31.clr \
	resources\32.clr \
	resources\33.clr \
	resources\34.clr \
	resources\35.clr \
	resources\36.clr \
	resources\37.clr \
	resources\38.clr \
	resources\39.clr \
	resources\40.clr \
	resources\41.clr \
	resources\42.clr \
	resources\43.clr \
	resources\44.clr \
	resources\45.clr \
	resources\46.clr \
	resources\47.clr \
	resources\48.clr \
	resources\49.clr \
	resources\50.clr \
	resources\51.clr \
	resources\52.clr \
	resources\53.clr \
	resources\54.clr \
	resources\55.clr \
	resources\56.clr \
	resources\57.clr \
	resources\58.clr \
	resources\59.clr \
	resources\60.clr \
	resources\61.clr \
	resources\62.clr \
	resources\msxready.png.clr

# default target
default: $(ROM)

#
# phony targets
#

clean:
	$(REMOVE) $(ROMS)
	$(REMOVE) $(DATAS_INTERMEDIATE) $(DATAS)
	$(REMOVE) ~tmppre.?

compile: $(ROMS)

run: runnable
	$(EMULATOR) $(ROM)

.secondary: $(DATAS_INTERMEDIATE)

#
# Convenience auxiliary targets
#

runnable: $(ROM)

#
# main targets
#

justincyr-female-portraits.rom: justincyr-female-portraits.asm $(DATAS)
	$(ASM) $<

#
# generic resources
#

%.clr.zx0: %.clr
	zx0 -f $< $@

resources\00.clr \
resources\01.clr \
resources\02.clr \
resources\03.clr \
resources\04.clr \
resources\05.clr \
resources\06.clr \
resources\07.clr \
resources\08.clr \
resources\09.clr \
resources\10.clr \
resources\11.clr \
resources\12.clr \
resources\13.clr \
resources\14.clr \
resources\15.clr \
resources\16.clr \
resources\17.clr \
resources\18.clr \
resources\19.clr \
resources\20.clr \
resources\21.clr \
resources\22.clr \
resources\23.clr \
resources\24.clr \
resources\25.clr \
resources\26.clr \
resources\27.clr \
resources\28.clr \
resources\29.clr \
resources\30.clr \
resources\31.clr \
resources\32.clr \
resources\33.clr \
resources\34.clr \
resources\35.clr \
resources\36.clr \
resources\37.clr \
resources\38.clr \
resources\39.clr \
resources\40.clr \
resources\41.clr \
resources\42.clr \
resources\43.clr \
resources\44.clr \
resources\45.clr \
resources\46.clr \
resources\47.clr \
resources\48.clr \
resources\49.clr \
resources\50.clr \
resources\51.clr \
resources\52.clr \
resources\53.clr \
resources\54.clr \
resources\55.clr \
resources\56.clr \
resources\57.clr \
resources\58.clr \
resources\59.clr \
resources\60.clr \
resources\61.clr \
resources\62.clr \
resources\63.clr: resources\msxready.png.clr java\target\justincyr-female-portraits.jar
	java -jar java\target\justincyr-female-portraits.jar $<

%.png.clr: %.png
	$(PNG2MSX) -f7 $<

java\target\justincyr-female-portraits.jar: \
java\pom.xml \
java\src\main\java\com\github\thenestruo\justincyrfemaleportraits\JustinCyrFemalePortraitsApp.java
	mvn -file $< clean package
