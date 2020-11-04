#ifndef _STDBOOL_H
#define _STDBOOL_H

#include <stdint.h>

#define bool uint8_t;

#define true ((uint8_t)1)
#define false ((uint8_t)0)

#define __bool_true_false_are_defined 1

#endif /* _STDBOOL_H */