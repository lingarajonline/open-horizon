#!/bin/bash

# args
if [ ! -z "${1}" ]; then DIR="${1}"; else DIR="horizon"; echo "+++ WARN $0 $$ -- directory unspecified; default: ${DIR}" &> /dev/stderr; fi
if [ ! -z "${2}" ]; then 
  SERVICE_TEMPLATE="${2}"
else
  SERVICE_TEMPLATE="service.json"
  echo "+++ WARN $0 $$ -- service template unspecified; default: ${SERVICE_TEMPLATE}" &> /dev/stderr
fi

# dependencies
if [ ! -d "${DIR}" ]; then echo "*** ERROR $0 $$ -- cannot locate directory ${DIR}; exiting"; exit 1; fi
if [ ! -s "${SERVICE_TEMPLATE}" ]; then echo "*** ERROR $0 $$ -- cannot locate service template JSON ${SERVICE_TEMPLATE}; exiting"; exit 1; fi

# service definition 
SERVICE_DEFINITION="${DIR}/service.definition.json"
if [ ! -s "${SERVICE_DEFINITION}" ]; then echo "*** ERROR $0 $$ -- cannot locate service JSON ${SERVICE_DEFINITION}; exiting"; exit 1; fi
SERVICE_URL=$(jq -r '.url' ${SERVICE_DEFINITION})

# user input
USERINPUT="${DIR}/userinput.json"
if [ ! -s "${USERINPUT}" ]; then echo "*** ERROR $0 $$ -- cannot locate userinput JSON ${USERINPUT}; exiting"; exit 1; fi

# check mandatory variables (i.e. those whose value is null in template)
for evar in $(jq -r '.userInput[]|select(.defaultValue==null).name' "${SERVICE_TEMPLATE}"); do 
  VAL=$(jq -r '.services[]|select(.url=="'${SERVICE_URL}'").variables|to_entries[]|select(.key=="'${evar}'").value' ${USERINPUT}) 
  if [ "${VAL}" == 'null' ]; then 
    if [ ! -s "${evar}" ]; then 
      echo "*** ERROR $0 $$ -- variable ${evar} has no default and value is null; create file named ${evar} with JSON content; exiting"
      exit 1
    else
      VAL=$(cat "${evar}")
      UI=$(jq -c '(.services[]|select(.url=="'${SERVICE_URL}'").variables.'${evar}')|='${VAL} "${USERINPUT}")
      echo "${UI}" > "${USERINPUT}"
      echo "+++ INFO $0 $$ -- setting ${evar} to ${VAL}"
    fi
  fi
done
