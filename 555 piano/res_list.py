res = {
	2200: 2,
	56: 1,
	3900: 1,
	1800: 1,
	560: 1,
	4700: 1,
	68000: 1,
	330000: 1,
	1200: 1,
	2700: 1,
	120: 1,
	82000: 1,
	1500: 1,
	390: 1,
	5600: 1,
	120000: 2,
	1000: 1,
	47000: 1,
	680: 1,
	3300: 3,
	220: 2
}

#print res

for key, value in sorted(res.items()):
    if key >= 1000:
        key = key / 1000.0
        key = str(key).replace('.','k')
        key = key.rstrip("0")

    if value == 1:
        print "  ", key
    else:
        print str(value) + "x", key
