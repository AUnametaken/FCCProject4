#!/bin/bash
if [[ -z $1 ]]
then
	echo -e "Please provide an element as an argument."
else
	PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
	GET_ELEMENT_RESULT=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE CAST(atomic_number AS VARCHAR)='$1' OR symbol ILIKE '$1' OR name ILIKE '$1'") # Amazing, casting a column in the WHERE works, so I can use one unifying check instead of having to determine whether the argument is a string or integer beforehand! Also, note the use of ILIKE for more input support. I'm so smart.
  if [[ -z $GET_ELEMENT_RESULT ]]
	then
		echo -e "I could not find that element in the database."
	else
		read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE < <(IFS="|"; echo $GET_ELEMENT_RESULT ) # I love this.
		echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
	fi
fi
