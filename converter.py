#!/usr/bin/python
from shutil import copyfile

# # Using readlines()
# Open a file with access mode 'a'
copyfile('E3DC-Export.csv', 'e3dc_converted.csv')
file_object = open('e3dc_converted.csv', 'a')
# file_object.write('\n')
print(file_object.seek(1))
# lines = file_object.readlines()
# print(lines[0])
# print(lines[-1])
file_object.close()
