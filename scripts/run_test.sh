#######################################
# Auto Testing Software for Project-G #
# Designed for Development of Game    #
# By Zhifan (Xiaobai) Li              #
# Version 0.0.3                       #
#######################################

#######################################
# Note:                               #
# This script is a shell script,      #
#   meaning that it should only be    #
#   used in Linux environment.        #
#                                     #
# If bash denies the permission,      #
#   use the following command:        #
#   "+chmod +x run_test.sh".          #
#                                     #
#######################################

#!/bin/bash

#######################################
# Variables                           #
#######################################

# Colors Defined Here
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# File Defined Here
source="../src"
compiled="../compiled"
compiled_result="$compiled/compiled_result"
compile_err_file="$compiled/cp_res.txt"
test_folder="../tests"
test_in_folder="$test_folder/inputs"
test_out_folder="$test_folder/outputs"
test_out_act_folder="$test_folder/outputs-actual"
manual_test_out="$test_folder/manual_outputs"

# Variables Defined Here
test_with_auto=y

#######################################
# Scripts                             #
#######################################

# Checking if the src file can be found complain if not found then terminate
if [ ! -d "$source" ]; then
    echo -e "${RED}Error 901: \n${YELLOW}A build Error is found, missing key source folder. \n${RED}Testing Terminated...${NC}"
    exit 1
fi

if [ -d "$compiled" ]; then
    rm -r "$compiled"
fi

mkdir "$compiled"

# Prompt user for testing method
echo -ne "${YELLOW}Proceed with SFML compile.(y/N):${NC}" 
read compl_sfml

if [ "${test_with_auto,,}" = "y" ]; then 
    echo -e "${GREEN}Folder src gripped, compiles all file in src...${NC}"
    g++ -o "$compiled_result" "$source"/*.cpp -lsfml-graphics -lsfml-window -lsfml-system 2> "$compile_err_file"
else
    # Compile all C++ code files
    echo -e "${GREEN}Folder src gripped, compiles all file in src...${NC}"
    g++ -o "$compiled_result" "$source"/*.cpp 2> "$compile_err_file"
fi

# Check for any compilation errors complain if found then terminate
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Compile Finished...${NC}\n\n\n"
else
    echo -e "${RED}Error 902: \n${YELLOW}A build Error is found, there is an error in compilation, see \"..\\\\compiled\\\\cp_res.txt\" for more info. \n${RED}Testing Terminated...${NC}"
    exit 1
fi

# Prompt user for testing method
echo -ne "${YELLOW}Proceed with automatic testing(y/N):${NC} " 
read test_with_auto

if [ -d "$test_out_act_folder" ]; then
    rm -r "$test_out_act_folder"
fi
mkdir $test_out_act_folder

# Test with auto if yes is inputed
if [ "${test_with_auto,,}" = "y" ]; then 

    echo -e "${GREEN}Proceed with auto testing.${NC}\n\n\n" 

    if [ ! -n "$(find "$test_in_folder" -maxdepth 1 -type f -name '*.in')" ]; then
        echo -e "${RED}Error 921: \n${YELLOW}A test Error is found, can not find any test files that ends with \"*.in\". \n${RED}Testing Terminated...${NC}"
        rm -r "$compiled"
        exit 1
    fi

    for input_file in "$test_in_folder"/*.in; do

        # Extract file without the .in extension
        filename=$(basename "$input_file")
        f_name="${filename%.*}"
        f_in_name="$f_name.in"
        f_out_name="$f_name.out"

        # Generate the .out file
        echo -e "${GREEN}Testing $f_in_name, Generating $f_out_name...${NC}"
        ./"$compiled_result" --quite < "$input_file" > "$test_out_act_folder/$f_out_name"

        # Comparing the two .out files
        echo -e "${GREEN}Comparing $f_out_name in outputs and outputs-actual...${NC}"
        if cmp -s "$test_out_act_folder/$f_out_name" "$test_out_folder/$f_out_name"; then
            echo -e "${GREEN}f_name passed!${NC}\n"
        else
            echo -e "${RED}Error 922: \n${YELLOW}A test Error is found, test \"$f_name\" failed. \n${RED}Testing will continue...${NC}\n"
        fi
        
    done

    echo -e "\n\n"

# Test with manual setup
else

    echo -e "${GREEN}Proceed with manual testing.${NC}" 
    ./"$compiled_result"

fi

# Delete the compiled result at the end
echo -e "${GREEN}Testing Done, Terminates.${NC}"
rm -r "$compiled"
