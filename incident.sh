#!/bin/bash

# Dependancies to run; wget, poppler


urls=(
    #Passenger data
    "https://crashstats.nhtsa.dot.gov/Api/Public/ViewPublication/813592"
    # Large Truck data
    "https://crashstats.nhtsa.dot.gov/Api/Public/ViewPublication/813588"
    #Motorcycle Data
    "https://crashstats.nhtsa.dot.gov/Api/Public/ViewPublication/813589"
)

pdf_files=(
    "passenger_data.pdf"
    "large_truck_data.pdf"
    "motorcycle_data.pdf"
)

html_files=(
    "passenger_data.html"
    "large_truck_data.html"
    "motorcycle_data.html"
)

# Download file
download_pdfs() {
    for i in "${!urls[@]}"; do
        pdf_file="${pdf_files[$i]}"

        # Check if the PDF file already exists
        if [ ! -f "$pdf_file" ]; then
            # Download the PDF file
            wget "${urls[$i]}" -O "$pdf_file"
            echo "Downloaded $pdf_file"
        else
            echo "$pdf_file already exists, skipping download."
        fi
    done
}

# Function to convert PDFs to HTML
convert_to_html() {
    for i in "${!pdf_files[@]}"; do
        pdf_file="${pdf_files[$i]}"
        html_file="${html_files[$i]}"

        # Check if the HTML file already exists
        if [ ! -f "$html_file" ]; then
            # Convert the PDF to HTML
            pdftohtml "$pdf_file" "$html_file"
            echo "Converted $pdf_file to $html_file"
        else
            echo "$html_file already exists, skipping conversion."
        fi
    done
}

extract_motorcycle_data() {
     # Define the file variable correctly
    html_file="motorcycle_datas.html"

    # Define table identifiers and column headers
    table_start_tag="<b>Table 1. Motorcyclists Killed and Injured in Traffic Crashes, and Fatality and Injury Rates, 2013-2022</b>"
    table_end_tag="</table>"

    # Extract the table section from the HTML file
    table_section=$(sed -n "/$table_start_tag/,/$table_end_tag/p" "$html_file")

    # Extract the row for the year 2022
    year_row=$(echo "$table_section" | grep -A 10 "2022" | grep -m 1 "2022")

    # Extract the data for "Killed" from the 2022 row
    killed=$(echo "$year_row" | awk -F'<br/>' '{print $1}' | sed 's/.*\([0-9,]*\)\*?.*/\1/')

    echo "Motorcyclists killed in 2022: $killed"
}

download_pdfs
convert_to_html
extract_motorcycle_data
