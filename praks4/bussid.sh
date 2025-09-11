#!/bin/bash
# Busside arvutamise skript
# Skript küsib reisijate ja bussikohtade arvu ning arvutab,
# mitu bussi on vaja, et kõik reisijad mahuksid ära.

# Küsi andmed
read -p "Sisesta reisijate arv: " reisijad
read -p "Sisesta kohtade arv bussis: " kohad

# Arvuta täisbussid
bussid=$(($reisijad / $kohad))

# Kontrolli, kas jäi üle reisijaid
ylejaanud=$(($reisijad % $kohad))

if [ $ylejaanud -gt 0 ]; then
    bussid=$(($bussid + 1))
fi

# Väljasta tulemus
echo "Kokku on vaja $bussid bussi"
