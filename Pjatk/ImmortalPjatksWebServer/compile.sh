#!/bin/bash
name=$1

if [[ "$name" == *.* ]] then 
	echo wrong extension
else
	as -o "${name}.o" "${name}.s"
	ld -o $name "${name}.o"
fi
