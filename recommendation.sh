#!/bin/bash

#THIS SCRIPT WILL FTECH THE GOOGLE RECOMMEDNATION THROUGH GOOGLE API

#DECLARAING THE VARAIABLE
BRANCH=${RANDOM}
PROJECT_ID=$(gcloud config get-value project)
FILENAME=${1}
GCP_LOCATION=${2}
git checkout -b "${BRANCH}"

#CHECKING FOR THE FILENAME
if [[ ${#} -lt 1 ]]
then
    echo "Kindly provide the filename"
    exit 1
fi

#CHECKING FOR REOMMENDATION AND GENERATING RECOMMENDATION
if [[ ${FILENAME} = "machinetype" ]]
then
    #gcloud recommender recommendations list --recommender=google.compute.instance.MachineTypeRecommender --project=$PROJECT_ID --location=$GCP_LOCATION --format=json > ${FILENAME}.json
    DESCRIPTION=$( jq -r '.[].description' < ${FILENAME}.json )
    RESOURCE=$( jq -r '.[].content.overview.resourceName' < ${FILENAME}.json )
    MACHINETYPE=$( jq -r '.[].content.overview.recommendedMachineType.name' < ${FILENAME}.json )
    LOCATION=$( jq -r '.[].content.overview.location' < ${FILENAME}.json )
    ACTION=$( jq -r '.[].recommenderSubtype' < ${FILENAME}.json )
    printf "Description:\n${DESCRIPTION}\nResource Name:\n${RESOURCE}\nMachine Type:\n${MACHINETYPE}\nLocation:\n${LOCATION}\nAction:\n${ACTION}" > files.config
    chmod 777 files.config
    chmod 777 ${FILENAME}.json
fi

if [[ ${FILENAME} = "idleimages" ]]
then
    #gcloud recommender recommendations list --project=$PROJECT_ID --billing-project=$PROJECT_ID --recommender=google.compute.image.IdleResourceRecommender --location=$GCP_LOCATION --format=json > ${FILENAME}.json
    DESCRIPTION=$( jq -r '.[].description' < ${FILENAME}.json )
    RESOURCE=$( jq -r '.[].content.overview.resourceName' < ${FILENAME}.json )
    LOCATION=$( jq -r '.[].content.overview.location' < ${FILENAME}.json )
    ACTION=$( jq -r '.[].recommenderSubtype' < ${FILENAME}.json )
    printf "Descriptions:\n${DESCRIPTION}\nResource Name:\n${RESOURCE}\nLocation:\n${LOCATION}\nAction:\n${ACTION}" > files.config
    chmod 777 files.config
    chmod 777 ${FILENAME}.json
fi

git add *
git commit -m "${DESCRIPTION}"
git push origin "${BRANCH}":"${BRANCH}"
hub pull-request -m "merge "${BRANCH}"approve merge to apply recommendation"