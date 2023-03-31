#!/bin/bash

#THIS SCRIPT WILL APPLY THE RECOMMENDATION WHICH ARE APPROVED BY REVIEWER

#DECLARING THE VARAIABLES
RECOMMEDNATION="/tmp/recommendation"
tail -n1 file.config > ${RECOMMEDNATION}
read RECOMMENDED < ${RECOMMEDNATION}

if [[ ${RECOMMENDED} = CHANGE_MACHINE_TYPE ]]
then
    echo "${RECOMMENDED}"
    sed -n '/Resource Name:/,/Machine Type:/{/Resource Name:/!{/Machine Type:/!p}}' file.config > resources.log
    sed -n '/Machine Type:/,/Location:/{/Machine Type:/!{/Location:/!p}}' file.config > machinetype.log
    while read -r RESOURCE
    do
        RESOURCE_NAME="${RESOURCE}"
        while read -r IGNORE_RESOURCES
        do
            IGNORE_LIST="${IGNORE_RESOURCES}"
            if [[ ${RESOURCE_NAME} != ${IGNORE_LIST} ]]
            then
                sed -n '/Machine Type:/,/Location:/{/Machine Type:/!{/Location:/!p}}' file.config > machinetype.log
                while read -r MACHINE
                do
                    MACHINETYPE="${MACHINE}"
                    echo "Resource Name: ${RESOURCE_NAME}"
                    echo "Machine Type: ${MACHINETYPE}"
                    printf 'yes' | gcloud compute instances stop $RESOURCE_NAME --zone=us-east1-b
                    printf 'yes' | gcloud compute instances set-machine-type $RESOURCE_NAME --machine-type $MACHINETYPE --zone=us-east1-b
                    printf 'yes' | gcloud compute instances start $RESOURCE_NAME --zone=us-east1-b
                done < machinetype.log
            fi 
        done < ignore_list.log
    done < resource.log 
fi

if [[ ${RECOMMENDED} = DELETE_IMAGE ]]
then
    echo "${RECOMMENDED}"
    sed -n '/Resource Name:/,/Action:/{/Resource Name:/!{/Action:/!p}}' file.config
fi
