#include <stdint.h>
#include <stddef.h>

typedef struct _IO_FILE
{
    int fd;
} FILE;

/* fopen
 * Opens a file in the given mode.
 * Returns a handle to that file.
 */
FILE * fopen(const char * filename, const char * mode);

/* fclose
 * Closes an open file.
 */
int fclose(FILE * stream);

/* fread
 * Reads a number of generic data items from a stream.
 * Returns the number of items read.
 */
size_t fread(void * ptr, size_t size, size_t n, FILE * stream);

/* fgets
 * Gets line from file.
 */
char * fgets(char * str, int n, FILE * stream);
