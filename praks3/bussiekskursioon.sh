#!/bin/bash
# Autor: [Joonas]
# Kuupäev: 08.09.2025
# Kirjeldus: Arvutab täidetud busside arvu ja ülejäänud reisijate arvu

echo -n "Sisesta reisijate arv grupis: "
read reisijad

echo -n "Sisesta kohtade arv ühes bussis: "
read kohad

# Arvutame täisbusse ja ülejääke
taisbussid=$(expr $reisijad / $kohad)
ulejaanud=$(expr $reisijad % $kohad)

echo ""
echo "Täielikult täidetud busse: $taisbussid"
echo "Mahajäänud inimesi (ei mahu täis bussi): $ulejaanud"
