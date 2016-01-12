
function exitProgram {
    cp "$TEST_DIR/pa1f_orginal.c" pa1f.c
    rm my_output standard_output
    exit
}


TEST_DIR="./tests"
FAILED_TEST=0
for testfile in `ls $TEST_DIR`; do
    echo "Testing file: $testfile ..."
    cp "$TEST_DIR/$testfile" pa1f.c
    make > /dev/null
    ./pa1f &> tmp
    tail +2 tmp > my_output
    ./pa1f_standard &> tmp
    tail +2 tmp > standard_output
    rm tmp
    diff my_output standard_output > /dev/null
    if [ $? -ne 0 ]; then
        FAILED_TEST=`expr $FAILED_TEST + 1`
        vimdiff my_output standard_output 2> /dev/null
        
        read -p "Do you wish to continue?[y/n] " yn
        case $yn in
            [Yy]* ) continue;;
            * ) echo "Exiting the program..."; exitProgram;;
        esac
    else
        echo "$testfile passed."
    fi
done
if [[ $FAILED_TEST -eq 0 ]]; then
    echo "ALL TESTS have passed!"
fi
exitProgram
