.PHONY: 1 2 3 4 1.pdf

# https://docs.gtk.org/Pango/type_func.FontDescription.from_string.html#description
RABBIT_TERMINAL_FONT_DESCRIPTION = M PLUS 1  Code 18
export RABBIT_TERMINAL_FONT_DESCRIPTION

1:
	rabbit gitopscon-rel.md --size 800,450 -f --use-gl

# 2:
# 	rabbit cozystack-csh.md --size 800,450 -f

# 1:
# 	rabbit flux-basics.md --size 800,450 -f --initial-slide=1
# 
# 1.pdf:
# 	rabbit -p -o flux-basics.pdf flux-basics.md --size 800,450
# 
# 2:
# 	rabbit flux-bootstrap.md --size 800,450 -f --initial-slide=1
# 
3:
	rabbit flux-imageauto.md --size 800,450 -f --initial-slide=1
# 
# 4:
# 	rabbit flux-semver.md --size 800,450 -f --initial-slide=1
