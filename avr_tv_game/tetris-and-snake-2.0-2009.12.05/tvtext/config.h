#define TVTEXT_PICTURE_PORT       PORTD   // Port that the picture data is output from.
#define TVTEXT_PICTURE_DDR         DDRD   // Data direction register for the port that the picture data is output from.
#define TVTEXT_PICTURE_BIT            7   // Bit index representing the pin in the port that the picture signal is output from (must be 7).

#define TVTEXT_SYNC_PORT          PORTB   // Port that the sync signal is output from.
#define TVTEXT_SYNC_DDR            DDRB   // Data direction register for the port that the sync signal is output from.
#define TVTEXT_SYNC_BIT               0   // Bit index representing the pin in the port that the sync signal is output from.

#define TVTEXT_SKIP_ALTERNATE_ROWS    0   // Enable this flag to skip every other scanline in the output. This gives the user program more CPU time.

#define TVTEXT_CHARACTER_WIDTH        8   // Width of characters in pixels. Can be 6 or 8.

#define TVTEXT_SQUASHED_HORIZONTALLY  0   // Set to squash the display slightly horizontally to fit the TV better at the expense of some non-square pixels.

#define TVTEXT_FONT      "../font.h"   // Name of the font file to use relative to the tvtext directory. Leave commented out to use the default font.
