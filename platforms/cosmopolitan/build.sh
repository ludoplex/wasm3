
COSMOPOLITAN_URL=https://justine.lol/cosmopolitan/cosmopolitan.zip

SOURCE_DIR=../../source

EXTRA_FLAGS= #-Dd_m3HasWASI

STD=./cosmopolitan/std

if [ ! -d "./cosmopolitan" ]; then
    echo "Downloading Cosmopolitan..."
    curl -o cosmopolitan.zip $COSMOPOLITAN_URL
    unzip cosmopolitan.zip -d cosmopolitan
    rm cosmopolitan.zip
fi

if [ ! -d "$STD/sys" ]; then
    # Generate header stubs
    mkdir -p $STD/sys
    touch $STD/assert.h $STD/limits.h $STD/ctype.h $STD/time.h $STD/errno.h
    touch $STD/inttypes.h $STD/fcntl.h $STD/math.h $STD/stdarg.h $STD/stdbool.h
    touch $STD/stdint.h $STD/stdio.h $STD/stdlib.h $STD/string.h $STD/stddef.h
    touch $STD/sys/types.h $STD/sys/stat.h $STD/unistd.h $STD/sys/uio.h $STD/sys/random.h
fi

echo "Building Wasm3..."

gcc -g -O -static -fno-pie -no-pie -mno-red-zone -nostdlib -nostdinc                    \
  -Wl,--oformat=binary -Wl,--gc-sections -Wl,-z,max-page-size=0x1000 -fuse-ld=bfd       \
  -Wl,-T,cosmopolitan/ape.lds -include cosmopolitan/cosmopolitan.h                      \
  -Wno-format-security -Wfatal-errors $EXTRA_FLAGS                                      \
  -o wasm3.com -DAPE -I$STD -I$SOURCE_DIR $SOURCE_DIR/*.c ../app/main.c                 \
  cosmopolitan/crt.o cosmopolitan/ape.o cosmopolitan/cosmopolitan.a