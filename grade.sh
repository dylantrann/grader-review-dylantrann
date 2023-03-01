CPATH='.;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar'

set -e 

#Step 1: Clone student submission
rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'
cd student-submission

#Step 2: Check if file exists
if [[ -f ListExamples.java ]]
then 
    echo 'ListExamples.java found'
else 
    echo 'ListExamples.java not found'
    exit 1 
fi 

#Step 3 Get tester into same directory as student file
mv ListExamples.java ..

#Step 4: Compile test and student file
set +e
cd ..

javac -cp $CPATH ListExamples.java TestListExamples.java 2> compile-output.txt

if [[ $? -eq 0 ]]
then
    echo "Compile successful"
else
    echo "Compile failed"
    cat compile-output.txt
    exit $?
fi

#Step 5: Run the code
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > run-output.txt 

grepCount=`grep -c "OK" run-output.txt`

if [[ $grepCount -eq 0 ]]
then
    echo "Test failed"
else
    echo "Test passed"
fi