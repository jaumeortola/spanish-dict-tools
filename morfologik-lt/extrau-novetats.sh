#!/bin/bash

###
# Extrau les novetats introduïdes en el diccionari LT
# respecte a l'última versió compilada
###

#directori LanguageTool
#lt_tools=~/github/languagetool/languagetool-tools/target/languagetool-tools-3.5-SNAPSHOT-jar-with-dependencies.jar
#lt_tools=~/languagetool/languagetool.jar
lt_tools=~/target-lt/languagetool.jar

# dump the tagger dictionary
java -cp $lt_tools org.languagetool.tools.DictionaryExporter -i es-ES.dict -o es-ES_lt.txt -info es-ES.info

cp es-ES_lt.txt diccionari_antic.txt
echo "Preparant diccionari"
sed -i 's/^\(.*\)\t\(.*\)\t\(.*\)$/\1 \2 \3/' diccionari_antic.txt
echo "Ordenant diccionari"
export LC_ALL=C && sort -u diccionari_antic.txt -o diccionari_antic.txt
echo "Comparant diccionaris"
diff ../resultats/lt/diccionari.txt diccionari_antic.txt > diff.txt

echo "Extraient novetats"
grep -E "^< " diff.txt > novetats_amb_tag.txt
sed -i 's/^< //g' novetats_amb_tag.txt
sed -i 's/ /\t/g' novetats_amb_tag.txt
cp novetats_amb_tag.txt novetats_sense_tag.txt
sed -i 's/^\(.*\)\t\(.*\)\t\(.*\)$/\1/' novetats_sense_tag.txt
sed -i '/^\s*$/d' novetats_sense_tag.txt
export LC_ALL=C && sort -u novetats_sense_tag.txt -o novetats_sense_tag.txt
cat spelling.head novetats_sense_tag.txt > spelling.txt
cat manual-tagger.head novetats_amb_tag.txt > manual-tagger.txt
cp manual-tagger.txt /home/jaume/github/languagetool/languagetool-language-modules/es/src/main/resources/org/languagetool/resource/es/
cp spelling.txt /home/jaume/github/languagetool/languagetool-language-modules/es/src/main/resources/org/languagetool/resource/es/

echo "Extraient paraules esborrades"
grep -E "^> " diff.txt > removed.txt
sed -i 's/^> //g' removed.txt
sed -i 's/ /\t/g' removed.txt
sed -i '/^\s*$/d' removed.txt
#cp novetats_amb_tag.txt novetats_sense_tag.txt
#sed -i 's/^\(.*\)\t\(.*\)\t\(.*\)$/\1/' novetats_sense_tag.txt
#sed -i '/^\s*$/d' novetats_sense_tag.txt
#export LC_ALL=C && sort -u novetats_sense_tag.txt -o novetats_sense_tag.txt
#cat spelling.head novetats_sense_tag.txt > spelling.txt
cat removed-tagger.head removed.txt > removed-tagger.txt
cp removed-tagger.txt /home/jaume/github/languagetool/languagetool-language-modules/es/src/main/resources/org/languagetool/resource/es/
#cp spelling.txt /home/jaume/github/languagetool/languagetool-language-modules/es/src/main/resources/org/languagetool/resource/es/

echo "Resultats en spelling.txt manual-tagger.txt removed-tagger.txt"

rm diff.txt
rm manual-tagger.txt
rm removed-tagger.txt
rm removed.txt
rm spelling.txt
rm novetats*
