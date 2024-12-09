#!/bin/bash

#Folder to monitor
WATCH_FOLDER="/data/input"
echo "Watching folder: $WATCH_FOLDER"

#Output folder
OUTPUT_FOLDER="/data/output"
echo "Files will be outputted to : $OUTPUT_FOLDER"

#Function to handle new file found in the watch folder
handle_new_file() {
  filepath="$1"

  if echo "$filepath" | grep -q '\.epub$'; then
    convert_to_kepub "$filepath"
    rm "$filepath"
  else
    move_to_output "$filepath"
  fi
}

# Function to convert eBooks
# .epub: Convert to .kepub
# other: copy to output
convert_to_kepub() {
  filepath="$1"
  echo "Converting $filepath to .kepub"
  ./kepubify --inplace --update --calibre --output "$OUTPUT_FOLDER" "$filepath"
}

# Move the file to the output folder
move_to_output() {
  filepath="$1"
  echo "Moving $filepath to output folder"
  mv "$filepath" "$OUTPUT_FOLDER"
}

#Monitor folder for new files
inotifywait -m -r --format="%e %w%f" -e close_write -e moved_to "$WATCH_FOLDER" |
while read -r events filepath; do
  echo "New file detected: $filepath"
  handle_new_file "$filepath"
done