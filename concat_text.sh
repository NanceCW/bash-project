#!/bin/bash

#global variables
input_directory=''
input_text_file_names=''
output_directory=''
output_text_file_name=''

#display usage information (used in -h argument and if no arguments provided)
function display_usage() {
    echo "Usage of concat-text.sh -i <input_directory> -t <input_text_file_names> -o <output_directory> -f <output_text_file_name>"
    echo "Options:"
    echo "  -i <input_directory> Specify the directory that includes the input text files (Leave blank if file is in current directory, must end with '/')."
    echo "  -t '<input_text_file_names>' Specify the names of the text files to be concatenated (Include extension, must be enclosed in quotations, must be separated by spaces)."
    echo "  -o <output_directory> Specify the output directory of the concatenated text file (Leave blank to create in current directory, must end with '/')."
    echo "  -f <output_text_file_name> Specify the name of the concatenated text file (Include extension, must be encloed in quotations)."
    echo "  (arguments -t and -f are required)"
}

#display usage if no arguments given or if -h argument used
if [[ $# -eq 0 || "$1" == "-h" ]]; then
    display_usage
    exit 0
fi

#arguments
while getopts ":i:t:o:f:" opt; do
    case $opt in
        i) #option i
            input_directory=$OPTARG
            ;;
        t) #option t
            input_text_file_names=$OPTARG
            ;;
        o) #option o
            output_directory=$OPTARG
            ;;
        f) #option f
            output_text_file_name=$OPTARG
            ;;
        h) #usage info
            display_usage
            exit 0
            ;;
        \?) #any other value
            echo "Invalid Option: -$OPTARG"
            display_usage
            exit 1
            ;;
        :) #no argument given
            echo "Option -$OPTARG requires an argument"
            display_usage
            exit 1
            ;;
    esac       
done

#check if -t and -f arguments are provided (input and output text file names are required)
if [[ $input_text_file_names == "" ]]; then
    echo "Input text file names are required (-t)"
    display_usage
    exit 1
fi
if [[ $output_text_file_name == "" ]]; then
    echo "Output text file name is required (-f):"
    display_usage
    exit 1
fi

#check if provided input and output directories exist and are formatted correctly
if [[ ! -d $output_directory && $output_directory != '' ]]; then
    echo "Output directory ($output_directory) does not exist"
    echo "Make sure path is in the form '/path/to/directory/'"
    exit 1
elif [[ ! -d $input_directory && $input_directory != '' ]]; then
    echo "Input directory ($input_directory) does not exist"
    echo "Make sure path is in the form '/path/to/directory/'"
    exit 1
fi

if [[ -d $output_directory && ! "$output_directory" =~ /$ ]]; then
    echo "Output directory ($output_directory) is incorrectly formatted"
    echo "Make sure path is in the form /path/to/directory/'"
    exit 1
elif [[ -d $input_directory && ! "$input_directory" =~ /$ ]]; then
    echo "Input directory ($input_directory) is incorrectly formatted"
    echo "Make sure path is in the form /path/to/directory/'"
    exit 1
fi

#check if the output text file name provided is correctly formatted (.txt at the end)
if [[ ! "$output_text_file_name" =~ \.txt$ ]]; then
    echo "Output file name ($output_text_file_name) is incorrectly formatted"
    echo "File should end in '.txt'"
    exit 1
fi

#check if the input text file names provided exist and are correctly formatted (.txt at the end)
read -a input_name_array <<< $input_text_file_names
for element in "${input_name_array[@]}"; do
    if [[ ! "$element" =~ \.txt$ ]]; then
        echo "Input file name ($element) is incorrectly formatted"
        echo "File should end in '.txt'"
        exit 1
    fi
    if [[ ! -e "$element" && $input_directory == '' ]]; then
        echo "Input text file '$element' does not exist in this directory"
        exit 1
    elif [[ ! -e "$input_directory$element" && $input_directory != '' ]]; then
        echo "Input text file '$element' in directory '$input_directory' does not exist"
        exit 1
    fi
done

#execute the cat function, which concatenates text files. all scenarios (depending on args used) are accounted for
#neither output or input directories are specified
if [[ $input_directory == '' && $output_directory == '' ]]; then
    cat $input_text_file_names > $output_text_file_name
    echo "'$output_text_file_name' has been created!"
    exit 0
fi

#output dir specified, but not input dir
if [[ $input_directory == '' && $output_directory != '' ]]; then
    cat $input_text_file_names > $output_directory$output_text_file_name
    echo "'$output_text_file_name' has been created in '$output_directory'!"
    exit 0
fi

#input dir specified, but not output dir
cat_result=''
if [[ $input_directory != '' && $output_directory == '' ]]; then
    for file in $input_text_file_names; do
        cat_result="$cat_result$input_directory$file "
    done
    cat $cat_result > $output_text_file_name
    echo "'$output_text_file_name' has been created"
    exit 0
fi

#both input and output are directories are specified
cat_result=''
if [[ $input_directory != '' && $output_directory != '' ]]; then
    for file in $input_text_file_names; do
        cat_result="$cat_result$input_directory$file "
    done
    cat $cat_result > $output_directory$output_text_file_name
    echo "'$output_text_file_name' has been created in '$output_directory'!"
    exit 0
fi
