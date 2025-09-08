#!/bin/bash
# Autor: [Joonas]
# Kuupäev: 08.09.2025
# Kirjeldus: Arvutab ühe nädala eeldatava ajakulu EAP ja nädalate alusel

echo -n "Sisesta ainepunktide arv: "
read eap

echo -n "Sisesta nädalate arv: "
read nadalad

# Arvutame koguaega
koguaeg=$(echo "$eap * 26" | bc)

# Arvutame nädala ajakulu (reaalarv)
aeg=$(echo "scale=1; $koguaeg / $nadalad" | bc)

# Ümardame ülespoole
aeg_ymarda=$(echo "($aeg + 0.9)/1" | bc)

# Väljund
echo "Ühe nädala eeldatav ajakulu on $aeg_ymarda tundi"
