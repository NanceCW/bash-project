# TextTaco
**TextTaco** is a lightweight script designed to concatenate any number of text files (from any directory) into _one_ text file (into any directory).

### Overview
Provide the input text files, input directory (optional), output text file name, and output directory (optional). <br/>
Input and Output directory arguments are optional because if there is no argument provided, TextTaco will use the directory the script resides in.

### Why use TextTaco?
TextTaco is a handy tool for those who frequently use text files. If you've ever needed to copy the contents of one text file to another, you would know how annoying it can be hopping back and forth. TextTaco eliminates the need to do so. All you need is one line in the terminal!

### Usage Tips
To run the script, you must navigate to the folder of which the script resides in Terminal (I would recommend storing it somewhere that is easily accessible). Then, call the script "./concat_text.sh". You can use the "-h" argument to learn the list of available arguments. After successfully running the script, you will be notified that your files have been concatenated to a singular text file and where that text file resides. Should there be an error with running the script, there is error handling in place to notify you what went wrong. Happy texting!
