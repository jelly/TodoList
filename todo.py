#!/usr/bin/python
import os, sys, string

# the todolist
filename = "/home/jelle/Projects/progsel/todo.txt"

#status

def help_message():
	print '''todo.py -- an simple CLI todolist editor

	Usage:
		-s, 	--search 		search the todofile with max 3 keywords
		-v, 	--view 			view the todofile
		-a, 	--add 			add an item to the todofile
		-r, 	--remove 		remove an line from the todofile'''
	exit(0)

# search
def search(keyword):
	keywords = len(keyword)
	try:
		f = open(filename,"r")
	except IOError:
		print 'cannot open', filename
	else:
		if keywords == 1:
			for line in f:
				if line.rfind(keyword[0]) != -1:
					print line.replace('\n',' ',1)
		elif keywords == 2:
			for line in f:
				if line.rfind(keyword[0]) != -1  and line.rfind(keyword[1]) != -1:
					print line.replace('\n',' ',1)
		elif keywords == 3:
			for line in f:
				if line.rfind(keyword[0]) != -1  and line.rfind(keyword[1]) != -1 and keyword[2] != -1:
					print line.replace('\n',' ',1)

	f.close()


# add numbers to output
# view the todolist
def view():
	try:
		f = open(filename,"r")
	except IOError:
		print 'cannot open', filename
	else:
		x = 1
		for line in f:
			print str(x) + '. ' + line.replace('\n',' ',1)
			x = x + 1
		f.close()



# add an todo item
# argument string
def add(text):
	newline = ''
	for item in text:
		newline += item + ' ' 
	newline += '\n'
	
	try:
		f = open(filename,"a")
	except IOError:
		print 'cannot open', filename
	else:
	#	lines = 1
	#	for line in open(filename,"r"): 
	#		lines = lines + 1
#
#		newline = str(lines) + '. ' + newline 
		f.write(newline)
		f.close()
	
# remove an linenumber
def remove(line):
	line = line -1
	try:
		f = open(filename,"r")
	except IOError:
		print 'cannot open', filename
	else:
		# store the data
		data = f.readlines()
		f.close()

		# modify data
		del data[line]

		# write modified data
		f = open(filename,"w")
		f.writelines(data)
		f.close()



# Parsing of arguments
try:
	if len(sys.argv) == 1:
		help_message()

	arg = sys.argv[1]
	oper = sys.argv[2:]

	if arg == '-s':
		if len(oper) == 0:
			print "please insert an argument please"
		else:
				search(oper)
	elif arg == '-v':
		view()
	elif arg == '-a':
		add(oper)
	elif arg == '-r':
		if len(oper) == 1:
			remove(int(oper))
		else:
			print "arguments needs to be one number."

	else:	
		help_message()
except:
	pass
			




