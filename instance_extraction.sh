#!/bin/bash

# Reset txt file
echo "" > /root/script/extractionOCI.txt

# Configure the compartment ID
compartment_coll="#INSERT HERE YOUR COMPARTMENT ID#"
compartment_prod="#INSERT HERE YOUR COMPARTMENT ID#"

# Function to get running instances of a compartment
get_instances() {
    compartment_id=$1
    /root/bin/oci compute instance list --compartment-id $compartment_id --all --raw-output | /bin/jq -r '.data[] | select(.["lifecycle-state"] == "RUNNING") | .["display-name"]'
}

# Get instances in the test compartment
echo "Instances in the test compartment:" >> /root/script/extractionOCI.txt
get_instances "$compartment_coll" >> /root/script/extractionOCI.txt

echo "" >> /root/script/extractionOCI.txt

# Get instances in the production compartment
echo "Instances in the production compartment:" >> /root/script/extractionOCI.txt
get_instances "$compartment_prod" >> /root/script/extractionOCI.txt

(echo -e "To: #INSERT HERE YOUR MAIL#\nSubject: Extracting OCI instances of the $(date '+%d-%m-%Y')\nFrom: #INSERT HERE THE MAIL FROM WHICH TO SEND THE EMAIL#\n"; cat /root/script/extractionOCI.txt) | /sbin/sendmail -t
