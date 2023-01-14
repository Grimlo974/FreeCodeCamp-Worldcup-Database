#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate table games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER_NAME OPPONENT_NAME WINNER_GOALS OPPONENT_GOALS
do
  # Skip first line
  if [[ $YEAR != year ]]
  then
    # Get team_id of the winner
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER_NAME'")
    
    # If not exists
    if [[ -z $WINNER_ID ]]
    then
      # Create team
      INSERT_TEAM=$($PSQL "insert into teams (name) values ('$WINNER_NAME')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER_NAME

        # Get team_id of the winner
        WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER_NAME'")
      fi
    fi

    # Get team_id of the opponent
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT_NAME'")
    
    # If not exists
    if [[ -z $OPPONENT_ID ]]
    then
      # Create team
      INSERT_TEAM=$($PSQL "insert into teams (name) values ('$OPPONENT_NAME')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT_NAME

        # Get team_id of the opponent
        OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT_NAME'")
      fi
    fi

    #Insert game
    INSERT_GAME=$($PSQL "insert into games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) values ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS) ")
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
      then
        echo Inserted into games, $ROUND $WINNER_NAME $OPPONENT_NAME
      fi
  fi
done
