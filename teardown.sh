# super lazy kill, just stops anything that matches the term 'boglserver'
# this is very crude, but works rather simply
# NOTE: This assumes the user is 'ubuntu', change as necessary
kill `ps -U ubuntu | grep -E "boglserver"`
