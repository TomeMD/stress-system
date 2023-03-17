#!/bin/bash

USER_SPEC_CORES=$(echo ${CORES_LIST} | awk -F ',' '{print NF}')
MAX_LOAD=$(($USER_SPEC_CORES * 100))

if [[ $LOAD -ge $MAX_LOAD ]]; then
  m_warn "Too high load specified for the available cores"
  m_warn "Maximum load that can be executed with $USER_SPEC_CORES cores is $MAX_LOAD%"
  m_warn "Setting $MAX_LOAD as the new load value"
  LOAD=$MAX_LOAD
fi

CORES_TO_LOAD=""
RES_LOAD=$LOAD
NUM_CORES=1

while [[ $RES_LOAD -gt 100 ]]; do

  CORE=$(echo $CORES_LIST | cut -d',' -f$NUM_CORES)

  if [[ ! -z "$CORE" ]]; then
    if [[ ! -z "$CORES_TO_LOAD" ]]; then
      CORES_TO_LOAD="$CORES_TO_LOAD,$CORE"
    else
      CORES_TO_LOAD="$CORE"
    fi
  fi
  RES_LOAD=$((RES_LOAD-100))
  NUM_CORES=$(($NUM_CORES + 1))
done

CORE=$(echo $CORES_LIST | cut -d',' -f$NUM_CORES)
if [[ ! -z "$CORES_TO_LOAD" ]]; then
  CORES_TO_LOAD="$CORES_TO_LOAD,$CORE"
else
  CORES_TO_LOAD="$CORE"
fi

m_echo "Load will be distributed among $NUM_CORES cores [$CORES_TO_LOAD]"
m_echo "Last core load: $RES_LOAD"

# Run CPU load using stress-ng I times
for ((i=0; i<$ITERATIONS; i++)); do

  # Distribute CPU load among cores
  for ((j=0; j<$NUM_CORES; j++)); do

    CORE=$(echo $CORES_TO_LOAD | cut -d',' -f$(($j+1)))

    if [[ "$j" -eq "(($NUM_CORES - 1))" ]]; then
      run_test $CORE $RES_LOAD $((i+1)) &
    else
      run_test $CORE 100 $((i+1)) &
    fi

  done

  # Wait for all stressors to finish
  wait 
  STATUS=$?
  if [[ "$STATUS" -eq "0" ]]; then
    m_echo "Iteration $(($i + 1)): Stress tests finished successfully"
  else
    m_err "Iteration $(($i + 1)): Stress tests went wrong"
    m_err "Some test didn't finished successfully (STATUS = $STATUS)"
  fi

done
