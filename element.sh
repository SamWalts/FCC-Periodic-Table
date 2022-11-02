#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

function INTRO(){
if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  SEARCH $1
fi
}
#argument as a number
function SEARCH() {

if [[ $1 =~ ^[1-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT * FROM properties INNER JOIN elements USING(atomic_number) WHERE atomic_number=$1;")
#argument as a symbol
else
  ELEMENT=$($PSQL "SELECT * FROM properties INNER JOIN elements USING(atomic_number) WHERE (name='$1' OR symbol = '$1');")
#argument as a name
fi

#if no result or is null
if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
#get info about the element
else
  echo $ELEMENT | while read ATOMIC_NUM BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE_ID BAR SYMBOL BAR NAME
#find table types using type_id
do
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID;")
echo -e "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a$TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done
fi
}

INTRO $1
