# MSX slideshow of Justin Cyr's &ldquo;1008 32x32 female portrait studies done in the MSX palette&rdquo;

> &ldquo;Ok, here's all 1008 32x32 female portrait studies done in the MSX palette.<br>
> 2 years, 3 months and one day later, it's done.&rdquo;<br>
> &mdash; <cite>[Justin Cyr - Feb 8, 2017](https://twitter.com/JUSTIN_CYR/status/829196024631681024)</cite>

This is a slideshow of those portraits coded for the real hardware (MSX) and assembled as a MegaROM cartridge image.


## Usage

Run `justincyr-female-portraits.rom` in your favourite MSX emulator, or flash it to a real cartridge and put the cartridge in your favourite MSX computer.

> Please note: MegaROM mapper: **ASCII 8K**


## Building process

Get the original image in PNG format: `resources/original.png`.

Scale it to 400% x 100%, nearest neighbour algorithm: `resources/msxready.png`.

Then, just `make`. It will:

* Convert to SCREEN 2 CLRTBL data using png2msx from [PCXTOOLS](https://github.com/theNestruo/pcxtools), forcing the bit 7 to be foreground. Discard the CHRTBL data: `png2msx -f7 resources/msxready.png`
* Process the CLRTBL data to be suitable for SCREEN 3 using the dedicated Java program: `java -jar java\target\justincyr-female-portraits.jar resources/msxready.png.clr`
* Compress the splitted SCREEN 3 data using ZX0: `zx0 -f resources/00.clr resources/00.clr.zx0`, &hellip;
* Assemble with asMSX: `asMSX justincyr-female-portraits.asm`

Intermediate resources are uploaded to the repository for your convenience.


# Credits

* Original image by [Justin Cyr](https://twitter.com/JUSTIN_CYR), posted in Twitter without any explicit license. Used here for educative purposes.
* MSX slideshow coded for MSX by [theNestruo](https://theNestruo.github.io).
* [asMSX](https://github.com/Fubukimaru/asMSX) originally developed by Eduardo "pitpan" A. Robsy Petrus and now mantained by the asMSX team.
* [ZX0 decoder](https://github.com/einar-saukas/ZX0) by [Einar Saukas](https://github.com/einar-saukas).
