#!/bin/bash

rm -rf ./hello_world_service
autonomy packages lock
autonomy push-all
autonomy fetch valory/hello_world:0.1.0 --local --service --alias hello_world_service; cd hello_world_service
autonomy build-image
autonomy generate-key ethereum -n 4

# Lee el archivo keys.json y extrae las direcciones
addresses=$(jq -r '.[].address' keys.json)

# Construye la lista de direcciones en el formato requerido
address_list="["
for address in $addresses; do
  address_list+="\"$address\", "
done

# Elimina la última coma y espacio, y cierra el corchete
address_list="${address_list%, }]"
export_command="export ALL_PARTICIPANTS='$address_list'"
echo $export_command

eval $export_command

# Verifica que la variable ALL_PARTICIPANTS ha sido exportada
echo "Variable ALL_PARTICIPANTS establecida a:"
echo $ALL_PARTICIPANTS


autonomy deploy build ./keys.json -ltm

autonomy deploy run --build-dir ./abci_build/
