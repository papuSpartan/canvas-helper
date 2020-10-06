JSONFILE="response.json"
BASEURL="https://courses.letu.edu/api/v1/"
TOKENFILE="token"
TOKEN=$(head -1 $TOKENFILE)

#notable api endpoints
#/users/activity_stream
#/courses

#pull json from canvas todolist api
curl ${BASEURL}users/self/todo/?access_token=${TOKEN} > $JSONFILE

#find length of array/amount of assignments
arrlen=$(jq '. | length' $JSONFILE;)


#say how many things there are left todo
echo "$arrlen things to do"

#iterate through all items and print name and due date of assignment
for (( i=0; i<$arrlen; i++))
do
	#set due date for item to variable in subshell so it doesn't print
	rawduedate=$(jq -r ".[$i]."assignment"."due_at"" $JSONFILE)

	#print $i/assignment name
	jq -r ".[$i]."assignment"."name"" $JSONFILE

	#due_date object for some reason stores time in zulu
	#print $i/assignment due date by passing $rawduedate to 'date -d'
	date -d "$rawduedate"
done

#sorting assignments isn't necessary because the api sorts them by date due already
